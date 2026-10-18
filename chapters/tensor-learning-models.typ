== Tensor Networks for Machine Learning <tensor-network-ml>

So far, tensor networks have only stored given numbers. A forecast needs more:
the network must learn from data. This section turns a tensor network into a
prediction model in three steps. Inputs become feature vectors, the network
weighs their interactions, and training adjusts the cores. The section closes
by connecting the model to the forecasting task.

=== Feature Maps and Prediction Functions

A *feature map* turns each input value into a small vector, for example
$phi(x_n) = (1, x_n)^T$. The tensor product of these vectors over all inputs,
$cal(Phi)(x) = phi(x_1) ⊗ dots ⊗ phi(x_d)$, contains every product of the
inputs. Contracting it with a weight tensor $cal(W)$ gives the prediction:
$ hat(y) = sum_(i_1,dots,i_d)
  cal(W)_(i_1,dots,i_d) product_(n=1)^d phi_(i_n)(x_n). $ <eq-feature-prediction>
For two inputs $a$ and $b$ and the weights $W = mat(0.5,-0.2;0.8,1.3)$, this
gives
$ hat(y) = 0.5 + 0.8 a - 0.2 b + 1.3 a b. $
The first three terms are additive effects. The last term is an interaction (@fig-interaction):
the effect of $a$ depends on $b$.

#figure(
  image("../figures/tensors/10-interaction-sheet.svg", width: 100%,
    alt: "An additive prediction is a plane; a product interaction bends it into a bilinear surface."),
  caption: [
    An interaction as a bending sheet. The term $1.3 a b$ bends the additive
    plane, so that the influence of one input depends on the other. The
    function is constructed for illustration.
  ],
) <fig-interaction>

With $d$ inputs, $cal(W)$ has $2^d$ entries, far too many for long input
windows. A tensor network solves this problem #cite(<stoudenmire2016>). If $cal(W)$ is a
TT, each input is first contracted with its own core,
$ H^((n))(x_n)_(alpha beta) = sum_i G^((n))_(alpha,i,beta) phi_i (x_n), $
and the prediction becomes a product of small matrices,
$ f_theta (x) = H^((1))(x_1) H^((2))(x_2) dots H^((d))(x_d). $
The full feature tensor and the full weight tensor are never formed. The local
feature map is a modelling choice: polynomials or other basis functions change
which dependences the model can express.

=== Learning Tensor Cores

The cores are the parameters of the model. Training adjusts them until the
predictions fit the observations, just as a curve moves toward data points when
the right knobs are turned. A one-dimensional drawing can show this relationship (@fig-learning):
the objective is the mean squared error, which gradient steps
$theta_"new" = theta_"old" - eta nabla_theta L(theta)$ reduce.

#figure(
  image("../figures/tensors/11-learning-curve.svg", width: 100%,
    alt: "A blue TT prediction curve moves toward noisy observations as three tensor cores are trained."),
  caption: [
    A tensor model learns a curve. Three TT cores of bond dimension two are
    trained on $phi(x) ⊗ phi(x) ⊗ phi(x)$ with $phi(x)=(1,x)^T$; the dashed
    curve is the known cubic that generated the synthetic points.
  ],
) <fig-learning>

In @fig-learning, the 16 core parameters are trained with the Adam optimizer
#cite(<kingma2015>). After 1,800 updates, the training error falls from about 0.364 to
0.0003. An alternative is to update one core at a time. With the other cores
fixed, the prediction is linear in that core, so each step is a small
least-squares problem. Neither method guarantees the best model. Ranks and
feature sizes are hyperparameters that are chosen on validation data.

=== Tensorized Layers and Hybrid Architectures

A tensor network can also sit inside a neural network. A dense layer
$y = sigma(M x + b)$ can store its weight matrix $M$ as an MPO. The layer then
computes the same kind of function with far fewer stored weights #cite(<novikov2015>).
Whether accuracy survives this compression has to be measured on the task.

Hybrids can also change the model itself. HOT-RNN and HOT-LSTM let a recurrent
network use products of several past hidden states and store the resulting
large weight tensor as a TT #cite(<yu2019>). BHT-ARIMA arranges several series as a
tensor, compresses it with a Tucker decomposition, and forecasts the compressed
cores with ARIMA #cite(<shi2020>). Because these designs place the tensor at different
points, a fair test compares each of them with the same model without its tensor
part.

=== From a Generic Model to a Forecasting Task

For forecasting, the inputs are the values in the input window, possibly for
several variables. The output is a single forecast or, with one additional open
index, all horizons at once. The order of the inputs along the chain matters,
because it decides which dependencies have to pass through which bond. As for
every model, features and decompositions may use only information available at
the forecast origin, and accuracy on held-out data is the main criterion.

=== Classical and Quantum-Inspired Interpretation

MPS and MPO originate in quantum physics, where they describe the states of
many-particle systems #cite(<orus2014>). In this study, they are classical prediction
models running on ordinary computers, and their cores are ordinary parameters.
