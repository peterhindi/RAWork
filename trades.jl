using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes, LightGraphs

@nbinclude("TSP Pairs Trade Parameterized.ipynb")

struct Modelrun
     solution
end

function trades(model::Modelrun)
     sell_array = []
     buy_array = []
     edge_list = collect(edges(DiGraph(model.solution)))
     for edge in edge_list
          if src(edge) == 5 || dst(edge) == 5
               continue
          else
               push!(sell_array, src(edge))
               push!(buy_array, dst(edge))
          end
     end
     return sell_array, buy_array
end


TSP_output = TSP_Pairs_Trade(similarity, ask_price_df, bid_price_df,10)

new_model = Modelrun(TSP_output)

hi, bye = trades(new_model)