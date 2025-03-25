using Pkg, CSV, DataFrames, DynamicAxisWarping, Distances, Plots, NBInclude

#to pass first transaction_time available from each dataset
initial_time_df = []

#Read in asset-level prices
btcdf = CSV.read("..\\..\\Crypto Tick Data\\BTCUSDT\\BTCUSDT-bookTicker-2023-05.csv", DataFrame)
ltcdf = CSV.read("..\\..\\Crypto Tick Data\\BNBUSDT\\BNBUSDT-bookTicker-2023-05.csv", DataFrame)
ethdf = CSV.read("..\\..\\Crypto Tick Data\\ETHUSDT\\ETHUSDT-bookTicker-2023-05.csv", DataFrame)
dgcdf = CSV.read("..\\..\\Crypto Tick Data\\XRPUSDT\\XRPUSDT-bookTicker-2023-05.csv", DataFrame)

twoddf = [[dgcdf] [ethdf] [ltcdf]]

for (loop_index, df) in enumerate(twoddf)
     df = (select(df,[:"best_bid_price",:"best_ask_price",:"best_ask_qty",:"best_bid_qty",:"event_time", "transaction_time"]))
     push!(initial_time_df, first(df[!,"transaction_time"]))
     twoddf[loop_index] = df

     print("here first")

end

#constant to subtract from transaction_time column for each dataframe
subtract_time = minimum(initial_time_df)

loop_index = 1

for (loop_index, df) in enumerate(twoddf)

     df[!, :transaction_time] = df[!, :transaction_time] .- subtract_time
     sort!(df, :transaction_time)
     df = filter(row -> row.transaction_time < 172800000, df)
     df[!, "total_quantity"] = df[!,"best_ask_qty"]+ df[!,"best_bid_qty"]
     df[!, "weighted_avg_price"] = ((df[!,"best_ask_qty"].*df[!,"best_ask_price"]) + (df[!,"best_bid_qty"].*df[!,"best_bid_price"]))./df[!, "total_quantity"]
     
     #convert milliseconds to days
     transform!(df, :transaction_time => ByRow(x -> floor(Int, x / 86400000)) => :day_group)
     #group dataframe by day
     gdf = groupby(df, :day_group)
     #within each group, divide the price by the first price (being done daily now)
     transform!(gdf, :weighted_avg_price => (prices -> prices ./ first(prices)) => :price_index)

     twoddf[loop_index] = df

     print("here second")
end

@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

level_2_df = []

for df in twoddf
     push!(level_2_df, filter(row -> row.transaction_time < 5000, df))
end

similarity = similarityfactor(level_2_df)

bid_price_df = []
ask_price_df = []

for df2 in level_2_df
     push!(bid_price_df, last(df2[!, "best_bid_price"]))
     push!(ask_price_df, last(df2[!, "best_ask_price"]))
end

@time begin
display(QUBO_Pairs_Trade(similarity, ask_price_df, bid_price_df, 4))
end