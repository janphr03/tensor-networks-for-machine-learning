== Mathematical Foundations <tensor-foundations>

Four base values and three row multipliers can reproduce twelve weights.
To use this idea in a forecasting model, we need to know how to organise
the numbers and calculate with them. We also need to understand what
happens when a small set of numbers cannot reproduce all weights exactly.

This section builds the necessary tools step by step. First, we learn how
to find a value in data with several axes, such as series, time, and variable.
Then we build larger arrays from smaller ones. A separate step shows how
to rearrange their values for matrix methods. We then find simple patterns
in a matrix and examine what is lost when we keep fewer of them. Finally,
we calculate with the small factors directly. These tools will let us work with the
small, connected tensors introduced in @tensor-network-foundations.

#block(breakable: false)[
=== Tensors and Index Notation

Suppose we record temperature and humidity at two locations over several
days. A long list of numbers would make it hard to see which measurements
belong together. We therefore store the measurements in a *tensor*,
organised by location, day, and measured variable. To look up one value,
we specify all three: for example, location 2, day 3, and temperature.
]

One location's measurements fit in a table: days are rows, and temperature
and humidity are columns. For two locations, we need two such tables.
@fig-ledger shows them stacked behind one another. The stack adds a third
direction: *location*. The front layer belongs to location 2. Its highlighted
cell contains the temperature on day 3, which is 11 °C. To find this cell,
we choose the layer, row, and column. These three choices are called
*indices*, written as $(s,t,v) = (2,3,1)$ here.

#figure(
  image("../figures/tensors/01-indexed-ledger.svg", width: 100%,
    alt: "A three-dimensional block stacks two location tables. Location runs in depth, day vertically, and variable horizontally; each direction has its own labelled arrow. The front layer is location 2 and contains readings 7 to 12. Its orange cell selects day 3 and variable 1, temperature, giving 11 degrees Celsius. Values are invented."),
  caption: [
    Stacking one table per location gives three index directions: location,
    day, and variable. The highlighted entry
    $cal(X)_(2,3,1)=11$ is the temperature at location 2 on day 3. All values
    are invented.
  ],
) <fig-ledger>

The *order* counts the indices needed to identify one entry. Here, location,
day, and variable give order three. Each axis is also called a *mode*.
The *shape* $2 times 3 times 2$ gives their sizes: two locations, three days,
and two variables, holding twelve values in total.

Formally, an order-$d$ tensor is a multidimensional array of real numbers,
$ cal(X) in bb(R)^(I_1 times I_2 times dots times I_d), $
with entries $cal(X)_(i_1,dots,i_d)$ and axis sizes $I_k$.
Scalars, vectors, and matrices have orders zero, one, and two
#cite(<kolda2009>, supplement: [Sec. 2]).

@fig-slice-fiber shows two ways to select part of the data. Fixing location 2
leaves a *slice*: a table with day and variable free (order two). Also fixing
temperature leaves a *fiber*: the column $(7,9,11)$ with only day free
(order one).

#figure(
  image("../figures/tensors/01b-order-slice-fiber.svg", width: 100%,
    alt: "A three-panel diagram shows a tensor of order 3, a matrix slice of order 2, and a vector fiber of order 1. Fixing location 2 selects the table with rows 7 and 8, 9 and 10, 11 and 12. Its temperature column is orange. Fixing temperature selects that column, containing 7, 9, and 11. The labels below each panel list the remaining free indices."),
  caption: [A location slice and its temperature fiber, selected from the same tensor.],
) <fig-slice-fiber>

#block(breakable: false)[
=== Tensor Products and Shared Weights <tensor-products>

The rows in @fig-outer repeat one pattern at different strengths.
We can learn the four base values $(2,4,6,8)$ once, together with three
multipliers $(1,2,3)$. *That gives seven learned parameters instead of
twelve separate weights.*
]

#figure(
  image("../figures/tensors/03-outer-product-loom.svg", width: 100%,
    alt: "Each box has a number and a small weight symbol. Left: twelve weights with 12 highlighted orange. Right: three weights in u and four in v, seven total, with the matching factors 2 and 6 highlighted orange. Only counts and group labels are shown, with no explanatory sentences or calculations."),
  caption: [
    Each weight symbol marks one learned parameter. Orange highlights one
    weight and the two factors that produce it. Values are illustrative.
  ],
) <fig-outer>

This construction is the *outer product*. If $u$ contains the multipliers
and $v$ the shared row, the weight matrix $W$ has entries $w_(i j)$:
$ W = u v^T, quad w_(i j) = u_i v_j. $
For $I$ rows and $J$ columns, the full table stores $I J$ numbers, while
the two factors store $I+J$. We keep the factors and calculate weights
from them when needed.

Fewer trainable parameters do not automatically mean faster predictions.
Runtime also depends on how we calculate with the factors.

The same idea builds arrays with more indices by multiplying entries
from more factors. This is a *tensor product*: the orders add up, and
no index is summed #cite(<lee2016>).

The *rank* of a matrix is the smallest number of base rows needed to build
all its rows by multiplying these base rows by numbers and adding the
results. In @fig-rank-comparison, one blue base row reproduces all rows
on the left: *rank one*. On the right, the red row needs a second
base row: *rank two*.

#figure(
  image("../figures/tensors/03b-rank-comparison.svg", width: 100%,
    alt: "Left: a rank-one matrix with one blue base row. Right: the unchanged second-row values 4,8,12 are muted red, while 17 is strongly highlighted. This change from 16 to 17 makes the second row independent of the first, giving rank two. The third row is still a multiple of the first."),
  caption: [One base row suffices on the left. Changing 16 to the red 17
    on the right makes a second base row necessary.],
) <fig-rank-comparison>

