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

#figure-list(image, [List of Figures])
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
  Introduce the forecasting problem and the research group's interest in a
  reusable comparison between tensor-network methods and current strong
  forecasting models. State the scope of the study and explain why prediction
  quality and computational efficiency both matter.
]

== Motivation <motivation>
#placeholder[
  Describe the scientific context of the professor's datasets and quantum
  algorithms. Explain why assessing classical and quantum-inspired forecasting
  methods can provide a useful reference for the research group. Connect this
  motivation to the practical costs of training and using forecasting models.
]

== Problem Statement
#placeholder[
  State which time-series prediction problem the study will investigate and
  which aspects of the data are already known. Explain the unresolved question:
  whether suitable tensor-network models offer advantages over relevant
  state-of-the-art competitors on these particular data. Identify any task or
  dataset details that still need to be agreed with the research group.
]

== Objectives and Research Questions
#placeholder[
  Formulate research questions about forecast quality, parameter count,
  training and inference costs, and memory use. Ask under which data properties,
  horizons, or resource constraints the approaches work well or poorly.
  Define the intended deliverables: a justified model selection, reproducible
  experiments, and implementations and results the research group can reuse.
]

== Structure of the Thesis
#placeholder[
  Briefly explain the progression from the foundations and literature review
  in @background to the experimental design in @methodology, the results and
  interpretation in @results, and the answers and future directions in
  @conclusion. Show how each chapter contributes to the research questions.
]

= Theoretical Background <background>
#placeholder[
  Introduce the concepts needed to understand the forecasting task, the candidate
  models, and their evaluation. Explain how the mathematical foundations lead to
  tensor networks and their use in machine learning.
]

// Initial learning and writing scaffold; the final depth depends on the data and models.
// Planning target: about 25–30 pages within the 80–100-page study.
// German learning questions and reading suggestions: notes/chapter-2-learning-guide.md.

== Mathematical Foundations <mathematical-foundations>
#placeholder[
  Establish the notation and mathematical ideas used throughout the study.
  Focus on the tools needed to explain tensor factorizations, learned prediction
  functions, and forecast errors.
]

=== Linear Algebra and Notation
#placeholder[
  Establish notation for scalars, vectors, matrices, indices, dimensions, inner
  products, and norms. Use a small matrix example to explain shapes and matrix
  multiplication. Starting reference: #cite(<goodfellow2016>).
]

=== Rank, Singular Value Decomposition, and Low-Rank Approximation
#placeholder[
  Explain matrix rank, singular values, the singular value decomposition (SVD),
  and truncated approximation. Discuss the relationship between approximation
  error and retained rank. Work through a small example that can later be reused
  to introduce tensor decompositions. Starting reference: #cite(<oseledets2011>).
]

=== Probability and Statistics
#placeholder[
  Introduce random variables, expectation, variance, covariance, and conditional
  prediction. Distinguish point predictions from predictive distributions.
  Keep advanced probability theory conditional on the models actually used.
  Starting reference: #cite(<goodfellow2016>).
]

== Tensors and Multilinear Operations <tensor-foundations>
#placeholder[
  Develop the tensor concepts step by step before introducing entire networks.
  Connect the abstract notation to concrete data arrays and small numerical
  examples so that later model descriptions can build on a common vocabulary.
]

=== Tensor Order, Modes, and Data Representation
#placeholder[
  Introduce tensors as multidimensional arrays in the numerical setting used
  here. Distinguish order, shape, mode size, and rank. Illustrate a forecasting
  input with sample, time, and variable axes; its three axes alone do not make
  the forecasting model a tensor network. Starting reference: #cite(<kolda2009>).
]

=== Tensor Products, Unfolding, and Contraction
#placeholder[
  Explain outer products, reshaping, mode unfolding, and contraction over shared
  indices. Relate a contraction to matrix multiplication, and show one small
  indexed example together with its tensor diagram. Starting references:
  #cite(<kolda2009>) and #cite(<bridgeman2017>).
]

=== Tensor Rank and Classical Decompositions
#placeholder[
  Introduce rank-one tensors, CP decomposition, and Tucker decomposition as
  mathematical context. Distinguish CP rank and multilinear rank from matrix
  rank and later tensor-train ranks. Start with their representations and
  parameter counts; expand algorithms and proofs only if they become relevant.
  Starting reference: #cite(<kolda2009>).
]

