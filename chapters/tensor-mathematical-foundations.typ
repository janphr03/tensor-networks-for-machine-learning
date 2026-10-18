== Mathematical Foundations <tensor-foundations>

The previous section argued that tensor models might forecast better or more
cheaply by exploiting patterns shared across variables and time. To work with
such patterns, a precise language for data with several indices is needed. This
section introduces it through four basic operations used by all later models:
addressing, rearranging, combining, and compressing.

=== Tensors and Index Notation

Consider a ledger in which each page belongs to a series, each row to a time
step, and each column to a measured variable. A number is found by naming three
addresses: page, row, and column. This is the mental picture of an order-three
tensor (@fig-ledger).

Formally, a *tensor* is a multidimensional array of real numbers,
$ cal(X) in bb(R)^(I_1 times I_2 times dots times I_d), $
with entries $cal(X)_(i_1,dots,i_d)$. The *order* $d$ counts the indices, also
called *modes*. Scalars, vectors, and matrices are tensors of order zero, one,
and two #cite(<kolda2009>, supplement: [Sec. 2]).

#figure(
  image("../figures/tensors/01-indexed-ledger.svg", width: 100%,
    alt: "Two indexed ledger pages illustrate series, time, and variable axes."),
  caption: [
    A tensor as an indexed ledger with invented values. The entry
    $cal(X)_(2,3,1)=11$ lies on page two, in time row three, in variable column
    one.
  ],
) <fig-ledger>

The ledger has the shape $2 times 3 times 2$ and holds twelve values. Fixing only
the first index selects a whole page, a matrix called a *slice*; fixing all but
one index leaves a vector called a *fiber*. The meaning of each axis comes from
the application, but how the axes are grouped later shapes what a model can
represent.

=== Tensor Products, Reshaping, and Matricization

The outer product combines two vectors into a table of all pairwise products.
Picture a loom: one vector sets the values of the horizontal threads, the other
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
index is summed #cite(<lee2016>). Each row of $u v^T$ is a multiple of the same row. Such
a table consists of a single pattern and has rank one, the smallest building
block of compression (@mathematical-foundations).

*Matricization*, or *unfolding*, rearranges a tensor into a matrix without
changing any value. Returning to the
ledger, place all values from a page into one row (@fig-unfolding). The
$2 times 3 times 2$ tensor becomes a $2 times 6$ matrix with the column index
$c = 2(t-1)+v$. Many algorithms work on such unfoldings; the chosen grouping must
be recorded, because a later factorization uses it to impose structure.

#figure(
  image("../figures/tensors/02-unfolding-pages.svg", width: 100%,
    alt: "Two ledger pages become a two-by-six matrix with explicit time-variable column addresses."),
  caption: [
    Unfolding the ledger. The value eleven moves to row two, column five, because
    $c=2(3-1)+1=5$. The conversion is reversible.
  ],
) <fig-unfolding>

=== Tensor Contraction and Diagrammatic Notation

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

=== Rank, Singular Value Decomposition, and Approximation <mathematical-foundations>

The rank of a matrix counts how many simple patterns it needs. A rank-one matrix
$u v^T$ is a single pattern; higher ranks need several. This leads to a second
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
