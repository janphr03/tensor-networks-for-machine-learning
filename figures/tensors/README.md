# Original vector illustrations for tensor-network foundations

The thirteen SVGs are original teaching illustrations for Sections 2.4–2.6. They
contain vector paths and text, and remain sharp when enlarged or printed. Each
metaphor is connected to a formula or a numerical example in the chapter.

| File | Teaching idea | Mathematical anchor |
| --- | --- | --- |
| 01-indexed-ledger.svg | A three-dimensional stack: locations in depth, days vertically, variables horizontally | An order-three tensor; temperature X(2,3,1) = 11 °C |
| 01b-order-slice-fiber.svg | Select a location, then a variable; three free indices become two, then one | Orders 3, 2, 1; slice at location 2; temperature fiber (7, 9, 11) |
| 02-unfolding-pages.svg | Two compact location tables become two matrix rows; blue and teal identify the locations | Reversible 2 × 3 × 2 to 2 × 6 unfolding; value 11 highlighted in both views |
| 03-outer-product-loom.svg | Weight icons: 12 separate parameters versus 7 factors; weight 12 and factors 2, 6 are orange; no explanatory sentences or calculations | Base row (2, 4, 6, 8), multipliers (1, 2, 3) |
| 03b-rank-comparison.svg | Rank 1 needs one blue base row; rank 2 has a muted red second row with 17 strongly highlighted | Changing entry (2,4) from 16 to 17 gives a nonzero minor; row 3 remains 3 times row 1 |
| 04-contraction-lanes.svg | Reuse one weighted sum, then apply the three known row multipliers | W x = u(vᵀx); inputs (1,2,3,4), shared sum 60, outputs (60,120,180) |
| 05-svd-pattern-layers.svg | Four compact matrices: original and reconstructions with one, two, three patterns; one shared color scale | Known singular values 9, 3, 1 and exact truncation errors |
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
- The contraction example reuses the seven factors from the outer-product example; its outputs are illustrative, not fitted forecasts.
- A bond dimension counts labels; it is not a literal bandwidth measurement.
- The learning plot uses synthetic observations and a known generating function.
- The topology drawing represents contractions, not a chronological processing order.

The document captions make these correspondences explicit. Figure alt text and
SVG titles/descriptions provide accessible descriptions. All drawings use English
labels; the values are independent of the DATEV dataset.