== Time-Series Forecasting <time-series-foundations>
#placeholder[
  Define what is being predicted, from which information, and over which future
  horizon. Explain the temporal characteristics that can make the research
  datasets easier or harder to forecast.
]

=== Forecasting Task and Information Available at Prediction Time
#placeholder[
  Define univariate and multivariate series, look-back length, forecast horizon,
  target variables, and covariates. Formulate forecasting as a mapping from an
  observed history to future targets. Distinguish past-only inputs from
  covariates genuinely known in advance, and explain one-step versus multi-step
  prediction. Starting reference: #cite(<hyndman2021>).
]

=== Temporal Structure and Predictability
#placeholder[
  Explain trends, seasonality, noise, autocorrelation, cross-variable dependence,
  stationarity, and distribution changes. Relate these properties to what a
  forecasting model needs to learn. Treat nonlinear dynamics and chaotic
  predictability limits in more depth if the research datasets require them.
  Starting reference: #cite(<hyndman2021>).
]

=== Windowing and Preprocessing
#placeholder[
  Explain how sliding windows turn a time series into supervised examples.
  Discuss scaling, missing values, resampling, and the role of variable order
  when constructing tensor representations. Introduce the principle that
  preprocessing must respect the information available at the forecast origin;
  specify the actual dataset pipeline in the methodology chapter.
]

== Machine Learning for Forecasting <forecasting-ml-foundations>
#placeholder[
  Explain how forecasting models learn from data and introduce the architectural
  ideas needed to understand the current competitors. Adjust the depth of each
  model family once the literature review and dataset analysis guide selection.
]

=== Learning Objectives, Optimization, and Generalization
#placeholder[
  Introduce supervised regression, model parameters, hyperparameters, loss
  functions, gradient-based optimization, regularization, and early stopping.
  Explain overfitting and the distinction between a training loss and a held-out
  forecast error. Starting reference: #cite(<goodfellow2016>).
]

=== Forecasting Architecture Families
#placeholder[
  Explain the modeling ideas behind linear or MLP-based forecasters, recurrent
  models, temporal convolutions, and attention-based models. Introduce temporal
  patches and ways of modeling cross-variable interactions. Use this overview
  to understand current methods, and later develop the chosen competitors in
  greater depth. Starting references: #cite(<vaswani2017>) and #cite(<nie2023>).
]

=== Pretraining and Time-Series Foundation Models
#placeholder[
  Explain dataset-specific training, pretraining, zero-shot use, and fine-tuning.
  Discuss which inputs a pretrained forecaster supports and how external
  training data affects the interpretation of a comparison. Include this branch
  if such models are relevant to the datasets and experimental resources.
  Reading example: #cite(<ansari2025>); update the candidate set during the literature
  review rather than treating this example as a final model choice.
]

== Tensor Networks <tensor-network-foundations>
#placeholder[
  Explain how tensor factorizations become networks of smaller cores. Develop
  their notation, representative topologies, approximation mechanisms, and
  computational properties as the basis for understanding the candidate models.
]

=== Network Representation and Graphical Notation
#placeholder[
  Explain tensor cores, open and contracted indices, network topology, and bond
  dimensions. Connect diagrams to indexed expressions. Explain how a
  factorization can represent a high-order tensor using smaller cores, and
  which structural assumptions make this useful. Starting reference:
  #cite(<bridgeman2017>).
]

=== Matrix Product States and Tensor Trains
#placeholder[
  Use the chain representation as an introductory example. Explain the
  relationship between matrix product states (MPS) and tensor trains (TT),
  boundary ranks, and the role of internal ranks or bond dimensions. Compare
  the parameter count of a small factorization with its dense representation.
  This introductory example leaves the final forecasting architecture open.
  Starting reference: #cite(<oseledets2011>).
]

=== Operators, Trees, and Other Candidate Topologies
#placeholder[
  Introduce matrix product operators (MPO) for factorized linear maps and tree
  tensor networks (TTN) for hierarchical structure. Relate topology to how
  dependencies are represented. Give other topologies a brief orientation;
  expand only those supported by the literature and relevant to the selected
  forecasting models. Starting reference: #cite(<bridgeman2017>).
]

