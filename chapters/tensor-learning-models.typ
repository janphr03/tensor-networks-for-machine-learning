== Tensor Networks for Machine Learning <tensor-network-ml>

A tensor representation becomes a learning model when its cores or factors are
adjusted using observations. The mathematical structure alone does not specify
what should be predicted. A complete model also needs an input representation,
an output function, a training objective, and an evaluation protocol. These
choices connect the generic tensor framework to a particular forecasting task.

=== Feature Maps and Prediction Functions

A feature map turns an input into coordinates in which a prediction can be
expressed. For a scalar $x_n$, consider the two-component map
$ phi(x_n) = (1,x_n)^T. $
For $d$ inputs, form the product features
$ cal(Phi)(x) = phi(x_1) ⊗ dots ⊗ phi(x_d). $
The entry with one selected coordinate per input is the product of those
coordinates. For two inputs $a,b$,
$ cal(Phi)(a,b) = mat(1,b;a,a b). $
Contracting this feature tensor with a weight tensor gives a scalar:
$ hat(y) = sum_(i_1,dots,i_d)
  cal(W)_(i_1,dots,i_d) product_(n=1)^d phi_(i_n)(x_n). $ <eq-feature-prediction>

For two inputs, take
$ W = mat(0.5,-0.2;0.8,1.3). $
Then
$ hat(y) = 0.5 + 0.8 a - 0.2 b + 1.3 a b. $
The first three terms describe additive effects. The last term is an interaction:
the effect of changing $a$ depends on $b$, because
$ (partial hat(y))/(partial a) = 0.8 + 1.3 b. $
For example, the prediction at $(a,b)=(0.2,-0.4)$ is $0.636$.

#figure(
  image("../figures/tensors/10-interaction-sheet.svg", width: 100%,
    alt: "An additive prediction is a plane; a product interaction bends it into a bilinear surface."),
  caption: [
    An interaction as a bending sheet. Both surfaces use identical axes and
    projection scales. The term $1.3 a b$ allows the influence of one input
    to depend on the other; the diagram illustrates a constructed function,
    not a measured relationship in the research data.
  ],
) <fig-interaction>

Product feature maps can provide a large set of interactions while a tensor
network constrains the corresponding weights. Stoudenmire and Schwab develop
this approach for supervised classification #cite(<stoudenmire2016>). The same
contraction can produce a numeric regression output when the target and loss
are changed. The local feature map is a modeling choice: polynomial or other
basis functions change which input dependences the model can express.

If $cal(W)$ is a TT, each local input can first be contracted into its own core:
$ H^(n)(x_n)_(alpha beta) =
  sum_i G^(n)_(alpha,i,beta) phi_i(x_n). $
The prediction then follows by multiplying the resulting small matrices,
$ f_theta(x)=H^(1)(x_1) H^(2)(x_2) dots H^(d)(x_d), $
where the boundary dimensions are one. Thus the full product-feature tensor
and the full weight tensor need not be constructed explicitly. Each local
operation is small when its feature size and bond dimensions are small.

=== Learning Tensor Cores

The cores act like adjustable controls whose combined setting determines the
prediction function. A one-dimensional drawing can show this relationship:
as parameters change, the model curve moves toward observations. Training has
access to the observations, whereas a generating curve is normally unknown.

For observed pairs $(x^(n),y^(n))$, a regression objective is
$ L(theta) = 1/N sum_(n=1)^N
  (f_theta(x^(n))-y^(n))^2. $
Here $theta$ collects the core entries. A basic gradient step is
$ theta_"new" = theta_"old" - eta nabla_theta L(theta), $
with step size $eta>0$. Derivatives propagate through products and contractions.
For example, differentiating @eq-three-core with respect to one entry of its
middle core gives
$ (partial cal(T)_(i,j,k))/(partial cal(B)_(alpha,j,beta))
  = A_(i alpha) C_(beta k), $
with the corresponding indices held fixed. In a prediction model, local
feature factors contribute to the derivative as well.

#figure(
  image("../figures/tensors/11-learning-curve.svg", width: 100%,
    alt: "A blue TT prediction curve moves toward noisy observations as three tensor cores are trained."),
  caption: [
    An actual small training run with synthetic observations. Three TT cores
    of bond dimension two are trained on
    $phi(x) ⊗ phi(x) ⊗ phi(x)$, with $phi(x)=(1,x)^T$.
    The dashed curve is the known cubic used to generate the illustration.
    The knobs summarise changes within cores; they do not denote just three
    scalar parameters.
  ],
) <fig-learning>

