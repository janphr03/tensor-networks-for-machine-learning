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

An *interaction* means that *the effect of B depends on A*. This matters
for forecasting because adding the separate effects of the inputs can
then give the wrong prediction.

Suppose we want to forecast electricity use in the next hour, and know
which of two machines will run. In this invented example, each machine
uses 1 kWh during that hour. When both run, an additional cooler uses
another 1 kWh. @tab-interaction-example shows the total.

#figure(
  table(
    columns: 3, align: center, inset: (x: 18pt, y: 4pt),
    table.header([*Machine A*], [*Machine B*], [*Use (kWh)*]),
    [Off], [Off], [0],
    [On], [Off], [1],
    [Off], [On], [1],
    [On], [On], [3],
  ),
  caption: [Invented electricity use: when both machines run, the cooler adds 1 kWh.],
) <tab-interaction-example>

If A is off, switching B on adds 1 kWh. If A is already on, switching B
on adds 2 kWh: one for B and one for the cooler. *B's effect on total use
depends on whether A is running.* Simply adding the two machines' separate
uses would predict 2 kWh instead of 3 kWh when both run.

Forecasting models may need to learn such joint effects between variables
or past observations. With many inputs, there are many possible combinations.
Giving each combination its own weight can make the model very large.
Tensor methods can build many weights from a smaller set of learned numbers.
The same numbers are *reused for different input combinations*. Yu et al. use this idea
for combinations of past hidden states in a recurrent forecasting model
@yu2019[Secs. 3.1--3.2]. The next subsection shows how reusing numbers works.

Ordinary neural networks can also learn interactions. Tensor models offer
a compact way to represent them; whether this improves forecasts must be
tested on unseen observations.

=== Why Reuse Numbers to Build Many Weights?

The second idea is to *reuse the same numbers to build many weights*.
@tab-shared-weights contains twelve weights, but its rows follow a simple
pattern: the second row is twice the first, and the third row is three
times the first. We can use this pattern to store fewer numbers.

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

We only need two lists: the base row, *2, 4, 6, 8*, and the row multipliers,
*1, 2, 3*. To recover a weight, multiply a base value by its row multiplier.
For example, the third weight in the second row is $2 times 6 = 12$.
Seven stored numbers therefore reproduce all twelve weights.

These two lists are called *factors*. They are *shared* because the same
base row is reused for every row, and each row multiplier is reused for
all four weights in its row. A *tensor factorization* applies this idea
to arrays with more indices. The mathematics follows in @tensor-foundations.
Real weights may not follow such a simple pattern exactly. Using fewer
numbers can then change some weights and lose information.

Novikov et al. use tensor factorizations to store neural-network weights
with fewer numbers @novikov2015. Shi et al. compress data from several
time series and make forecasts using the smaller representation @shi2020.
These studies show ways to use the idea; they do not tell us whether it
will improve forecasts on our data.

For this study, this raises three questions:

- Does learning joint effects between inputs improve forecasts?
- Does using fewer learned numbers help the model predict new observations,
  or does it lose information needed for accurate forecasts?
- How much memory does this save, and does it also make computation faster?

The main test is whether the forecasts are more accurate on unseen data.
Using fewer numbers does not automatically make a forecast better.
The next sections explain how tensor models work so that we can build
and compare them.
