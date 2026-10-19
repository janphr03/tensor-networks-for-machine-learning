== Mathematical Foundations <tensor-foundations>

Four base values and three row multipliers can reproduce twelve weights.
To use this idea in a forecasting model, we need to know how to organise
the numbers and calculate with them. We also need to understand what
happens when a small set of numbers cannot reproduce all weights exactly.

This section builds the necessary tools step by step. First, we learn how
to find a value in data with several axes, such as series, time, and variable.
Then we build larger arrays from smaller ones and rearrange them for
calculation. Next, we combine entries to calculate a result. Finally, we
ask how many simple patterns are needed to describe an array, and what
is lost when we keep fewer of them. These tools will let us work with the
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
=== Tensor Products, Reshaping, and Matricization

To store model weights compactly, we want to build a whole table from
just two short lists. For example, multiplying the base row $(3,4,5)$
by the multipliers $1$ and $2$ produces two rows of weights. The
*outer product* describes this construction. We then look at how to
rearrange an array into a matrix so that methods for matrices can work
with it. This gives us two tools: building arrays from smaller pieces
and arranging their entries for calculation.
]

@fig-outer visualises the outer product as a loom: one vector sets the values of the horizontal threads, the other
those of the vertical threads, and every crossing holds the product of its two
thread values. Every crossing remains separately addressable (@fig-outer). For
$u in bb(R)^I$ and $v in bb(R)^J$,
$ M = u v^T, quad M_(i j) = u_i v_j, quad "for example" quad
  mat(1;2) mat(3,4,5) = mat(3,4,5;6,8,10). $

#figure(
  image("../figures/tensors/03-outer-product-loom.svg", width: 100%,
    alt: "A loom retains six pairwise products at the crossings of two row threads and three column threads."),
  caption: [
    The outer product as a loom. Each crossing is one entry of the resulting
    matrix; nothing is added up.
  ],
) <fig-outer>

The general tensor product works in the same way: the orders add up, and no
index is summed #cite(<lee2016>).

The *rank* of a matrix is the smallest number of base rows needed to build
all its rows by multiplying these base rows by numbers and adding the
results. In the example above, $(6,8,10) = 2(3,4,5)$. One base row is
enough, so the matrix has *rank one*. If one base row is not enough but
two are, the rank is two. @mathematical-foundations explains how this
helps us compress matrices.

Some methods for compressing arrays work on matrices.
To apply them to a tensor with more axes, we first arrange its entries
in rows and columns. Changing an array's shape is called *reshaping*;
turning a tensor into a matrix is called *matricization*, or *unfolding*.
The values are preserved, and their new positions must be specified.
Returning to the two locations, place all values from one location into one row
(@fig-unfolding). The
$2 times 3 times 2$ tensor becomes a $2 times 6$ matrix with the column index
$c = 2(t-1)+v$. Many algorithms work on such unfoldings; the chosen grouping must
be recorded, because a later factorization uses it to impose structure.

#figure(
  image("../figures/tensors/02-unfolding-pages.svg", width: 100%,
    alt: "Two ledger pages become a two-by-six matrix with explicit time-variable column addresses."),
  caption: [
    Unfolding the two location tables. The value eleven moves to row two, column five, because
    $c=2(3-1)+1=5$. The conversion is reversible.
  ],
) <fig-unfolding>

#block(breakable: false)[
=== Tensor Contraction and Diagrammatic Notation

Once weights are stored in smaller pieces, we need to calculate with
those pieces. A familiar example is a weighted prediction: multiply each
input by its weight and add the contributions. *Contraction* uses the
same multiply-and-add idea for arrays with several indices. Diagrammatic
notation helps us keep track of which entries belong together.
]

A contraction multiplies entries that share an index and adds the products. For
two vectors this is the dot product,
$ (1,2,3) dot (4,-1,2) = 4 - 2 + 6 = 8. $
The index $k$ identifies matching pairs before it is summed out (@fig-contraction).
Matrix multiplication is a contraction over the shared middle index,
$C_(i j) = sum_k A_(i k) B_(k j)$. In general, contracting one index pair of an
order-$p$ and an order-$q$ tensor leaves $p + q - 2$ indices.

#figure(
  image("../figures/tensors/04-contraction-lanes.svg", width: 100%,
    alt: "Three matching lanes contribute four, minus two, and six to a scalar total of eight."),
  caption: [
    Contraction as matching lanes: matching entries are multiplied and the
    signed contributions are added. The orange lane subtracts two.
  ],
) <fig-contraction>

Tensor networks describe this bookkeeping with pictures. A node is a tensor and
each leg an index. Joining two legs means summing over their shared index; open
legs remain in the result #cite(<bridgeman2017>, supplement: [Secs. 1.1–1.3]). The pictures in the
next section use this notation.

#block(breakable: false)[
=== Rank, Singular Value Decomposition, and Approximation <mathematical-foundations>

A table whose rows are all multiples of one base row follows one simple
pattern, so two short lists reproduce it exactly. Real weights may need several
patterns. Keeping more patterns can reproduce the weights more closely,
but also requires more stored numbers. We therefore need a way to count
these patterns and choose which ones to keep. *Rank* and the *singular
value decomposition* provide this starting point for matrices.
]

An outer product $u v^T$ forms one simple pattern. A matrix of rank $r$
can be built by adding $r$ such patterns, and fewer will not reproduce it
exactly. This leads to a second
visual metaphor: reconstructing an image by adding separable layers
(@fig-svd). The singular value decomposition (SVD) writes every matrix as such a
sum, sorted by strength:
$ M = sum_(ell=1)^q sigma_ell u_ell v_ell^T,
  quad sigma_1 >= sigma_2 >= dots >= sigma_q >= 0. $
Keeping only the first $r$ layers gives the best approximation of rank $r$, and
its squared error is the sum of the dropped $sigma_ell^2$ #cite(<eckart1936>).

#figure(
  image("../figures/tensors/05-svd-pattern-layers.svg", width: 100%,
    alt: "An eight-by-eight pattern is reconstructed from one, two, and three singular layers with singular values nine, three, and one."),
  caption: [
    SVD as layers of a pattern. A constructed matrix with singular values
    $(9,3,1)$ is rebuilt from one, two, and three layers; the errors are
    $sqrt(10)$, $1$, and $0$.
  ],
) <fig-svd>

Storing the full $8 times 8$ matrix takes 64 numbers, whereas $r$ layers take
$r(8+8+1)$. Compression therefore pays off only when the rank is small compared
with the size of the matrix. A good approximation of given numbers is also not
yet a good forecast; that question is answered only on held-out data. A tensor
has several unfoldings and therefore several ranks. The next section shows how
networks of small tensors exploit them.
