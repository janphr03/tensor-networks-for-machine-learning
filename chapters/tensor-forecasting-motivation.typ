== Motivation for Tensor-Based Forecasting <tensor-motivation>

@forecasting-ml-foundations showed different ways to turn past observations
into forecasts: weight the readings, split inputs into groups, or process
them with a neural network. Tensor-based methods address the same task.
Their motivation concerns *how relationships and parameters are represented*:
can we describe combinations of inputs explicitly while keeping the learned
representation manageable? Higher-order recurrent models and tensorized
neural layers investigate these two ideas @yu2019 @novikov2015.

For now, think of a *tensor* as an array with several indices, for example
observations organised by series, time, and variable. Ordinary neural networks
also use such arrays. The distinctive idea considered here is to represent
data or model weights through smaller, connected factors. The next two
sections explain why this could be useful; @tensor-foundations and
@tensor-network-foundations develop the mathematics afterwards.

=== Why Model Interactions Between Inputs?

A forecast may depend on a combination of inputs, rather than on their
separate contributions alone. An *interaction* means that the effect of
one input changes with another input. To see this without forecasting
details, consider the invented response in @tab-interaction-example.
Here, 0 means that an input is absent and 1 that it is present.

#figure(
  table(
    columns: 3, align: center, inset: (x: 18pt, y: 4pt),
    table.header([*Input A*], [*Input B*], [*Illustrative response*]),
    [0], [0], [0],
    [1], [0], [1],
    [0], [1], [1],
    [1], [1], [3],
  ),
  caption: [A constructed interaction: either input alone gives 1, but their joint presence gives 3 rather than the additive result 2. These are teaching values, not research observations.],
) <tab-interaction-example>

When B is absent, switching A on raises the response by 1; when B is present,
the same change raises it by 2. The influence of A therefore depends on B.
In forecasting, the interacting inputs could be different measured variables
or observations from different times. *Higher-order interactions* extend
this idea to combinations of three or more inputs.

Explicitly assigning weights to many combinations can require a large
parameter array. Yu et al. combine interactions of past hidden states in a
recurrent forecasting model and use a tensor-train factorization to keep its
parameter representation smaller @yu2019[Secs. 3.1--3.2]. This motivates
investigating that structure for forecasting. It does not mean that ordinary
neural networks cannot learn interactions, or that every dataset benefits
from explicitly modelling them.

#pagebreak(weak: true)
=== Why Use Shared Factors Instead of Separate Weights?

The second idea is *reuse*: describe many entries through a smaller set of
shared factors. @tab-shared-weights gives a simple example using a matrix,
the two-index case of a tensor. Its second row is twice its first, and its
third row is three times its first.

#figure(
  table(
    columns: 5, align: center, inset: (x: 14pt, y: 4pt),
    table.header([], [*Weight 1*], [*Weight 2*], [*Weight 3*], [*Weight 4*]),
    [*Row 1*], [2], [4], [6], [8],
    [*Row 2*], [4], [8], [12], [16],
    [*Row 3*], [6], [12], [18], [24],
  ),
  caption: [Shared structure in twelve invented weights: every row is a multiple of the base row.],
) <tab-shared-weights>

Instead of storing all twelve weights, we can store the four base values
and the three row multipliers, 1, 2, and 3: seven numbers reproduce the
same matrix. Tensor factorizations generalise such ideas to arrays with
more indices. A *low-rank representation* limits how many components are
combined; its definition follows in @tensor-foundations. Real model weights
need not have an exact compact representation, so using few components may
introduce approximation error.

Novikov et al. demonstrate tensor-train representations of neural-layer
weights to reduce parameter storage @novikov2015. This supports the
compression motivation, rather than establishing better forecasting.
Shi et al. use a different route: they represent multiple time series in a
structured tensor form, compress it with a Tucker decomposition, and forecast
in the compressed representation @shi2020. Their reported forecasting
results concern their particular datasets and comparisons.

For this study, these ideas lead to three testable expectations:

- Explicit interactions may improve accuracy when combinations of inputs
  contain information that the comparison models do not capture well.
- A compact representation may improve generalization if its constraints
  match useful structure; overly strong constraints may discard information
  and worsen accuracy.
- Fewer stored parameters may reduce memory requirements. Runtime depends
  additionally on how the factors are evaluated and on the implementation.

The main question remains forecasting accuracy on unseen observations.
Parameter savings alone cannot answer it. The following sections explain
the tensor operations and network structures needed to implement and assess
these hypotheses.
