using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude

include("data_read.jl")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")
@nbinclude("Similarity Factor & Bid-Ask Prices Parameterized.ipynb")

function run_model()
     millisecond_tracker = 1722469999950
 
     matrix = similarityfactor(pricesdf)

     TSP_Pairs_Trade(matrix, ask_price_df, bid_price_df,10)
     
     filter(row -> row."transaction_time" > 1722469999950, dgcdf_trimmed)

     display(TSP_Pairs_Trade)
end


run_model()

display(btcdf_trimmed)