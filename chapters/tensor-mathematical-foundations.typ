== Mathematical Foundations <tensor-foundations>

Tensor networks can be understood without first choosing a particular forecasting
architecture. Their common language is the language of indexed arrays and
multilinear operations. This section develops that language using small examples.
The examples are deliberately independent of the DATEV dataset: their role is to
make the mathematics visible, rather than to describe data that have not yet been
examined.

=== Tensors and Index Notation

Consider a ledger in which each page belongs to a different series. Each row records
one time step, and each column refers to a measured variable. A number is located
by giving three addresses: the page, the row, and the column. This is a useful
mental picture of an order-three tensor.

In this work, a tensor is represented by a multidimensional array of real numbers.
Once bases have been fixed, such arrays also describe elements of tensor-product
spaces. For an order-$d$ tensor, write
$ cal(X) in bb(R)^(I_1 times I_2 times dots times I_d). $
Its entries are $cal(X)_(i_1,dots,i_d)$, where
$1 <= i_n <= I_n$. The *order* $d$ counts the axes. The *shape*
$(I_1,dots,I_d)$ states the number of positions along each axis. An axis is also
called a *mode*. Scalars, vectors, and matrices have orders zero, one, and two,
respectively. These conventions follow the distinction between order and
decomposition rank used by Kolda and Bader #cite(<kolda2009>, supplement: [Sec. 2]).

#figure(
  image("../figures/tensors/01-indexed-ledger.svg", width: 100%,
    alt: "Two indexed ledger pages illustrate series, time, and variable axes."),
  caption: [
    A tensor as an indexed ledger. The values are invented for illustration.
    The entry $cal(X)_(2,3,1)=11$ lies on page two, in time row three, in variable
    column one. Neither the shape nor the numbers describe the DATEV dataset.
  ],
) <fig-ledger>

For the ledger in @fig-ledger, the shape is $2 times 3 times 2$. It contains twelve
values. The statement $cal(X)_(2,3,1)=11$ selects one value; fixing only the first
index selects a complete page. Fixing all but one index leaves a *fiber*, which is
a vector of values along the remaining mode. Fixing all but two indices leaves a
matrix *slice*.

The meanings attached to the axes belong to the application. The same mathematics
can organise time, variables, locations, or feature coordinates. Changing a label
does not change a tensor operation, but choosing how to group the axes can change
the structure available to a model. It is therefore useful to keep both the
numerical shape and the meaning of every axis explicit.

=== Tensor Products, Reshaping, and Matricization

The outer product creates a table of every possible pairing between two vectors.
Imagine a loom with one vector assigning values to the horizontal threads and
another assigning values to the vertical threads. Each crossing records the
product of the two thread values. Every crossing remains separately addressable.

For $u in bb(R)^I$ and $v in bb(R)^J$, the outer product is the matrix
$ M = u v^T, quad M_(i j) = u_i v_j. $
With $u=(1,2)^T$ and $v=(3,4,5)^T$,
$ u v^T = mat(3,4,5;6,8,10). $

#figure(
  image("../figures/tensors/03-outer-product-loom.svg", width: 100%,
    alt: "A loom retains six pairwise products at the crossings of two row threads and three column threads."),
  caption: [
    The outer product retains all pairwise products. A crossing is an entry of
    the resulting matrix, not a quantity to be added to the other crossings.
  ],
) <fig-outer>

The general tensor product follows the same rule:
$ (cal(A) ⊗ cal(B))_(i_1,dots,i_p,j_1,dots,j_q)
  = cal(A)_(i_1,dots,i_p) cal(B)_(j_1,dots,j_q). $
The orders add, and no index is summed. In an array representation,
$u ⊗ v$ retains two axes. Listing its entries in a specified order gives
the corresponding Kronecker-product vector. The ordering convention must remain
consistent when arrays are converted between representations
#cite(<lee2016>).

Reshaping changes the arrangement of entries without changing their number.
*Matricization*, or *unfolding*, arranges a tensor as a matrix. Returning to the
ledger, place all values from a page into one row. The result is a $2 times 6$
matrix. Use the column rule
$ c = 2(t-1)+v, quad X_("(1)")[s,c] = cal(X)_(s,t,v). $
The column addresses are then
$(1,1),(1,2),(2,1),(2,2),(3,1),(3,2)$.

#figure(
  image("../figures/tensors/02-unfolding-pages.svg", width: 100%,
    alt: "Two ledger pages become a two-by-six matrix with explicit time-variable column addresses."),
  caption: [
    Unfolding reorganises the ledger. The highlighted value eleven moves to row
    two, column five, because $c=2(3-1)+1=5$. The conversion is reversible when
    the original shape and the ordering rule are retained.
  ],
) <fig-unfolding>

For a general tensor, a mode-$n$ unfolding has shape
$I_n times product_(m != n) I_m$. Its columns enumerate all combinations of the
remaining indices. Different conventions can order those columns differently.
They describe the same entries but must not be mixed within one calculation.
A reshape alone creates no new evidence about relationships in the data. A
subsequent factorization, however, uses the chosen grouping to impose a model
structure.

