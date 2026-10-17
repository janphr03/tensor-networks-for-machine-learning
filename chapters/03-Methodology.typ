#import "/template.typ": *

= Methodology <methodology>
#todo[
  Translate the accuracy-first research questions into reproducible
  experiments. Document the actual data, model choices, training, and
  evaluation decisions.
]

== Research Design and Model Selection
#todo[
  Describe dataset analysis, the dated literature review, and the resulting
  model selection. Choose at least one tensor or hybrid method, its relevant
  conventional counterpart, a simple baseline, and strong task-appropriate
  competitors. Model selection depends on validation accuracy and available
  training resources; the final test set remains reserved for evaluation.
  Protocol reference: #cite(<qiu2024>).
]

== Datasets, Forecasting Tasks, and Preprocessing
#todo[
  Describe the data source, target variables, sampling, sequence lengths,
  input windows, horizons, and covariates. Specify chronological partitions
  and preprocessing fitted on training data. Prevent future information from
  entering scaling, imputation, feature extraction, or tensor decomposition.
  State DATEV as the known data source and identify the unit represented by
  each series from the actual metadata. Clarify how business events, reporting
  periods, and information availability form the time index if applicable.
  Determine whether the target is an amount, count, ratio, or class. If the
  data are market series, specify prices, returns, direction, or volatility.
  Starting reference: #cite(<hyndman2021>, supplement: [Sec. 5.10]).
]

== Models, Implementation, and Accuracy-Oriented Training
#todo[
  Identify original implementations, versions, and adaptations. Document
  tensor representations, ranks, loss functions, optimizers, early stopping,
  random seeds, tuning budgets, and pretrained weights. Select configurations
  by a predefined validation metric appropriate to the target. Give every
  model a defensible tuning opportunity within the stated resource budget.
]

== Evaluation Protocol and Reproducibility
#todo[
  Predefine the primary accuracy metric, complementary metrics, horizon and
  variable aggregation, rolling forecast origins, and repeated runs.
  Explain the uncertainty summaries and retain all experiment configurations,
  split definitions, and outputs. Include simple-reference skill comparisons
  and report variability as well as means.
  Starting references: #cite(<hyndman2021>, supplement: [Secs. 5.8 and 5.10])
  and #cite(<qiu2024>).
]

== Ablations and Secondary Resource Measurements
#todo[
  Compare the selected hybrid with its conventional counterpart and examine
  tensor rank or representation choices. Define parameter-matched ablations
  separately from the main accuracy-oriented competition. Measure parameter
  count, training and inference time, and peak memory under documented hardware
  and batch settings. Use these measurements to interpret feasibility after
  the main forecasting result.
]
