{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "4528a5ab-26c1-4ca5-886d-572be470ec40",
   "metadata": {},
   "outputs": [],
   "source": [
    "#Import packages\n",
    "using JuMP, Pkg, CSV, DataFrames, Statistics, Plots, Ipopt, Combinatorics, Distances, LinearAlgebra, AmplNLWriter, NBInclude\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "b63a3f6d-4040-4a6b-a4ff-2ee268acd748",
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "similarityfactor (generic function with 1 method)"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "#Function for computing dynamic time-warping distance between two price vectors, to be used as an input in the similarity factor function\n",
    "function dtwfn(seq1, seq2)\n",
    "    n = length(seq1)\n",
    "    m = length(seq2)\n",
    "    dtw_matrix = zeros(n, m)\n",
    "    \n",
    "    dtw_matrix[1, 1] = abs(seq1[1] - seq2[1])\n",
    "    \n",
    "    for i in 2:n\n",
    "        dtw_matrix[i, 1] = abs(seq1[i] - seq2[1]) + dtw_matrix[i-1, 1]\n",
    "    end\n",
    "    \n",
    "    for j in 2:m\n",
    "        dtw_matrix[1, j] = abs(seq1[1] - seq2[j]) + dtw_matrix[1, j-1]\n",
    "    end\n",
    "    \n",
    "    for i in 2:n\n",
    "        for j in 2:m\n",
    "            cost = abs(seq1[i] - seq2[j])\n",
    "            dtw_matrix[i, j] = cost + min(dtw_matrix[i-1, j], dtw_matrix[i, j-1], dtw_matrix[i-1, j-1])\n",
    "        end\n",
    "    end\n",
    "    \n",
    "    return dtw_matrix[n, m]\n",
    "end\n",
    "\n",
    "#Create matrix of dynamic-time-warping distances between variables for weight calculation and return it\n",
    "function similarityfactor(twoddf)\n",
    "    num_stocks = length(twoddf)\n",
    "    similarity = zeros(num_stocks, num_stocks)\n",
    "    for ii in 1:num_stocks\n",
    "        for j in (ii+1):num_stocks\n",
    "            similarity[ii,j]= dtwfn(twoddf[ii],twoddf[j])\n",
    "        end\n",
    "    end\n",
    "    similarity = LinearAlgebra.Symmetric(similarity)\n",
    "    return similarity\n",
    "end"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "a495d15e-6603-4ebe-be5c-fa84cdd383d4",
   "metadata": {},
   "outputs": [],
   "source": [
    "#print(ask_price_df)\n",
    "#print(bid_price_df)\n",
    "\n",
    "#similarity = similarityfactor()\n",
    "#summed_cost = zeros(5,5)\n",
    "#  for i in 1:5\n",
    "#      for j in 1:5\n",
    "#          if j == 5 || i == 5\n",
    "#              summed_cost[i,j] = 0\n",
    "#              continue\n",
    "#         end\n",
    "#         summed_cost[i,j] = similarity[i,j]*(ask_price_df[j] - bid_price_df[i])\n",
    "#     end\n",
    "#  end\n",
    "#summed_cost\n",
    "\n",
    "#print(similarityfactor())\n",
    "#similarity[1,2]#*\n",
    "#print((ask_price_df[2] - bid_price_df[1]))\n",
    "#summed_cost"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Julia 1.11.2",
   "language": "julia",
   "name": "julia-1.11"
  },
  "language_info": {
   "file_extension": ".jl",
   "mimetype": "application/julia",
   "name": "julia",
   "version": "1.11.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
