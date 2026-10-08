#import "layout.typ": *

// Edit your title and personal details here.
#let data = (
  title: "Tensor Networks for Machine Learning",
  work-type: "Student Research Paper",
  author: "Your name",
  degree: "Degree programme",
  university: "University",
  student-id: "Student ID",
  course: "Course",
  period: "Writing period",
  partner: "Partner organisation",
  supervisor: "Academic supervisor",
  partner-supervisor: "Partner supervisor",
  submission-date: "Submission date",
  partner-logo: none, // Replace none with an image path, e.g. "partner.png".
  university-logo: none,
)

// Optional front matter. Enable only the sections required for this thesis.
#let with-confidentiality = false
#let with-german-abstract = false

#set document(title: data.title, author: data.author)
#show: thesis
#title-page(data)

#if with-confidentiality {
  unnumbered([Confidentiality Notice], listed: false)
  placeholder([Insert the confidentiality notice.])
  pagebreak()
}

#unnumbered([Declaration of Originality], listed: false)
#placeholder[Insert the declaration of originality required for this thesis.]
#v(2cm)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 2cm,
  [#placeholder[Place, date]\ #line(length: 100%)\ Place, date], [#v(1em) #line(length: 100%)\ Signature],
)

// Front matter: Roman page numbers, no running header.
#pagebreak()
#set page(numbering: "I", footer: page-footer())
#counter(page).update(1)
#align(center, heading(numbering: none, outlined: false)[Abstract])
#placeholder[Insert the English abstract.]

#if with-german-abstract {
  pagebreak()
  align(center, heading(numbering: none, outlined: false)[German Abstract])
  placeholder([Insert the German abstract.])
}

#pagebreak()
#outline(title: [Table of Contents], depth: 3, indent: 1.5em)

#figure-list(image, [List of Figures], short-captions: (
  "fig-ledger": [A tensor as an indexed ledger],
  "fig-outer": [The outer product as a loom],
  "fig-unfolding": [Unfolding the ledger],
  "fig-contraction": [Contraction as matching lanes],
  "fig-svd": [SVD as layers of a pattern],
  "fig-relay": [Latent choices across a tensor train],
  "fig-topologies": [Tensor decomposition families and network topologies],
  "fig-order": [Contraction order as packing early],
  "fig-gauge": [Gauge freedom as a coordinate translation],
  "fig-interaction": [Interactions as a bending sheet],
  "fig-learning": [A tensor model learns a curve],
))
#figure-list(table, [List of Tables])
#appendix-list()

#unnumbered([List of Abbreviations])
// Keep entries in alphabetical order; spell out abbreviations on first use.
/ ACRONYM: #placeholder[Insert the full term.]

#unnumbered([Glossary])
// Keep entries in alphabetical order; use concise definitions.
/ Term: #placeholder[Insert the definition.]

// Main matter: Arabic page numbers, each chapter starts on a new page.
#pagebreak()
#set page(numbering: "1", foreground: running-header())
#counter(page).update(1)
#set heading(numbering: "1.1", supplement: [Section])

= Introduction <introduction>
#placeholder[
  Introduce the time-series forecasting task and the research group's need for
  a reproducible classical and quantum-inspired reference for developing quantum
  algorithms. Make out-of-sample prediction accuracy the primary objective.
  Treat parameter count, runtime, and memory as secondary descriptive criteria.
]

== Motivation <motivation>
#placeholder[
  Explain why reliable forecasts matter for the research group's application.
  The research data are supplied by DATEV; the actual variables,
  sampling frequency, and prediction target are still unknown. Accounting or
  business forecasting is a possible context, while stock-market forecasting
  must not be assumed. Use #cite(<hyndman2021>) for forecasting context.
  #cite(<datevRewe>) describes DATEV's public accounting-data services, not the
  actual research dataset. Add quantum-inspired financial applications only
  when they help explain the confirmed task.
]

== Problem Statement
#placeholder[
  State the forecasting problem once the target variables, data, and horizons
  are known. Ask whether suitable tensor-network or hybrid models achieve
  lower held-out prediction error than strong established methods under a
  comparable evaluation protocol. Separate regression, directional
  classification, and portfolio evaluation when reviewing financial studies.
]

