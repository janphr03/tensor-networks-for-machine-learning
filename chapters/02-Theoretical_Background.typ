#import "/template.typ": *

= Theoretical Background <background>
#todo[
  Start with the forecasting problem, explain established solutions, and then
  motivate the tensor-based approach. Introduce mathematics where it becomes
  necessary. Develop possible advantages as hypotheses whose validity must
  be assessed empirically.
]

// Sections 2.4–2.6 are drafted with original numerical examples and vector figures.
// Adjust the other learning scaffolds once the datasets and models are selected.
// Planning target: about 28–35 pages within the 80–100-page study.
// Reading map: notes/chapter-2-learning-guide.md.
// Dated model evidence: notes/tensor-model-literature-review.md.

== Time-Series Forecasting <time-series-foundations>
#todo[
  Define the application and forecasting task before introducing model
  architectures. Establish what the data represent and what information is
  available when a prediction is made.
]

=== Time Series and Motivation for Forecasting
#todo[
  Define a time series, its time index, sampling frequency, and univariate or
  multivariate form. Give an illustrative example and explain the practical
  purpose of forecasting. Replace the example with the professor's actual data
  once available. Financial prices, returns, or volatility require different
  targets and must be distinguished if finance becomes the application.
  Starting reference: #cite(<hyndman2021>).
]

=== Temporal Structure and Predictability
#todo[
  Explain trend, seasonality, noise, autocorrelation, stationarity, and changing
  data distributions. Relate temporal and cross-variable dependencies to what a
  forecasting model might learn. Introduce chaotic dynamics only if the actual
  datasets justify it. Starting reference:
  #cite(<hyndman2021>, supplement: [Secs. 2.3, 2.8, and 9.1]).
]

=== Forecasting Tasks, Windows, and Available Information
#todo[
  Define targets, input windows, forecast horizons, covariates, and direct or
  recursive multi-step prediction. Illustrate chronological data partitions
  and explain why preprocessing must use only information available at the
  forecast origin. Specify the actual pipeline later in @methodology.
  Starting reference: #cite(<hyndman2021>, supplement: [Secs. 5.8 and 5.10]).
]

== Established Forecasting Methods <forecasting-ml-foundations>
#todo[
  Explain the relevant statistical, classical machine-learning, and neural
  forecasting approaches. Develop the models used in the experiment in depth;
  keep the other families as orientation.
]

=== Simple and Statistical Baselines
#todo[
  Introduce naive and seasonal-naive forecasts and explain the rationale for
  using them as reference points. Outline autoregression and ARIMA; add ETS or
  vector autoregression if the selected data warrant them. If forecasting
  financial price levels, include the last-observation or random-walk baseline.
  Starting reference: #cite(<hyndman2021>, supplement: [Sec. 5.2 and Ch. 9]).
]

=== Supervised Learning, Optimization, and Generalization
#todo[
  Introduce regression, model parameters, hyperparameters, training losses,
  optimization, regularization, and early stopping. Explain the difference
  between fitting training data and predicting unseen future observations.
  Establish basic vector and probability notation as needed.
  Starting references: #cite(<james2023>, supplement: [Ch. 2]) and
  #cite(<goodfellow2016>, supplement: [Chs. 5, 7, and 8]).
]

=== Classical Machine Learning with Lagged Features
#todo[
  Explain how lagged observations and known covariates turn forecasting into a
  supervised prediction task. Introduce linear or ridge regression and
  tree-based methods such as gradient boosting. Add support vector regression
  only if it is selected. Explain how these methods receive temporal
  information through the feature representation.
  Starting references: #cite(<james2023>, supplement: [Chs. 3, 6, and 8]) and
  #cite(<chen2016>).
]

=== Neural Forecasting Architectures
#todo[
  Explain linear and MLP-based forecasters, RNNs and LSTMs, temporal
  convolutions, and attention. Connect each architecture to input windows and
  forecast outputs. Use DLinear, N-BEATS, PatchTST, and iTransformer as reading
  examples, not as a fixed current ranking. Explain only the architectural
  mechanisms that are relevant to the eventual comparison.
  Starting references: #cite(<goodfellow2016>, supplement: [Chs. 6, 9, and 10]),
  #cite(<bai2018>), #cite(<vaswani2017>), #cite(<zeng2023>),
  #cite(<oreshkin2020>), #cite(<nie2023>), and #cite(<liu2024>).
]

=== Pretraining and Time-Series Foundation Models
#todo[
  Explain dataset-specific training, zero-shot forecasting, and fine-tuning.
  Consider a suitable pretrained forecaster as an additional accuracy-oriented
  competitor, documenting its external training data and supported inputs.
  Chronos-2 is a starting example; refresh the candidate list when the datasets
  and experiments are fixed. Starting reference: #cite(<ansari2025>).
]

== Motivation for Tensor-Based Forecasting <tensor-motivation>
#todo[
  Connect the requirements of forecasting to the tensor-based approach before
  introducing its formal mathematics. Distinguish tensors as data objects from
  tensor decompositions and tensor-network prediction models.
]

