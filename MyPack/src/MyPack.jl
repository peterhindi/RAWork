module MyPack

using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes

Pkg.resolve()
Pkg.instantiate()

include("../../Similarity Factor & Bid-Ask Prices Parameterized copy.jl")
@nbinclude("Cost Function Parameterized.ipynb")
@nbinclude("TSP Pairs Trade Parameterized.ipynb")

function greet()
      print("Hello World!")
end

#export greet

export TSP_Pairs_Trade

end # module MyPack