== Objectives and Research Questions
#placeholder[
  Primary question: Do tensor-network or hybrid models improve forecasting
  accuracy on the research datasets compared with relevant established models?
  Supporting questions: Which horizons and data conditions favor each method?
  Does the tensor component contribute beyond its conventional counterpart?
  Secondary question: What parameter count and resource use accompany the
  measured accuracy? Deliver reproducible implementations and evaluation
  material that the research group can reuse for its quantum algorithms.
]

== Structure of the Thesis
#placeholder[
  Explain the progression in @background: time series and forecasting,
  established methods, motivation for tensor-based models, tensor foundations,
  tensor networks, and their use in prediction. The literature review then
  motivates the experimental choices in @methodology. Present accuracy first
  in @results and answer the research questions in @conclusion.
]

= Theoretical Background <background>
#placeholder[
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
#placeholder[
  Define the application and forecasting task before introducing model
  architectures. Establish what the data represent and what information is
  available when a prediction is made.
]

=== Time Series and Motivation for Forecasting
#placeholder[
  Define a time series, its time index, sampling frequency, and univariate or
  multivariate form. Give an illustrative example and explain the practical
  purpose of forecasting. Replace the example with the professor's actual data
  once available. Financial prices, returns, or volatility require different
  targets and must be distinguished if finance becomes the application.
  Starting reference: #cite(<hyndman2021>).
]

=== Temporal Structure and Predictability
#placeholder[
  Explain trend, seasonality, noise, autocorrelation, stationarity, and changing
  data distributions. Relate temporal and cross-variable dependencies to what a
  forecasting model might learn. Introduce chaotic dynamics only if the actual
  datasets justify it. Starting reference:
  #cite(<hyndman2021>, supplement: [Secs. 2.3, 2.8, and 9.1]).
]

=== Forecasting Tasks, Windows, and Available Information
#placeholder[
  Define targets, input windows, forecast horizons, covariates, and direct or
  recursive multi-step prediction. Illustrate chronological data partitions
  and explain why preprocessing must use only information available at the
  forecast origin. Specify the actual pipeline later in @methodology.
  Starting reference: #cite(<hyndman2021>, supplement: [Secs. 5.8 and 5.10]).
]

== Established Forecasting Methods <forecasting-ml-foundations>
#placeholder[
  Explain the relevant statistical, classical machine-learning, and neural
  forecasting approaches. Develop the models used in the experiment in depth;
  keep the other families as orientation.
]

=== Simple and Statistical Baselines
#placeholder[
  Introduce naive and seasonal-naive forecasts and explain the rationale for
  using them as reference points. Outline autoregression and ARIMA; add ETS or
  vector autoregression if the selected data warrant them. If forecasting
  financial price levels, include the last-observation or random-walk baseline.
  Starting reference: #cite(<hyndman2021>, supplement: [Sec. 5.2 and Ch. 9]).
]

=== Supervised Learning, Optimization, and Generalization
#placeholder[
  Introduce regression, model parameters, hyperparameters, training losses,
  optimization, regularization, and early stopping. Explain the difference
  between fitting training data and predicting unseen future observations.
  Establish basic vector and probability notation as needed.
  Starting references: #cite(<james2023>, supplement: [Ch. 2]) and
  #cite(<goodfellow2016>, supplement: [Chs. 5, 7, and 8]).
]

=== Classical Machine Learning with Lagged Features
#placeholder[
  Explain how lagged observations and known covariates turn forecasting into a
  supervised prediction task. Introduce linear or ridge regression and
  tree-based methods such as gradient boosting. Add support vector regression
  only if it is selected. Explain how these methods receive temporal
  information through the feature representation.
  Starting references: #cite(<james2023>, supplement: [Chs. 3, 6, and 8]) and
  #cite(<chen2016>).
]

=== Neural Forecasting Architectures
#placeholder[
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
#placeholder[
  Explain dataset-specific training, zero-shot forecasting, and fine-tuning.
  Consider a suitable pretrained forecaster as an additional accuracy-oriented
  competitor, documenting its external training data and supported inputs.
  Chronos-2 is a starting example; refresh the candidate list when the datasets
  and experiments are fixed. Starting reference: #cite(<ansari2025>).
]

== Motivation for Tensor-Based Forecasting <tensor-motivation>
#placeholder[
  Connect the requirements of forecasting to the tensor-based approach before
  introducing its formal mathematics. Distinguish tensors as data objects from
  tensor decompositions and tensor-network prediction models.
]

