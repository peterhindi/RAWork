using Pkg, CSV, DataFrames

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

pricesdf = []
for dataframe in twoddf
     push!(pricesdf, dataframe[:, "weighted_avg_price"])
end

bid_price_df = [[last(btcdf_trimmed[!,"best_bid_price"])] [last(ethdf_trimmed[!,"best_bid_price"])] [last(ltcdf_trimmed[!,"best_bid_price"])] [last(dgcdf_trimmed[!,"best_bid_price"])]]
ask_price_df = [[last(btcdf_trimmed[!,"best_ask_price"])] [last(ethdf_trimmed[!,"best_ask_price"])] [last(ltcdf_trimmed[!,"best_ask_price"])] [last(dgcdf_trimmed[!,"best_ask_price"])]]

filter(row -> row."transaction_time" > 1722469999950, dgcdf_trimmed)

1722469999950