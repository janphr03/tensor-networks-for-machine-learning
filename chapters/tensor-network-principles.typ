#pagebreak(weak: true)

== General Principles of Tensor Networks <tensor-network-foundations>

We can now find small factors for a matrix and calculate with them directly.
For tensors with more indices, we use several connected factors. Such a
representation is called a *tensor network*. This section explains how
the factors connect, how much they can represent, and how to calculate
with them efficiently.

=== Tensor Networks as Factorized Representations

With several factors, a diagram helps us see which indices are summed
over. A node represents a tensor, and each line attached to it, called a
*leg*, represents one index. Connecting two legs means multiplying matching
entries and summing over that shared index: a contraction. An unconnected,
or *open*, leg remains an index of the result
#cite(<bridgeman2017>, supplement: [Secs. 1.1–1.3]).

A matrix factorization $M_(i j) = sum_alpha A_(i alpha) B_(alpha j)$ is already
a tiny network: two factors share an internal index $alpha$. With three outer
indices, a chain of three factors gives
$ cal(T)_(i,j,k) =
  sum_(alpha=1)^(r_1) sum_(beta=1)^(r_2)
  A_(i alpha) cal(B)_(alpha,j,beta) C_(beta k). $ <eq-three-core>
The factors are called *cores*. Computing one entry means adding the products
for every allowed pair $(alpha,beta)$, as pictured in @fig-relay. The internal
labels have no meaning of their own; they only connect neighbouring cores.

#figure(
  image("../figures/tensors/06-latent-relay.svg", width: 100%,
    alt: "Three local tensor descriptions are linked by bonds with two possible latent labels."),
  caption: [
    A relay metaphor for @eq-three-core. Open legs select $i$, $j$, and $k$; the
    two coloured lanes stand for the two possible labels on one bond, which are
    summed over.
  ],
) <fig-relay>

For $I=J=K=4$ and $r_1=r_2=2$, the full tensor has $4^3=64$ entries, whereas the
three cores store only $4 dot 2+2 dot 4 dot 2+2 dot 4=32$. A factorization can
thus store a tensor compactly, provided that the tensor has the matching
structure #cite(<cichocki2017>).

=== Bond Dimensions and Representational Capacity

An internal edge is called a *bond*, and the number of values its index can take
is the *bond dimension* $r$. The bond dimension limits how strongly the two sides
of a network can be coupled. Group all open indices on one side of a bond into
rows and all on the other side into columns. The resulting matrix has the form
$T_"cut" = L R$ with $r$ inner columns, so
$ op("rank")(T_"cut") <= r. $
A bond of dimension one allows only a single separable pattern across the cut;
dimension two allows two. Larger bonds increase capacity, but not automatically
accuracy: data, features, and training still decide #cite(<orus2014>).

=== Tensor Decompositions and Network Topologies

Different network shapes encode different assumptions about how the parts of a
tensor interact (@fig-topologies):

- *CP*: a sum of $R$ rank-one terms that share one component index,
  $cal(T)_(i,j,k) approx sum_alpha U_(i alpha) V_(j alpha) W_(k alpha)$.
- *Tucker*: a small core $cal(G)$ mixes separate components of each mode,
  $cal(T)_(i,j,k) approx sum_(alpha,beta,gamma) cal(G)_(alpha,beta,gamma)
  U_(i alpha) V_(j beta) W_(k gamma)$ #cite(<kolda2009>, supplement: [Secs. 3 and 4]).
- *Tensor train* (TT), in physics called a *matrix product state* (MPS): a chain
  of three-index cores, one per index of the tensor.
- *Matrix product operator* (MPO): a chain whose cores carry an input and an
  output index; it represents a linear map, such as a weight matrix.
- *Trees* join local groups of indices step by step.

#figure(
  image("../figures/tensors/07-network-topologies.svg", width: 100%,
    alt: "CP as shared selection, Tucker as a mixing hub, TT as a string, MPO as paired legs, and a branching tensor tree."),
  caption: [
    Common tensor network shapes: CP shares one component selection, Tucker
    mixes components in a central core, TT/MPS forms a chain, MPO keeps paired
    input and output legs, and a tree groups factors hierarchically.
  ],
) <fig-topologies>

The tensor train is central for this work. For an order-$d$ tensor,
$ cal(T)_(i_1,dots,i_d) =
  sum_(alpha_1,dots,alpha_(d-1))
  product_(n=1)^d G^((n))_(alpha_(n-1),i_n,alpha_n),
  quad alpha_0=alpha_d=1, $
and its cores store $P_"TT" = sum_(n=1)^d r_(n-1) I_n r_n$ numbers. With bounded
ranks, this count grows only linearly with the number of indices $d$, whereas the
full tensor grows exponentially #cite(<oseledets2011>). A TT can be computed from a given
tensor by successive SVDs that cut off small layers at each bond (TT-SVD). Two
cautions apply: the word "rank" means something different in CP, Tucker, and TT,
and in a chain the order of the indices matters, because it decides which
dependencies must pass through which bond.

=== Contraction Order and Computational Cost

A network is useful only if it can be evaluated cheaply. The same product can be
computed in different orders at very different costs. For
$A in bb(R)^(40 times 2)$, $B in bb(R)^(2 times 30)$, and
$C in bb(R)^(30 times 2)$, the order $(A B) C$ needs 4,800 multiplications and a
$40 times 30$ intermediate result. The order $A (B C)$ needs 280
scalar multiplications and creates a $2 times 2$ intermediate (@fig-order).

#figure(
  image("../figures/tensors/08-contraction-packing.svg", width: 100%,
    alt: "Combining the small inner factors first avoids a large temporary matrix while preserving the result."),
  caption: [
    Contraction order as packing before carrying: combining the small inner
    factors first avoids a large intermediate. Counts are multiplications, not
    measured runtimes.
  ],
) <fig-order>

As with packing small items before carrying them, a good order keeps
intermediate results small. For a chain with suitable inputs, the contraction
can proceed locally, core by core, without ever forming the full tensor
#cite(<lee2016>). Actual speed still depends on hardware and implementation.

=== Gauge Freedom and Canonical Forms

The cores of a network are not unique. An invertible matrix $G$ and its inverse
can be inserted into any bond without changing the result:
$ A B = (A G)(G^(-1) B). $ <eq-gauge>
This is like describing the same vector in a rotated coordinate system
(@fig-gauge). A large value in a single core therefore says little about its
effect on the result.

#figure(
  image("../figures/tensors/09-gauge-coordinates.svg", width: 100%,
    alt: "One vector has different coordinates in original and rotated bases, illustrating compensating changes on a tensor bond."),
  caption: [
    Gauge freedom as a change of coordinates: the same vector has the
    coordinates $(2,1)$ in one basis and $(1,-2)$ in a basis rotated by ninety
    degrees. Compensating changes on a bond preserve @eq-gauge.
  ],
) <fig-gauge>

A *canonical form* fixes this freedom, for example by making cores orthonormal
with QR factorizations. It keeps computations numerically stable and is used by
training methods that update one core at a time #cite(<perez2007>)
#cite(<bridgeman2017>, supplement: [Sec. 3.3.2]).
