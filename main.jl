using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude

include("data_read.jl")
include("trades.jl")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

function run_model()
     millisecond_starter = 1722470000001 # 50 less than the limited dataset = 1722469999950
     model_time_delta = 25
     millisecond_tracker = millisecond_starter
     print("START OF MODEL RUNS")
     while (millisecond_tracker < millisecond_starter+101) #replace number with maximum transaction_time in entire period
          #initialize empty dataframes for data entry and index for column addition
          level_2_df = []
          level_3_df = []
          bid_price_df = []
          ask_price_df = []
          run_index = 0

          for df in twoddf
               push!(level_2_df, filter(row -> row.transaction_time < millisecond_tracker, df))
          end

          for df2 in level_2_df
               run_index += 1
               push!(level_3_df, df2[:, "weighted_avg_price"])
               push!(bid_price_df, last(df2[!, "best_bid_price"]))
               push!(ask_price_df, last(df2[!, "best_ask_price"]))
          end

          similarity_matrix =  similarityfactor(level_3_df)
          
          TSP_solution = TSP_Pairs_Trade(similarity_matrix, ask_price_df, bid_price_df,3)

          Model_trades = Modelrun(TSP_solution, millisecond_tracker)

          sell_array,buy_array,pair = trades(Model_trades)

          


          display(TSP_solution)

          println("these are the trades")
          println(sell_array)
          println(buy_array)
          println(pair)
          println(Model_trades.time_executed)
          
          millisecond_tracker += model_time_delta
     end
end

run_model()