For @fig-learning, the reference function is
$ y_*(x)=0.3+0.6x-0.8x^2+0.45x^3. $
Twenty-one inputs between $-1$ and $1$ receive a small deterministic perturbation
of this function. The train has 16 stored core parameters. Adam is used for
1,800 updates #cite(<kingma2015>). The resulting training MSE decreases from
approximately $0.364407$ to $0.000290$. The reference curve is shown because
this is a constructed demonstration. These numbers are not experimental
results on DATEV data, and a close training fit alone does not establish future
prediction accuracy.

This deliberately small train stores more numbers than its dense $2 times 2
times 2$ weight tensor, which has eight entries. The example isolates the
mechanism of learning a function through core parameters. Storage reduction
depends on the tensor dimensions and ranks, as illustrated separately in
@fig-relay.

Alternating optimization offers another approach. With all but one core fixed,
the prediction is linear in the remaining core. A squared-error objective can
therefore be solved as a local least-squares problem. Repeating such updates
optimizes different cores in turn. Jointly, however, their product gives a
nonconvex parameterization. Both gradient-based and alternating methods require
appropriate initialization and stopping criteria; neither approach guarantees
the best predictive model simply because it uses tensor factors.

Ranks and feature sizes act as hyperparameters. They should be chosen using
validation accuracy under a temporal protocol. Increasing them can improve
capacity, but can also increase optimization difficulty or overfitting. The
test data must remain separate from these choices.

=== Tensorized Layers and Hybrid Architectures

A tensor network can also be placed inside an existing neural model. Consider a
dense layer
$ y=sigma(M x+b). $
When the input and output sizes can be grouped into products,
reshape the weights into paired input-output modes and represent them with an
MPO. The layer remains a learned linear map followed by an activation, but its
weight representation changes. Novikov et al. introduce TT representations of
neural-network weights #cite(<novikov2015>).

Two procedures must be distinguished. A trained dense matrix can be factorized
after training, with any truncation introducing approximation error. Alternatively,
the tensor cores can be learned directly from the beginning. Direct training
restricts the optimization to the chosen representation. A reduction in stored
weights need not preserve forecast accuracy, so the effect is measured using
the same held-out task.

Hybrid designs can modify more than storage. A higher-order recurrent model
introduces explicit products among historical hidden states and uses a TT
representation to make those interactions manageable. HOT-RNN/HOT-LSTM provides
one such design #cite(<yu2019>). A statistical hybrid can instead forecast a
sequence of latent tensor cores: BHT-ARIMA combines delay embedding, Tucker
structure, and ARIMA #cite(<shi2020>).

These designs intervene at different places in the prediction process.
Consequently, a fair ablation identifies the exact tensor component and compares
it with a relevant conventional counterpart. A parameter count describes one
aspect of the implementation; a task-matched accuracy comparison establishes
whether the representation helps.

=== From a Generic Model to a Forecasting Task

Forecasting supplies a window of known past observations and possibly known
covariates. Time and variables can form separate modes or be grouped into a
documented chain. A scalar output is fully contracted; an additional open index
can identify a target variable or a forecast horizon.

Axis ordering determines which dependencies cross each bond. A grouping that
represents one pattern compactly can need larger ranks for another. This choice
therefore depends on the data structure and validation results.

Applying the framework to DATEV data still requires the target, sampling
frequency, number of series, available history, and horizon. Feature generation
and learned decompositions must use information available at the forecast origin.
Held-out accuracy is the primary criterion; resource measurements describe its
computational cost.

=== Classical and Quantum-Inspired Interpretation

MPS and MPO originate in quantum many-body physics, where their indices can label
local basis states. The same contraction mathematics can describe real-valued
regression weights #cite(<orus2014>).

Here, the cores define prediction functions trained on classical computers.
Their entries are model parameters; quantum-state normalization is not required.
These models provide a reference for the research group's quantum algorithms.
A quantum implementation additionally needs data encoding and measurements,
and its accuracy must be evaluated against that reference.
