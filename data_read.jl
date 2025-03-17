using Pkg, CSV, DataFrames, DynamicAxisWarping, Distances, Plots


#Read in asset-level prices
btcdf = CSV.read("btc_book-2024-08-01-trimmed.csv", DataFrame)
dgcdf = CSV.read("dgc_book-2024-08-01-trimmed.csv", DataFrame)
ltcdf = CSV.read("ltc_book-2024-08-01-trimmed.csv", DataFrame)
ethdf = CSV.read("eth_book-2024-08-01-trimmed.csv", DataFrame)

#trim dataframes for price/correlation variable calculation 
btcdf_trimmed = (select(btcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))[1:10,1:6]
ltcdf_trimmed = (select(ltcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))[1:10,1:6]
ethdf_trimmed = (select(ethdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))[1:10,1:6]
dgcdf_trimmed = (select(dgcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))[1:10,1:6]

#Calculate weighted average price column between ask and bid
btcdf_trimmed[!, "total_quantity"] = btcdf_trimmed[!,"best_ask_qty"]+ btcdf_trimmed[!,"best_bid_qty"]
btcdf_trimmed[!, "weighted_avg_price"] = ((btcdf_trimmed[!,"best_ask_qty"].*btcdf_trimmed[!,"best_ask_price"]) + (btcdf_trimmed[!,"best_bid_qty"].*btcdf_trimmed[!,"best_bid_price"]))./btcdf_trimmed[!, "total_quantity"]

ethdf_trimmed[!, "total_quantity"] = ethdf_trimmed[!,"best_ask_qty"]+ ethdf_trimmed[!,"best_bid_qty"]
ethdf_trimmed[!, "weighted_avg_price"] = ((ethdf_trimmed[!,"best_ask_qty"].*ethdf_trimmed[!,"best_ask_price"]) + (ethdf_trimmed[!,"best_bid_qty"].*ethdf_trimmed[!,"best_bid_price"]))./ethdf_trimmed[!, "total_quantity"]

ltcdf_trimmed[!, "total_quantity"] = ltcdf_trimmed[!,"best_ask_qty"]+ ltcdf_trimmed[!,"best_bid_qty"]
ltcdf_trimmed[!, "weighted_avg_price"] = ((ltcdf_trimmed[!,"best_ask_qty"].*ltcdf_trimmed[!,"best_ask_price"]) + (ltcdf_trimmed[!,"best_bid_qty"].*ltcdf_trimmed[!,"best_bid_price"]))./ltcdf_trimmed[!, "total_quantity"]

dgcdf_trimmed[!, "total_quantity"] = dgcdf_trimmed[!,"best_ask_qty"]+ dgcdf_trimmed[!,"best_bid_qty"]
dgcdf_trimmed[!, "weighted_avg_price"] = ((dgcdf_trimmed[!,"best_ask_qty"].*dgcdf_trimmed[!,"best_ask_price"]) + (dgcdf_trimmed[!,"best_bid_qty"].*dgcdf_trimmed[!,"best_bid_price"]))./dgcdf_trimmed[!, "total_quantity"]

twoddf = [[btcdf_trimmed] [ethdf_trimmed] [ltcdf_trimmed] [dgcdf_trimmed]]

for df in twoddf
     #convert milliseconds to days
     transform!(df, :transaction_time => ByRow(x -> floor(Int, x / 86400000)) => :day_group)
     #group dataframe by day
     gdf = groupby(df, :day_group)
     #within each group, divide the price by the first price (being done daily now)
     transform!(gdf, :weighted_avg_price => (prices -> prices ./ first(prices)) => :price_index)
end

#b1= Array(select(twoddf[1], "transaction_time"))[:,1]

#b2 = Array(select(twoddf[2], "transaction_time"))[:,1]

#a1= Array(select(twoddf[1], "weighted_avg_price"))[:,1]

#a2 = Array(select(twoddf[2], "weighted_avg_price"))[:,1]

#vector1 = hcat(a1, b1)
#vector2 = hcat(a2, b2)

#display(vector1)

#dtw(a1, a2)
#dtw(vector1, vector2)
#dtwplot(a1, a2, SqEuclidean(), transportcost = 1)
#dtwplot(vector1, vector2, SqEuclidean(), transportcost = 1)