=== Approximation, Contraction, and Computational Cost
#placeholder[
  Explain the idea of sequential SVD and rank truncation, and how approximation
  quality depends on the retained ranks. Discuss contraction order, temporary
  tensors, and scaling with mode sizes and bond dimensions. Distinguish a
  smaller parameter count from demonstrated runtime or memory savings.
  Introduce canonical forms or gauge freedom if required by a chosen training
  algorithm. Starting references: #cite(<oseledets2011>) and #cite(<bridgeman2017>).
]

== Tensor-Network-Based Machine Learning <tensor-network-ml>
#placeholder[
  Connect tensor-network representations to trainable machine-learning models.
  Show where inputs enter the model, how a forecast is produced, and what
  properties of the representation influence learning and generalization.
]

=== Feature Representations and Prediction Functions
#placeholder[
  Explain how input features and tensor-network parameters combine into a
  prediction function. Contrast a tensor network over a feature map with a
  network used inside a neural architecture. Work through a small prediction
  example and explain what must change when moving from classification to
  time-series regression. Starting reference: #cite(<stoudenmire2016>).
]

=== Tensorized Layers and Hybrid Architectures
#placeholder[
  Explain how a weight matrix can be reshaped and factorized into tensor cores.
  Describe the distinction between factorizing a trained layer and training a
  factorized layer directly. Relate compression, expressive capacity, and
  possible hybrid recurrent or attention-based designs. Starting reference:
  #cite(<novikov2015>).
]

=== Training and Inductive Bias
#placeholder[
  Explain automatic differentiation through contractions and, where relevant,
  local or alternating optimization. Discuss how topology, feature maps,
  tensorization, and bond dimension affect the model's inductive bias. Identify
  numerical or optimization issues that later need empirical investigation.
  Starting references: #cite(<stoudenmire2016>) and #cite(<novikov2015>).
]

=== Quantum-Inspired Context
#placeholder[
  Briefly explain the quantum many-body origin of the tensor-network language
  and its use in classical computation. Add Schmidt decomposition, entanglement,
  or Born-rule models only when they help explain a selected method. Connect
  this context to the research group's quantum algorithms and define the
  computational setting of each approach. Starting reference: #cite(<bridgeman2017>).
]

== Evaluation and Computational Efficiency <evaluation-foundations>
#placeholder[
  Establish what constitutes a meaningful comparison of forecasting methods.
  Define prediction and resource metrics, explain their limitations, and outline
  the principles that make the later experiments fair and reproducible.
]

=== Forecast Quality and Uncertainty
#placeholder[
  Define candidate point-forecast metrics such as MAE, MSE or RMSE, and scaled
  errors such as MASE. Explain their units, assumptions, and aggregation across
  horizons and variables. Discuss percentage-error limitations near zero.
  Add quantile losses, interval coverage, or CRPS if probabilistic forecasts
  are part of the experiment. Starting reference: #cite(<hyndman2021>).
]

=== Resource Use and Efficiency Tradeoffs
#placeholder[
  Define parameter count, training time, inference latency or throughput,
  peak memory, and a suitable measure of arithmetic cost. Discuss the effects
  of hardware, batch size, precision, and optimizer or activation memory.
  Introduce accuracy–resource tradeoffs and Pareto comparisons. For pretrained
  models, distinguish adaptation costs from the cost of creating the pretrained
  model. Put concrete measurement procedures in the methodology chapter.
]

=== Fair and Reproducible Comparisons
#placeholder[
  Explain chronological training, validation, and test partitions, rolling-origin
  evaluation, and leakage prevention. Discuss consistent target horizons and
  input information, transparent tuning budgets, repeated runs, and variability
  across datasets. Relate reproducibility to the research group's reuse of code
  and results. Starting reference: #cite(<hyndman2021>).
]

== Related Work and State of the Art <related-work>
#placeholder[
  Position the study within the current forecasting literature on both model
  classes. Compare evidence relevant to the research datasets and derive the
  gap that the experiments will address. Keep the search and candidate set
  current when the final methods are chosen.
]

=== Tensor Networks for Time-Series Forecasting
#placeholder[
  Review recent forecasting-specific tensor-network methods using their original
  papers and available implementations. Record the architecture, input
  representation, datasets, horizons, training method, results, and reported
  resource use. A reading lead for nonlinear or chaotic data is #cite(<you2025>);
  assess its scope and publication status before using it as evidence for the
  research datasets. Extend and update this initial reading list.
]

