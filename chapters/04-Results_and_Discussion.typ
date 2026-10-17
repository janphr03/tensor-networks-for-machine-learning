#import "/template.typ": *

= Results and Discussion <results>
#todo[
  Present the actual empirical evidence, beginning with forecast accuracy.
  Interpret practical requirements and transferability after establishing
  the prediction results.
]

== Forecasting Accuracy
#todo[
  Report the primary metric by dataset and horizon, followed by complementary
  errors, variability, baseline comparisons, and representative forecasts.
  Distinguish a measured difference from a statistically supported or
  practically meaningful advantage. Keep regression and directional
  classification results in separate comparisons.
]

== Contribution of the Tensor Component
#todo[
  Present the conventional-versus-hybrid ablations and tensor-rank sensitivity.
  Explain whether any accuracy improvement persists across runs and horizons.
  Use these results to assess whether the tensor component contributes beyond
  architecture size, preprocessing, or additional tuning.
]

== Parameter Count and Computational Requirements
#todo[
  Present parameter count, training time, inference time, and memory as secondary
  results. Explain what resources accompany the best forecasts and whether the
  models fit the research group's practical constraints.
]

== Discussion and Limitations
#todo[
  Relate findings to the research questions and published evidence. Discuss
  data properties, model structure, ranks, optimization, and evaluation scope,
  separating tested explanations from hypotheses. State which conclusions
  transfer to the group's quantum-algorithm work and which require additional
  experiments. An accuracy gain is an outcome to establish, not a prerequisite
  for a scientifically useful comparison.
]