=== Modeling Higher-Order and Cross-Variable Dependencies
#placeholder[
  Explain why interactions among past states or several variables may matter,
  and how explicit multiplicative interactions provide one possible modeling
  choice. Motivate tensor representations using higher-order recurrent models.
  Ordinary neural networks also use tensors; the proposed contribution must
  identify the specific factorization or network structure.
  Starting reference: #cite(<yu2019>).
]

=== Structured Representations and Accuracy Hypotheses
#placeholder[
  Motivate low-rank structure as a way to constrain the learned representation
  and potentially improve generalization. Introduce modeling interactions,
  regularization, and compact representations as related motivations.
  Compression alone does not establish improved forecasting accuracy. State
  testable hypotheses and expected failure cases rather than assuming that
  tensor-based models are superior.
  Starting references: #cite(<novikov2015>), #cite(<yu2019>), and
  #cite(<shi2020>).
]

#include "chapters/tensor-mathematical-foundations.typ"

#include "chapters/tensor-network-principles.typ"

#include "chapters/tensor-learning-models.typ"

== Evaluating Forecasting Accuracy <evaluation-foundations>
#placeholder[
  Make held-out forecast quality the main basis for model selection and
  comparison. Explain secondary resource metrics after the accuracy protocol.
]

=== Prediction Errors and Task-Specific Metrics
#placeholder[
  Define MAE, RMSE or MSE, and scaled metrics such as MASE when appropriate.
  Explain horizon-wise and cross-variable aggregation, original versus
  normalized units, and percentage-error issues near zero. If the target is
  financial direction, define classification metrics separately; portfolio
  returns or Sharpe ratios are additional application outcomes.
  Starting reference: #cite(<hyndman2021>, supplement: [Sec. 5.8]).
]

=== Temporal Validation and Reliable Comparisons
#placeholder[
  Explain chronological train-validation-test partitions, rolling-origin
  evaluation, leakage prevention, comparable input information, and tuning
  budgets. Report variability across repeated runs and forecast origins,
  accounting for temporal dependence if uncertainty intervals are used.
  Starting references: #cite(<hyndman2021>, supplement: [Sec. 5.10]) and
  #cite(<qiu2024>).
]

=== Secondary Parameter and Resource Measurements
#placeholder[
  Define parameter count, training time, inference time, and peak memory.
  Report these alongside accuracy to describe practical feasibility. State
  hardware, batch size, precision, and the costs included for pretrained
  models. Keep a separate parameter-matched ablation where it helps identify
  the tensor component's effect; use accuracy-oriented tuning for the main
  model comparison.
]

== Related Work and Evidence for Model Selection <related-work>
#placeholder[
  Review original papers and their exact benchmark scope. Separate evidence of
  lower numeric forecast error, improved direction classification, comparable
  accuracy, and resource savings. Record paper versions and the date of review.
  Initial evidence review: 7 October 2026.
]

=== Tensor and Hybrid Models with Forecasting Evidence
#placeholder[
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
#placeholder[
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
#placeholder[
  Review statistical and lag-feature ML methods alongside DLinear, N-BEATS,
  PatchTST, iTransformer, and a suitable pretrained model. Use the actual
  datasets, horizons, and validated implementations to select the competitors.
  These examples form an initial candidate set, not a claim to a complete
  October 2026 SOTA ranking.
  Starting references: #cite(<qiu2024>), #cite(<zeng2023>), #cite(<oreshkin2020>),
  #cite(<nie2023>), #cite(<liu2024>), and #cite(<ansari2025>).
]

=== Synthesis, Research Gap, and Selection Criteria
#placeholder[
  Build an evidence table separating each reported advantage from its
  limitations. Prioritize task compatibility, held-out accuracy evidence,
  strong baselines, and reproducibility. The study will test whether published
  advantages transfer to the research group's datasets and remain when stronger
  competitors and an identical protocol are used. Make the concrete model
  choices in @methodology.
]

= Methodology <methodology>
#placeholder[
  Translate the accuracy-first research questions into reproducible
  experiments. Document the actual data, model choices, training, and
  evaluation decisions.
]

== Research Design and Model Selection
#placeholder[
  Describe dataset analysis, the dated literature review, and the resulting
  model selection. Choose at least one tensor or hybrid method, its relevant
  conventional counterpart, a simple baseline, and strong task-appropriate
  competitors. Model selection depends on validation accuracy and available
  training resources; the final test set remains reserved for evaluation.
  Protocol reference: #cite(<qiu2024>).
]

