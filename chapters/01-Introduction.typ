#import "/template.typ": *

= Introduction <introduction>
#todo[
  Introduce the time-series forecasting task and the research group's need for
  a reproducible classical and quantum-inspired reference for developing quantum
  algorithms. Make out-of-sample prediction accuracy the primary objective.
  Treat parameter count, runtime, and memory as secondary descriptive criteria.
]

== Motivation <motivation>
#todo[
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
#todo[
  State the forecasting problem once the target variables, data, and horizons
  are known. Ask whether suitable tensor-network or hybrid models achieve
  lower held-out prediction error than strong established methods under a
  comparable evaluation protocol. Separate regression, directional
  classification, and portfolio evaluation when reviewing financial studies.
]

== Objectives and Research Questions
#todo[
  Primary question: Do tensor-network or hybrid models improve forecasting
  accuracy on the research datasets compared with relevant established models?
  Supporting questions: Which horizons and data conditions favor each method?
  Does the tensor component contribute beyond its conventional counterpart?
  Secondary question: What parameter count and resource use accompany the
  measured accuracy? Deliver reproducible implementations and evaluation
  material that the research group can reuse for its quantum algorithms.
]

== Structure of the Thesis
#todo[
  Explain the progression in @background: time series and forecasting,
  established methods, motivation for tensor-based models, tensor foundations,
  tensor networks, and their use in prediction. The literature review then
  motivates the experimental choices in @methodology. Present accuracy first
  in @results and answer the research questions in @conclusion.
]