=== Tensor Contraction and Diagrammatic Notation

A contraction combines multiplication with summation over matching indices.
The loom picture provides a contrast: an outer product keeps every crossing,
whereas a contraction collects contributions along a shared address.

For vectors of equal length,
$ s = sum_(k=1)^K a_k b_k. $
Taking $a=(1,2,3)^T$ and $b=(4,-1,2)^T$ gives
$ s = 1 dot 4 + 2 dot (-1) + 3 dot 2 = 8. $
The index $k$ identifies matching pairs before it is summed out.

#figure(
  image("../figures/tensors/04-contraction-lanes.svg", width: 100%,
    alt: "Three matching lanes contribute four, minus two, and six to a scalar total of eight."),
  caption: [
    Contraction matches an index and adds its signed contributions. The orange
    lane subtracts two. The collecting vessel is a metaphor for addition; it
    does not imply that tensor entries are physical amounts or probabilities.
  ],
) <fig-contraction>

Matrix multiplication uses the same mechanism while retaining two outer indices:
$ C_(i j) = sum_(k=1)^K A_(i k) B_(k j),
  quad A in bb(R)^(I times K), quad B in bb(R)^(K times J). $
The common dimension $K$ must agree. The result has shape $I times J$ because
$i$ and $j$ remain free. Contracting one index of an order-$p$ tensor with one
index of an order-$q$ tensor leaves $p+q-2$ axes. Contracting several pairs
removes each paired axis from both tensors.

Graphical notation turns this index bookkeeping into a drawing. A node represents
a tensor; each leg represents one index. Joining two legs means summing over their
shared index. An open leg belongs to the result. A fully contracted network has
no open legs and therefore evaluates to a scalar. The graph records an algebraic
expression, not a sequence of events in time
#cite(<bridgeman2017>, supplement: [Secs. 1.1–1.3]).

Before evaluating any diagram, three checks are useful: every joined pair must
have matching dimensions; every free index must remain present in the result;
and each summation must appear exactly where the graph joins the corresponding
legs. These checks connect a picture to a calculation and prevent a metaphor
from replacing the mathematics.

=== Rank, Singular Value Decomposition, and Approximation <mathematical-foundations>

Matrix rank describes how many independent column directions are needed to
represent a matrix. A rank-one matrix $u v^T$ can be built from one pair of
vectors. A higher-rank matrix can require several such patterns. This leads to
a second visual metaphor: reconstructing an image by adding separable layers.

The singular value decomposition (SVD) of a real matrix is
$ M = U Sigma V^T = sum_(ell=1)^q sigma_ell u_ell v_ell^T,
  quad q = min(I,J). $
The singular vectors are orthonormal, and
$sigma_1 >= sigma_2 >= dots >= sigma_q >= 0$. Each nonzero singular value
weights one separable layer. The number of nonzero singular values is the matrix
rank. Retaining only the first $r$ terms gives
$ M_r = sum_(ell=1)^r sigma_ell u_ell v_ell^T. $

The Frobenius norm measures the combined magnitude of all entries:
$ norm(M)_F = sqrt(sum_(i,j) M_(i j)^2). $
Orthogonality of the SVD layers gives
$ norm(M-M_r)_F^2 = sum_(ell=r+1)^q sigma_ell^2. $
The truncated SVD gives a best rank-at-most-$r$ matrix approximation in this norm
#cite(<eckart1936>).
The result concerns approximation of a specified matrix; predictive generalization
is a separate question.

#figure(
  image("../figures/tensors/05-svd-pattern-layers.svg", width: 100%,
    alt: "An eight-by-eight pattern is reconstructed from one, two, and three singular layers with singular values nine, three, and one."),
  caption: [
    A constructed matrix with singular values $(9,3,1)$ illustrates SVD
    truncation. The Frobenius errors are $sqrt(10)$ after one layer, $1$ after
    two layers, and $0$ after three. All panels use the same colour scale.
  ],
) <fig-svd>

In @fig-svd, one layer captures the common background, while additional layers
restore variation across rows and columns. This example uses known orthonormal
patterns, so its singular values and reconstruction errors can be checked
directly. It provides an intuitive starting point for the role of unfolding
matrices in tensor factorizations #cite(<oseledets2011>).

For the $8 times 8$ example, a dense representation stores 64 numbers. Explicitly
storing $r$ left vectors, $r$ right vectors, and $r$ singular values requires
$r(8+8+1)$ numbers. These are storage counts, not counts of independent degrees
of freedom. The comparison also shows why factorization is not automatically a
saving: the retained rank and the sizes of the original axes matter.

A tensor has several matricizations and therefore several relevant matrix ranks.
It also has decomposition-specific rank definitions. Tensor order counts axes;
rank describes a representation or an unfolding. The next section develops
these distinctions rather than treating all uses of the word rank as equivalent.