@mathematical-foundations explains how rank helps us compress matrices.
When rows do not follow one shared pattern,
one outer product cannot reproduce them exactly. We then need more
patterns or must accept an approximation.

#block(breakable: false)[
=== Reshaping and Matricization <tensor-reshaping>

Our measurements are stored in two separate location tables. To apply
matrix methods to both locations together, we arrange their readings in
one matrix, with one row per location. This changes only the arrangement;
any compression comes later.
]

@fig-unfolding shows how: read each location's
table row by row, then place its six values in one long row. The two
rows form a $2 times 6$ matrix. This is *matricization*, or *unfolding*;
*reshaping* means changing an array's shape more generally.

#figure(
  image("../figures/tensors/02-unfolding-pages.svg", width: 100%,
    alt: "Two small location tables stand side by side on the left. One arrow leads to a single matrix. The blue table becomes the blue first row, containing 1,2,3,4,5,6. The teal table becomes the teal second row, containing 7,8,9,10,11,12. Eleven stays orange in both views."),
  caption: [
    Each location table becomes one matrix row; all twelve values stay the same.
  ],
) <fig-unfolding>

#pagebreak(weak: true)

#block(breakable: false)[
=== Rank, Singular Value Decomposition, and Approximation <mathematical-foundations>

In @fig-outer, every row was a multiple of $(2,4,6,8)$. We spotted this
by looking at the numbers and could store seven numbers instead of twelve.
The *singular value decomposition* (SVD) finds such patterns for us when
they are harder to see.
]

The first pattern can be understood using our earlier example: find
one base row and one multiplier per row so that the resulting table
comes as close as possible to the given matrix. Closeness is measured
by squaring the difference at each entry and adding the squared differences.
Subtracting this first pattern leaves a remainder. The next pattern
describes that remainder as closely as possible, and so on. The SVD
calculates these patterns from the matrix entries; we do not choose
them by hand.

@fig-svd shows how adding more patterns reconstructs a matrix. Keeping
only a few can save space, but may change some values: we obtain an
*approximation*.

#figure(
  image("../figures/tensors/05-svd-pattern-layers.svg", width: 100%,
    alt: "An eight-by-eight pattern is reconstructed from one, two, and three singular layers with singular values nine, three, and one."),
  caption: [
    SVD as layers of a pattern. A constructed matrix with singular values
    $(9,3,1)$ is rebuilt from one, two, and three layers; the errors are
    $sqrt(10)$, $1$, and $0$.
  ],
) <fig-svd>

Each layer is an outer product $u_ell v_ell^T$ multiplied by its strength,
called a *singular value* $sigma_ell$. The SVD orders these layers from
strongest to weakest:
$ M = sum_(ell=1)^q sigma_ell u_ell v_ell^T,
  quad sigma_1 >= sigma_2 >= dots >= sigma_q >= 0. $
Here, $q$ is the smaller of the row and column counts; some strengths may
be zero. The number of nonzero strengths is the matrix's rank.

Keeping only the first $r$ layers gives the best approximation of rank
at most $r$ when error is measured by the sum of squared entry differences.
This squared error equals the sum of the dropped $sigma_ell^2$
#cite(<eckart1936>).

Storing the full $8 times 8$ matrix takes 64 numbers, whereas $r$ layers take
$r(8+8+1)$: two vectors of length eight and one strength per layer.
Compression therefore pays off only when we keep few enough layers.
Approximating weights closely does not guarantee accurate forecasts;
forecast accuracy must be checked on held-out data.

#pagebreak(weak: true)

#block(breakable: false)[
=== Tensor Contraction: Calculating with Factors <tensor-contraction>

We can now represent a weight matrix using smaller factors. To make a
prediction, we can calculate with these factors directly, without first
rebuilding the full matrix. *Tensor contraction* describes how the required
multiplications and sums are carried out.
]

Return to the seven factors in @fig-outer: the base weights
$v=(2,4,6,8)^T$ and the multipliers $u=(1,2,3)^T$. Suppose we use this
weight matrix to turn four inputs into three outputs. Each output is
a weighted sum of the inputs. Since every weight row is a multiple of
$v$, we can calculate the sum with $v$ once, then multiply that result
by each entry of $u$.

For the illustrative input $x=(1,2,3,4)^T$, the shared sum is
$2 times 1 + 4 times 2 + 6 times 3 + 8 times 4 = 60$.
The three multipliers give $y=(60,120,180)^T$ (@fig-contraction).
These are exactly the outputs we would get using all twelve weights.

#figure(
  image("../figures/tensors/04-contraction-lanes.svg", width: 100%,
    alt: "Four inputs 1,2,3,4 are paired with the shared weights 2,4,6,8. Their products are summed to 60. That sum is multiplied by the three factors 1,2,3 to give outputs 60,120,180. The full three-by-four weight matrix is never built."),
  caption: [One shared weighted sum produces all three outputs through the multipliers $u$.],
) <fig-contraction>

In symbols, this is
$ y = W x = u (v^T x), quad
  y_i = u_i sum_(j=1)^4 v_j x_j. $
The sum pairs each input $x_j$ with its weight $v_j$, multiplies them,
and adds the products. This is a *contraction over $j$*: the input index
$j$ is summed out, while $i$ still selects one of the three outputs.
Contractions use the same rule for tensors with more indices
#cite(<lee2016>). The next section shows how this lets us calculate with
several connected factors.
