== General Principles of Tensor Networks <tensor-network-foundations>

A tensor network represents an object through smaller tensors and a rule for
joining their indices. This viewpoint separates the represented tensor from the
particular collection of numbers used to describe it. A network may represent
data, model weights, an operator, or quantum-state coefficients. Its topology and
bond dimensions determine the available representation; its contractions determine
how that representation is evaluated.

=== Tensor Networks as Factorized Representations

A matrix factorization already has the essential structure:
$ M_(i j) = sum_(alpha=1)^r A_(i alpha) B_(alpha j). $
The outer indices $i$ and $j$ identify a matrix entry. The internal index
$alpha$ selects a component shared by the two factors. A tensor network extends
this principle to more indices and more local factors.

For a three-way tensor, a simple chain is
$ cal(T)_(i,j,k) =
  sum_(alpha=1)^(r_1) sum_(beta=1)^(r_2)
  A_(i alpha) cal(B)_(alpha,j,beta) C_(beta k). $ <eq-three-core>
The factors have shapes $I times r_1$, $r_1 times J times r_2$, and
$r_2 times K$. They are called *cores*. Computing one entry means adding the
products for every allowed pair $(alpha,beta)$.

#figure(
  image("../figures/tensors/06-latent-relay.svg", width: 100%,
    alt: "Three local tensor descriptions are linked by bonds with two possible latent labels."),
  caption: [
    A relay metaphor for @eq-three-core. The two coloured lanes stand for two
    possible labels on one bond; they are not two separate edges of the formal
    network. Open legs select $i,j,k$, while internal labels are summed.
  ],
) <fig-relay>

The metaphor suggests that neighbouring cores share a small vocabulary of latent
choices. These labels have no prescribed meaning such as a particular month or
a particular measured variable. Their role is to connect factors algebraically.
The network diagram does not require information to travel from left to right:
@eq-three-core defines one tensor regardless of the order used to contract it.

For $I=J=K=4$ and $r_1=r_2=2$, a dense tensor stores $4^3=64$ entries. The cores
store $4 dot 2+2 dot 4 dot 2+2 dot 4=32$ entries. An explicit example is
$ cal(T)_(i,j,k)
  = U_(i,1)V_(j,1)W_(k,1)+U_(i,2)V_(j,2)W_(k,2), $
with rows
$ U=mat(1,0;0,1;1,1;2,-1), quad
  V=mat(1,1;2,-1;0,2;1,0), quad
  W=mat(1,0;0,1;1,-1;2,1). $
A TT representation uses $U$ as the first core, diagonal matrices containing
rows of $V$ in the middle core, and $W^T$ as the last core. For example,
$cal(T)_(4,2,3)=3$. Summing all internal labels
recovers each of the 64 dense entries.

This is a representation example, not a forecasting model. No observations have
been fitted yet. It shows how a structural factorization can store a particular
tensor compactly. The wider perspective of tensor factorizations for data analysis
is developed by Cichocki et al. #cite(<cichocki2017>).

=== Bond Dimensions and Representational Capacity

An internal edge is called a *bond*, and the number of values its index may take
is the *bond dimension*. A larger bond provides more shared components through
which two parts of the representation can be coupled. The dimension counts
algebraic labels, not bits, elapsed time, or physical communication channels.

To see the effect of a bond, group all open indices on its left into a row index
and all open indices on its right into a column index. For a chain with one bond
crossing this partition, the resulting matrix has the form
$ T_"cut" = L R, quad
  L in bb(R)^(I_"left" times r), quad
  R in bb(R)^(r times I_"right"). $
Therefore,
$ op("rank")(T_"cut") <= r. $
This bound follows directly from matrix multiplication: every column of $L R$
lies in the span of the $r$ columns of $L$.

For @eq-three-core, the first cut groups $i$ against $(j,k)$, and the second groups
$(i,j)$ against $k$. A bond dimension of one forces a single separable component
across the corresponding cut. A dimension of two allows two such components.
The constructed example in @fig-relay has rank two at both cuts. A rank-one
chain cannot represent it exactly.

