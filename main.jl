using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude

include("data_read.jl")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

function run_model()
     millisecond_starter = 1722470000001 # 50 less than the limited dataset = 1722469999950
     millisecond_tracker = millisecond_starter
     while (millisecond_tracker < millisecond_starter+101) #replace number with maximum transaction_time in entire period
          #initialize empty dataframes for data entry and index for column addition
          print("hi")
          level_2_df = []
          level_3_df = []
          bid_price_df1 = []
          ask_price_df1 = []
          run_index = 0

          for df in twoddf
               push!(level_2_df, filter(row -> row.transaction_time < 100000000000001230102310230123, df))
          end

          for df2 in level_2_df
               run_index += 1
               push!(level_3_df, df2[:, "weighted_avg_price"])
               push!(bid_price_df1, last(df2[!, "best_bid_price"]))
               push!(ask_price_df1, last(df2[!, "best_ask_price"]))
          end

          display(similarityfactor(level_3_df))
          millisecond_tracker += 25
     end

    # matrix = similarityfactor(pricesdf)

     #TSP_Pairs_Trade(matrix, ask_price_df, bid_price_df,10)
end


run_model()

display(btcdf_trimmed)
