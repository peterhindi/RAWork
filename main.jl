using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude

include("data_read.jl")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

function run_model()
     millisecond_tracker = 1722470000001 # 50 less than the limited dataset = 1722469999950

     while (millisecond_tracker < millisecond_tracker+101) #replace number with maximum transaction_time in entire period
          #initialize empty dataframes for data entry and index for column addition
          level_2_df = []
          level_3_df = []
          bid_price_df1 = []
          ask_price_df1 = []
          run_index = 0

          for df in twoddf
               push!(level_2_df, filter(row -> row."transaction_time" < 17224699999509, df))
          end

          for df2 in level_2_df
               run_index += 1
               push!(level_3_df, df2[:, "weighted_avg_price"])
               push!(bid_price_df1, last(df2[!, "best_bid_price"]))
               push!(ask_price_df1, last(df2[!, "ask_bid_price"]))
          end

          millisecond_tracker + 25
          display(similarityfactor(level_3_df))
          
          for df3 in level

     matrix = similarityfactor(pricesdf)

     TSP_Pairs_Trade(matrix, ask_price_df, bid_price_df,10)

     pricesdf = []
     for dataframe in twoddf
          push!(pricesdf, dataframe[:, "weighted_avg_price"])
     end

     bid_price_df = [[last(btcdf_trimmed[!,"best_bid_price"])] [last(ethdf_trimmed[!,"best_bid_price"])] [last(ltcdf_trimmed[!,"best_bid_price"])] [last(dgcdf_trimmed[!,"best_bid_price"])]]
     ask_price_df = [[last(btcdf_trimmed[!,"best_ask_price"])] [last(ethdf_trimmed[!,"best_ask_price"])] [last(ltcdf_trimmed[!,"best_ask_price"])] [last(dgcdf_trimmed[!,"best_ask_price"])]]

     filter(row -> row."transaction_time" > 1722469999950, dgcdf_trimmed)

     1722469999950

     filter(row -> row."transaction_time" > 1722469999950, dgcdf_trimmed)

     display(TSP_Pairs_Trade)
end


run_model()

display(btcdf_trimmed)