For more general graphs, a partition may cross several bonds. The product of
their dimensions bounds the number of combined latent labels across that
partition, and hence the rank of the corresponding unfolding. This connects
topology with capacity #cite(<orus2014>). Increasing a bond dimension expands the
representational possibilities, but does not by itself guarantee a better learned
prediction. The selected features, training data, and optimization still matter.

=== Tensor Decompositions and Network Topologies

The same idea of local factors leads to several families. Their different shapes
encode different assumptions about how components interact.

A *CP decomposition* expresses a tensor as a sum of rank-one terms:
$ cal(T)_(i,j,k) approx
  sum_(alpha=1)^R U_(i alpha) V_(j alpha) W_(k alpha). $
One component label $alpha$ is shared by all factors. The smallest number of
terms needed for an exact representation is the CP rank. In a conventional graph,
this shared selection can be represented by a copy tensor
$delta_(alpha,beta,gamma)$, equal to one when all three indices agree and zero
otherwise. The CP diagram in @fig-topologies uses this construction.

A *Tucker decomposition* adds a mixing core:
$ cal(T)_(i,j,k) approx
  sum_(alpha=1)^(r_1) sum_(beta=1)^(r_2) sum_(gamma=1)^(r_3)
  cal(G)_(alpha,beta,gamma)
  U_(i alpha) V_(j beta) W_(k gamma). $
Unlike the single shared CP label, the Tucker core combines separately chosen
components. For exact representations, the minimal multilinear ranks are the
ranks of the respective mode unfoldings. These distinctions and the associated
factorizations are described by Kolda and Bader
#cite(<kolda2009>, supplement: [Secs. 3 and 4]).

#figure(
  image("../figures/tensors/07-network-topologies.svg", width: 100%,
    alt: "CP as shared selection, Tucker as a mixing hub, TT as a string, MPO as paired legs, and a branching tensor tree."),
  caption: [
    Organisational pictures of common tensor representations. CP shares one
    component selection; Tucker mixes components in a central core; TT/MPS forms
    a chain; MPO retains paired input and output legs; a tree groups factors
    hierarchically. Bond labels are illustrative, not fitted values.
  ],
) <fig-topologies>

A *tensor train* (TT) places cores along a chain. For an order-$d$ tensor,
$ cal(T)_(i_1,dots,i_d) =
  sum_(alpha_1,dots,alpha_(d-1))
  product_(n=1)^d G^(n)_(alpha_(n-1),i_n,alpha_n),
  quad alpha_0=alpha_d=1. $
Core $n$ has shape $r_(n-1) times I_n times r_n$, with boundary ranks
$r_0=r_d=1$. The stored entry count is
$ P_"TT" = sum_(n=1)^d r_(n-1) I_n r_n. $ <eq-tt-storage>
With bounded mode sizes and fixed bounded ranks, this count grows linearly with
$d$. Exact ranks can grow with the problem, however, so an arbitrary tensor does
not automatically admit a small exact train #cite(<oseledets2011>).

An open-boundary *matrix product state* (MPS) has the same chain structure. The
name MPS is common in quantum physics, while TT is common in numerical analysis.
A *matrix product operator* (MPO), also called a TT matrix, gives each site an
input-output index pair. It represents a linear map whose entries have a
factorized form. A tree tensor network joins local groups at higher levels.
Loops, spatial grids, and MERA provide further structures, but their numerical
properties require additional analysis #cite(<orus2014>).

CP rank, Tucker ranks, and TT ranks describe different factorizations. A value
called rank two in one family does not define the same model class as rank two
in another. The order of axes also matters: changing which variables sit next
to each other in a chain can change the unfolding ranks needed across its cuts.

For a chain, SVD provides a constructive starting point. First unfold the tensor
as a matrix with rows indexed by $i_1$ and columns indexed by the remaining
indices. Retain $r_1$ singular directions and use the left factor as the first
core. Reshape the remaining factor so its row index combines the first bond and
$i_2$, apply another SVD, and continue. This *TT-SVD* procedure builds a chain
while allowing truncation at each cut #cite(<oseledets2011>).

Exact factorizations are recovered when all required directions are retained.
With truncation, the matrix tail errors control the resulting tensor
approximation. Sequential truncation is a practical construction; it should not
be confused with a guarantee of the globally best tensor approximation for
every prescribed rank tuple. For a prediction task, the ranks must also be
assessed against held-out forecasting accuracy.

