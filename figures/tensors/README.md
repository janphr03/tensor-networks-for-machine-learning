# Original vector illustrations for tensor-network foundations

The eleven SVGs are original teaching illustrations for Sections 2.4–2.6. They
contain vector paths and text, and remain sharp when enlarged or printed. Each
metaphor is connected to a formula or a numerical example in the chapter.

| File | Teaching idea | Mathematical anchor |
| --- | --- | --- |
| 01-indexed-ledger.svg | A ledger with pages, rows, and columns | An order-three tensor; entry X(2,3,1) = 11 |
| 02-unfolding-pages.svg | Change the address without losing a value | Reversible 2 × 3 × 2 to 2 × 6 unfolding |
| 03-outer-product-loom.svg | Keep every crossing of two sets of threads | Outer product with six retained entries |
| 04-contraction-lanes.svg | Match addresses and collect signed contributions | Dot product 4 − 2 + 6 = 8 |
| 05-svd-pattern-layers.svg | Reconstruct a pattern from separable layers | Known singular values 9, 3, 1 and exact truncation errors |
| 06-latent-relay.svg | Local descriptions share a latent vocabulary | TT cores, two size-two bonds, 64 versus 32 stored entries |
| 07-network-topologies.svg | Shared selection, mixing hub, string, and tree | CP with a copy tensor, Tucker, TT, MPO, and binary tree |
| 08-contraction-packing.svg | Combine the right pieces before carrying them | Identical matrix product, different intermediates and multiplication counts |
| 09-gauge-coordinates.svg | Change the coordinate language of the same vector | An invertible bond transform cancelled by its inverse |
| 10-interaction-sheet.svg | An interaction bends an additive plane | Bilinear prediction with an a × b feature |
| 11-learning-curve.svg | Adjust the cores to change the prediction curve | Actual deterministic training of three TT cores |

## Build and verify

Run from the project root:

    node scripts/build-tensor-figures.mjs
    node scripts/verify-tensor-foundations.mjs

[scripts/tensor-examples.mjs](../../scripts/tensor-examples.mjs) defines the numerical examples.
[scripts/build-tensor-figures.mjs](../../scripts/build-tensor-figures.mjs) and
[scripts/tensor-figure-scenes.mjs](../../scripts/tensor-figure-scenes.mjs) generate
the drawings. The generator writes [manifest.json](manifest.json), including the
training history and curve samples; the verifier writes [verification.json](verification.json).

The source is editable vector-drawing code. It is designed for direct SVG
inclusion in Typst and requires neither a raster image service nor a TeX
installation. Conventional tensor diagrams supplement the visual metaphors.

## Reading the metaphors

- The relay lanes denote two possible labels on one bond, not two graph edges.
- Signed contraction contributions are algebraic quantities, not amounts of water.
- A bond dimension counts labels; it is not a literal bandwidth measurement.
- The learning plot uses synthetic observations and a known generating function.
- The topology drawing represents contractions, not a chronological processing order.

The document captions make these correspondences explicit. Figure alt text and
SVG titles/descriptions provide accessible descriptions. All drawings use English
labels; the values are independent of the DATEV dataset.