=== Current Non-Tensor-Network Forecasting Methods
#placeholder[
  Review strong contemporary competitors for the actual task, including
  dataset-trained and pretrained approaches where appropriate. Use the same
  comparison dimensions as for tensor-network methods. Patch-based forecasting
  (#cite(<nie2023>)) and a pretrained multivariate forecaster (#cite(<ansari2025>)) illustrate
  different design choices; establish the current candidate set through a
  dated literature review and relevant benchmark evidence.
]

=== Synthesis and Criteria for Model Selection
#placeholder[
  Build a literature comparison table and identify what existing evaluations
  leave unresolved for the professor's datasets. Derive selection criteria from
  task suitability, relevant performance evidence, computational demands, and
  reproducible implementations. End with the research gap and a transition to
  the concrete dataset and model choices in the methodology chapter.
]

= Methodology <methodology>
#placeholder[
  Explain how the research questions are translated into reproducible
  experiments. Describe the actual datasets, justified model choices, training
  procedures, and evaluation protocol. Make the decisions specific enough for
  the research group to repeat and extend the comparison.
]

== Research Approach
#placeholder[
  Describe the empirical comparison and the sequence from dataset analysis and
  literature review to model selection, implementation, and evaluation.
  Justify which datasets, forecasting tasks, and current methods are included.
  State how accuracy and efficiency will be considered together and which
  questions any planned ablations or sensitivity analyses are meant to answer.
]

== Experimental Setup
#placeholder[
  Document the concrete choices behind every experiment. Explain the data,
  models, training configurations, computing environment, and measurement
  procedures, and distinguish predefined protocol choices from adjustments
  made using validation results.
]

=== Datasets, Forecasting Tasks, and Preprocessing
#placeholder[
  Describe the data source, variables, sampling, series lengths, and relevant
  temporal properties. Specify targets, input windows, horizons, covariates,
  chronological partitions, and preprocessing fitted on training data.
  Explain how windows and forecast origins respect partition boundaries and
  the information available when each prediction is made.
]

=== Models, Implementation, and Training
#placeholder[
  Identify the selected model versions and original implementations. Describe
  adaptations to the data, tensor representations and ranks where applicable,
  loss functions, optimizers, stopping criteria, random seeds, and tuning
  budgets. Document pretrained weights and fine-tuning where relevant, and
  justify any differences in the information or resources available to models.
]

=== Evaluation Protocol and Reproducibility
#placeholder[
  Specify forecast metrics, aggregation, evaluation origins, repeated runs,
  and any uncertainty summaries. Define how training time, inference cost,
  parameter count, peak memory, and arithmetic cost are measured on the stated
  hardware and software. Document warm-up and batch settings where relevant,
  and explain how configurations and outputs are retained for reuse.
]

= Results and Discussion <results>
#placeholder[
  Present the experimental evidence and interpret it in relation to the research
  questions. Organize the findings so that readers can judge forecast quality,
  resource requirements, and the reliability of any claimed advantages.
]

== Results
#placeholder[
  Report prediction errors and resource metrics for each relevant dataset and
  horizon using consistent tables and figures. Include variability across
  repeated runs, representative forecast examples, and any planned ablations.
  Show the accuracy–efficiency tradeoffs and identify which observations are
  supported by the measured results.
]

== Discussion and Limitations
#placeholder[
  Explain under which conditions the tensor-network approaches are useful and
  where they fall short. Relate observed behavior to data properties, model
  structure, ranks, optimization, and computational implementation, while
  distinguishing tested explanations from hypotheses. Discuss limits caused
  by the available datasets, tuning budget, hardware, and pretrained models,
  and assess how broadly the research group can reuse the findings.
]

= Conclusion and Outlook <conclusion>
#placeholder[
  Bring the answers to the research questions together and explain what the
  study contributes to the research group's forecasting work. Draw conclusions
  at the level justified by the experiments and derive concrete next steps.
]

== Summary
#placeholder[
  Summarize the investigated tasks, selected methods, and main findings.
  Answer whether tensor-network models provide accuracy or efficiency benefits
  on the studied data and specify the conditions and limitations of those
  answers. Identify the implementations and evaluation material delivered for
  the research group's use.
]

== Future Work
#placeholder[
  Derive further experiments or model improvements from the observed limitations
  and unresolved questions. Possible directions include additional datasets or
  horizons, alternative tensor representations, better training or contraction
  strategies, and extensions of the comparison to the group's quantum
  algorithms. Prioritize the directions that the study's evidence supports.
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
