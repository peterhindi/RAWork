# RAWork

<p> This project aims to create a pairs-trading model using a network-graph model of securities.

We use the following [paper](https://ieeexplore.ieee.org/document/10254556) as a model, and aim to expand on it.


Understanding Current Output:

To understand our current output, we will begin by discussing the cost function. Below is a matrix of the cost function evaluated across assets 1-4 (with 1 being the left/top-most element, and 4 being the right/bottom-most element)

![Alt Text](/README%20Screenshots/cost_output_1.png "Cost Function Evaluated Across Assets 1-4")

As we can see, there are significant negative weights when selling asset 1 (first row), and buying assets 2, 3, and 4. We also see significant negative weights when selling asset 3 and buying assets 2 and 4, and selling asset 2 and buying asset 4. According to the cost function, these are the pairs that would make beneficial investments:

    (1,2), (1,3), (1,4), (2,4), (3,2), (3,4)

If we run our model with a very high cost function hyperparameter (multiplier), we should expect these pairs to be highlighted. Below is the output that comes from a run with a cost hyperparameter of 999999999999999999999

![Alt Text](/README%20Screenshots/cost_output_2.png "Optimization Output with High Cost Coefficient")

The activated pairs are (1,2), (1,3), (1,4), (2,4), (3,2), (3,4), the same as above. This violates multiple conditions of the penalty function, such as the inflow/outflow <= 1 condition and the inflow=outflow condition. The condition that forbids traversing the same edge twice still holds, but only by coincidence. If we run the optimization with equal hyperparameters mc = 1, mp = 1, we find that the output is the same as above, suggesting that the penalty hyperparameter needs to be tuned.

If we run the optimization model with a penalty hyperparameter of 999999999999999999999 and a cost hyperparameter of 1, we get an output where no edges are activated, as expected, since the benefit of the negative cost associated with edges are overwhelmed by the scaled effect of the penalty function. This suggests that we need to find a balance between hyperparameters to find an optimal solution that conforms to the penalty function's conditions.

</p>