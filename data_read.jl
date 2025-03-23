using Pkg, CSV, DataFrames, DynamicAxisWarping, Distances, Plots

#to pass first transaction_time available from each dataset
initial_time_df = []

#Read in asset-level prices
btcdf = CSV.read("..\\..\\Crypto Tick Data\\BTCUSDT\\BTCUSDT-bookTicker-2023-05.csv", DataFrame)
ltcdf = CSV.read("..\\..\\Crypto Tick Data\\BNBUSDT\\BNBUSDT-bookTicker-2023-05.csv", DataFrame)
ethdf = CSV.read("..\\..\\Crypto Tick Data\\ETHUSDT\\ETHUSDT-bookTicker-2023-05.csv", DataFrame)
dgcdf = CSV.read("..\\..\\Crypto Tick Data\\XRPUSDT\\XRPUSDT-bookTicker-2023-05.csv", DataFrame)

twoddf = [[btcdf] [ethdf] [ltcdf] [dgcdf]]

iterator = 1

for df in twoddf
     df = (select(df,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))
     push!(initial_time_df, first(df[!,"transaction_time"]))
     twoddf[iterator] = df

     iterator += 1

end

#constant to subtract from transaction_time column for each dataframe
subtract_time = minimum(initial_time_df)

iterator = 1

for df in twoddf

     df[!, :transaction_time] = df[!, :transaction_time] .- subtract_time
     sort!(df, :transaction_time)
     df = filter(row -> row.transaction_time < 86400000, df)
     df[!, "total_quantity"] = df[!,"best_ask_qty"]+ df[!,"best_bid_qty"]
     df[!, "weighted_avg_price"] = ((df[!,"best_ask_qty"].*df[!,"best_ask_price"]) + (df[!,"best_bid_qty"].*df[!,"best_bid_price"]))./df[!, "total_quantity"]
     
     #convert milliseconds to days
     transform!(df, :transaction_time => ByRow(x -> floor(Int, x / 86400000)) => :day_group)
     #group dataframe by day
     gdf = groupby(df, :day_group)
     #within each group, divide the price by the first price (being done daily now)
     transform!(gdf, :weighted_avg_price => (prices -> prices ./ first(prices)) => :price_index)

     twoddf[iterator] = df
     iterator += 1 

end

display(twoddf[2])

subtract_time = minimum(initial_time_df)

for df in twoddf
     df[!, :transaction_time] = df[!, :transaction_time] .- subtract_time
     sort!(df, :transaction_time)
end

#trim dataframes for price/correlation variable calculation 
btcdf_trimmed = (select(btcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))
ltcdf_trimmed = (select(ltcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))
ethdf_trimmed = (select(ethdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))
dgcdf_trimmed = (select(dgcdf,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))

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

#to pass first transaction_time available from each dataset
initial_time_df = []


for df in twoddf
     
     #pass first transaction time to the initial time dataframe to index time
     push!(initial_time_df, first(df[!,"transaction_time"]))
     #convert milliseconds to days
     transform!(df, :transaction_time => ByRow(x -> floor(Int, x / 86400000)) => :day_group)
     #group dataframe by day
     gdf = groupby(df, :day_group)
     #within each group, divide the price by the first price (being done daily now)
     transform!(gdf, :weighted_avg_price => (prices -> prices ./ first(prices)) => :price_index)

end

initial_time_df
subtract_time = minimum(initial_time_df)

for df in twoddf
#     df[!, :transaction_time] = df[!, :transaction_time] .- subtract_time
     sort!(df, :transaction_time)
end

display(twoddf[1])

display(btcdf)