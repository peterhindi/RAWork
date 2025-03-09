using Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude, Gurobi, JuMP, Graphs, GraphRecipes#, PyCall

@nbinclude("TSP Pairs Trade Parameterized.ipynb")

struct Modelrun
     solution
     buy_array
     sell_array
     function Modelrun(solution)
          new(solution, [], [])
     end
end

function trades(model::Modelrun)
     solution = model.solution
     sell_array = model.sell_array
     buy_array = model.buy_array
     
     #collect list of edges to interpret long and short positions
     edge_list = collect(edges(Graphs.DiGraph(solution)))

     #Find solution pair
     dummy_col = solution[5,:]
     dummy_row = solution[:,5]
    
     col_num = findall(dummy_col->dummy_col==1, dummy_col)
     row_num = findall(dummy_row->dummy_row==1, dummy_row)

     pair = [col_num[1], row_num[1]]

     for edge in edge_list
          if src(edge) == 5 || dst(edge) == 5
               continue
          else
               push!(sell_array, src(edge))
               push!(buy_array, dst(edge))
          end
     end
     return sell_array, buy_array, pair
end



#TSP_output = TSP_Pairs_Trade(similarity, ask_price_df, bid_price_df,10)

#new_model = Modelrun(TSP_output)

#hi, bye = trades(new_model)