=== Contraction Order and Computational Cost

A factorized representation is useful only if its evaluation can be organised
efficiently. Associativity allows the same contraction to be performed in
different orders. Intermediate tensor sizes can differ substantially.

Consider
$ A in bb(R)^(40 times 2), quad
  B in bb(R)^(2 times 30), quad
  C in bb(R)^(30 times 2). $
Both $(A B) C$ and $A(B C)$ produce a $40 times 2$ matrix. Using ordinary dense
matrix multiplication, the first route needs
$ 40 dot 2 dot 30 + 40 dot 30 dot 2 = 4800 $
scalar multiplications and creates a $40 times 30$ intermediate matrix.
The second needs
$ 2 dot 30 dot 2 + 40 dot 2 dot 2 = 280 $
scalar multiplications and creates a $2 times 2$ intermediate.

#figure(
  image("../figures/tensors/08-contraction-packing.svg", width: 100%,
    alt: "Combining the small inner factors first avoids a large temporary matrix while preserving the result."),
  caption: [
    Contraction order as packing before carrying. The small thumbnails use the
    same scale per entry; the $2 times 2$ intermediate is also magnified.
    Counts refer to scalar multiplications, not measured runtime.
  ],
) <fig-order>

The metaphor in @fig-order is a packing decision: combining the right pieces
early can avoid carrying a much larger temporary object. In a tensor network,
the corresponding decision determines which indices remain open at each
intermediate step. A poor order can erase the storage advantage of the initial
factorization. Actual speed also depends on hardware, memory access, and the
implementation, so an arithmetic count does not establish a timing result.

For a chain and suitable feature-product inputs, contractions can proceed
locally without materialising the full tensor. Other topologies may create
larger intermediates. These are properties of the graph and its chosen
evaluation strategy, not consequences of a small parameter count alone
#cite(<lee2016>).

=== Gauge Freedom and Canonical Forms

The entries of individual cores are generally not unique. An invertible change
of coordinates on an internal bond can be undone in the neighbouring core:
$ A B = (A G)(G^(-1) B). $ <eq-gauge>
The represented matrix remains unchanged. The same insertion of $G$ and its
inverse applies to a bond in a tensor network.

For a numerical check, take
$ A=mat(1,2), quad B=mat(3;4), quad
  G=mat(0,-1;1,0). $
Then $A B=11$, $A G=mat(2,-1)$, and $G^(-1) B=mat(4;-3)$. The transformed product
is again $2 dot 4+(-1) dot (-3)=11$.

#figure(
  image("../figures/tensors/09-gauge-coordinates.svg", width: 100%,
    alt: "One vector has different coordinates in original and rotated bases, illustrating compensating changes on a tensor bond."),
  caption: [
    Gauge freedom as a change of coordinate language. The same vector has
    coordinates $(2,1)$ in the original basis and $(1,-2)$ in a basis rotated
    by ninety degrees. Compensating basis changes on a tensor bond preserve
    the full contraction in @eq-gauge.
  ],
) <fig-gauge>

This freedom explains why a large value in one core need not mean a large
effect on the final prediction: another core can compensate for it. MPS
representations and their canonical forms have been analysed in detail by
Pérez-García et al. #cite(<perez2007>).

A *canonical form* selects a useful representative of this freedom. For example,
reshape a TT core into a matrix whose rows combine its left bond and physical
index. A thin QR factorization writes this matrix as $Q R$ with orthonormal
columns in $Q$. Retain $Q$ as the core and absorb $R$ into its neighbour.
For a left-orthonormal real core,
$ sum_(alpha,i)
  G_(alpha,i,beta) G_(alpha,i,gamma) = delta_(beta,gamma). $
This condition makes contractions involving that side easier to analyse and
helps control numerical scaling. It fixes a representation convention rather
than changing the represented tensor.

In chains and appropriate trees, such orthogonality can be organised around a
chosen centre. A general network with loops does not automatically have the same
simple canonical structure. The result is a practical foundation for algorithms
and for interpreting internal quantities, with the topology kept explicit
#cite(<bridgeman2017>, supplement: [Sec. 3.3.2]).
