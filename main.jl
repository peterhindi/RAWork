using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude

include("data_read.jl")
include("trades.jl")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

function run_model()

     account = Account(10000)

     #set starting time. May look to adjust for data warm-up
     millisecond_starter = 1722470000001 # 50 less than the limited dataset = 1722469999950
     
     #set time between model iterations
     model_time_delta = 25
     
     millisecond_tracker = millisecond_starter

     #window for DTW training. 1 day as consisistent with the original paper
     training_window = 86400000

     print("START OF MODEL RUNS")
     
     while (millisecond_tracker < millisecond_starter+101) #replace number with maximum transaction_time in entire period

          #initialize empty dataframes for data entry and index for column addition
          level_2_df = []
          level_3_df = []
          iteration_window_df = []
          bid_price_df = []
          ask_price_df = []
          #move back by training window
          for df in twoddf
               semi_df = filter(row -> row.transaction_time >= millisecond_tracker - training_window, df)
               push!(level_2_df, filter(row -> row.transaction_time < millisecond_tracker, df))
          end

          display(level_2_df[1])
          for df2 in level_2_df
               push!(bid_price_df, last(df2[!, "best_bid_price"]))
               push!(ask_price_df, last(df2[!, "best_ask_price"]))
               push!(iteration_window_df, filter(row -> row.transaction_time >= millisecond_tracker - model_time_delta, df2))
          end

          display(iteration_window_df[1])

          #close existing positions before adding new one
          trade_closing_logic(account, iteration_window_df)


          similarity_matrix =  similarityfactor(level_2_df)
          
          TSP_solution = TSP_Pairs_Trade(similarity_matrix, ask_price_df, bid_price_df,3)

          Model_trades = Modelrun(TSP_solution, millisecond_tracker)

          sell_array,buy_array,pair = trades(Model_trades)

          open_trade(account, Model_trades)

          update_balance(account, iteration_window_df)

          display(TSP_solution)

          println("these are the trades")
          println(sell_array)
          println(buy_array)
          println(pair)
          println(Model_trades.time_executed)
          println("this is the balance")
          println(account.balance)
          millisecond_tracker += model_time_delta
     end
end

run_model()