== Datasets, Forecasting Tasks, and Preprocessing
#placeholder[
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
#placeholder[
  Identify original implementations, versions, and adaptations. Document
  tensor representations, ranks, loss functions, optimizers, early stopping,
  random seeds, tuning budgets, and pretrained weights. Select configurations
  by a predefined validation metric appropriate to the target. Give every
  model a defensible tuning opportunity within the stated resource budget.
]

== Evaluation Protocol and Reproducibility
#placeholder[
  Predefine the primary accuracy metric, complementary metrics, horizon and
  variable aggregation, rolling forecast origins, and repeated runs.
  Explain the uncertainty summaries and retain all experiment configurations,
  split definitions, and outputs. Include simple-reference skill comparisons
  and report variability as well as means.
  Starting references: #cite(<hyndman2021>, supplement: [Secs. 5.8 and 5.10])
  and #cite(<qiu2024>).
]

== Ablations and Secondary Resource Measurements
#placeholder[
  Compare the selected hybrid with its conventional counterpart and examine
  tensor rank or representation choices. Define parameter-matched ablations
  separately from the main accuracy-oriented competition. Measure parameter
  count, training and inference time, and peak memory under documented hardware
  and batch settings. Use these measurements to interpret feasibility after
  the main forecasting result.
]

= Results and Discussion <results>
#placeholder[
  Present the actual empirical evidence, beginning with forecast accuracy.
  Interpret practical requirements and transferability after establishing
  the prediction results.
]

== Forecasting Accuracy
#placeholder[
  Report the primary metric by dataset and horizon, followed by complementary
  errors, variability, baseline comparisons, and representative forecasts.
  Distinguish a measured difference from a statistically supported or
  practically meaningful advantage. Keep regression and directional
  classification results in separate comparisons.
]

== Contribution of the Tensor Component
#placeholder[
  Present the conventional-versus-hybrid ablations and tensor-rank sensitivity.
  Explain whether any accuracy improvement persists across runs and horizons.
  Use these results to assess whether the tensor component contributes beyond
  architecture size, preprocessing, or additional tuning.
]

== Parameter Count and Computational Requirements
#placeholder[
  Present parameter count, training time, inference time, and memory as secondary
  results. Explain what resources accompany the best forecasts and whether the
  models fit the research group's practical constraints.
]

== Discussion and Limitations
#placeholder[
  Relate findings to the research questions and published evidence. Discuss
  data properties, model structure, ranks, optimization, and evaluation scope,
  separating tested explanations from hypotheses. State which conclusions
  transfer to the group's quantum-algorithm work and which require additional
  experiments. An accuracy gain is an outcome to establish, not a prerequisite
  for a scientifically useful comparison.
]

= Conclusion and Outlook <conclusion>
#placeholder[
  Answer the accuracy-first research question using the study's own results.
  Explain the contribution of the reproducible comparison to the research
  group's work.
]

== Answers to the Research Questions
#placeholder[
  Summarize whether tensor or hybrid models improve prediction accuracy for
  the studied tasks and specify the supported conditions and limitations.
  Discuss parameter and resource findings second. Identify the implementations,
  evaluation protocol, and results delivered as a reusable reference.
]

== Future Work
#placeholder[
  Derive follow-up experiments from observed limitations: additional data,
  horizons, representations, hybrid architectures, or quantum algorithms.
  Prioritize directions supported by the results. Clarify that new quantum
  implementations would need their own accuracy and resource evaluation.
]

#sources("references.bib")

#unnumbered([Declaration of AI Use])
#placeholder[Document the tools used, their purposes, and your own verification.]

// Appendices: A, B, ...; subsections A.1, A.2, ...; page numbers continue.
#pagebreak()
#counter(heading).update(0)
#set heading(numbering: "A.1", supplement: [Appendix])

= Supplementary Materials <appendix>
#placeholder[
  Collect supporting material that would interrupt the main argument, such as
  longer derivations, complete hyperparameter configurations, additional result
  tables, and details needed to reproduce the experiments.
]

== Reproducibility Materials
#placeholder[
  Add the dataset and split descriptions, software versions, model settings,
  experiment commands, and a guide to the stored outputs that the research
  group needs to repeat the study. Include additional derivations or results
  in separate appendix sections when they become available.
]