=== Modeling Higher-Order and Cross-Variable Dependencies
#todo[
  Explain why interactions among past states or several variables may matter,
  and how explicit multiplicative interactions provide one possible modeling
  choice. Motivate tensor representations using higher-order recurrent models.
  Ordinary neural networks also use tensors; the proposed contribution must
  identify the specific factorization or network structure.
  Starting reference: #cite(<yu2019>).
]

=== Structured Representations and Accuracy Hypotheses
#todo[
  Motivate low-rank structure as a way to constrain the learned representation
  and potentially improve generalization. Introduce modeling interactions,
  regularization, and compact representations as related motivations.
  Compression alone does not establish improved forecasting accuracy. State
  testable hypotheses and expected failure cases rather than assuming that
  tensor-based models are superior.
  Starting references: #cite(<novikov2015>), #cite(<yu2019>), and
  #cite(<shi2020>).
]

#include "tensor-mathematical-foundations.typ"

#include "tensor-network-principles.typ"

#include "tensor-learning-models.typ"

== Evaluating Forecasting Accuracy <evaluation-foundations>
#todo[
  Make held-out forecast quality the main basis for model selection and
  comparison. Explain secondary resource metrics after the accuracy protocol.
]

=== Prediction Errors and Task-Specific Metrics
#todo[
  Define MAE, RMSE or MSE, and scaled metrics such as MASE when appropriate.
  Explain horizon-wise and cross-variable aggregation, original versus
  normalized units, and percentage-error issues near zero. If the target is
  financial direction, define classification metrics separately; portfolio
  returns or Sharpe ratios are additional application outcomes.
  Starting reference: #cite(<hyndman2021>, supplement: [Sec. 5.8]).
]

=== Temporal Validation and Reliable Comparisons
#todo[
  Explain chronological train-validation-test partitions, rolling-origin
  evaluation, leakage prevention, comparable input information, and tuning
  budgets. Report variability across repeated runs and forecast origins,
  accounting for temporal dependence if uncertainty intervals are used.
  Starting references: #cite(<hyndman2021>, supplement: [Sec. 5.10]) and
  #cite(<qiu2024>).
]

=== Secondary Parameter and Resource Measurements
#todo[
  Define parameter count, training time, inference time, and peak memory.
  Report these alongside accuracy to describe practical feasibility. State
  hardware, batch size, precision, and the costs included for pretrained
  models. Keep a separate parameter-matched ablation where it helps identify
  the tensor component's effect; use accuracy-oriented tuning for the main
  model comparison.
]

== Related Work and Evidence for Model Selection <related-work>
#todo[
  Review original papers and their exact benchmark scope. Separate evidence of
  lower numeric forecast error, improved direction classification, comparable
  accuracy, and resource savings. Record paper versions and the date of review.
  Initial evidence review: 7 October 2026.
]

=== Tensor and Hybrid Models with Forecasting Evidence
#todo[
  Review HOT-LSTM, BHT-ARIMA, LSTM-MERA, and the MPO/Volterra approach. Record
  datasets, targets, horizons, baselines, metric definitions, splits, and code.
  The 2026 revision of #cite(<martinez2026>) reports comparable optimized
  median forecasting performance to ESNs; do not infer an unconditional
  accuracy win from older abstract wording.
  Starting references: #cite(<yu2019>), #cite(<shi2020>), and #cite(<meng2021>).
  #cite(<you2025>) is an additional chaotic-dynamics lead, with a narrower
  comparison scope than a current forecasting benchmark.
]

=== Business and Financial Applications and Transferability
#todo[
  Assess BHT-ARIMA's evidence on sales and raw-materials series against the
  actual DATEV task if it concerns related business series. Treat market-data
  studies as additional context unless the dataset confirms that application.
  Distinguish
  #cite(<xu2021>) on next-day currency direction classification from
  #cite(<kobayashi2023>) on cross-sectional stock-return predictions evaluated
  through portfolio backtesting. Inspect regression evidence such as
  #cite(<dacosta2021>) without assuming a tensor accuracy advantage.
  Verify data availability and task compatibility before selecting a model.
]

=== Strong Established Forecasting Competitors
#todo[
  Review statistical and lag-feature ML methods alongside DLinear, N-BEATS,
  PatchTST, iTransformer, and a suitable pretrained model. Use the actual
  datasets, horizons, and validated implementations to select the competitors.
  These examples form an initial candidate set, not a claim to a complete
  October 2026 SOTA ranking.
  Starting references: #cite(<qiu2024>), #cite(<zeng2023>), #cite(<oreshkin2020>),
  #cite(<nie2023>), #cite(<liu2024>), and #cite(<ansari2025>).
]

=== Synthesis, Research Gap, and Selection Criteria
#todo[
  Build an evidence table separating each reported advantage from its
  limitations. Prioritize task compatibility, held-out accuracy evidence,
  strong baselines, and reproducibility. The study will test whether published
  advantages transfer to the research group's datasets and remain when stronger
  competitors and an identical protocol are used. Make the concrete model
  choices in @methodology.
]
