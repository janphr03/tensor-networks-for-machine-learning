== Established Forecasting Methods <forecasting-ml-foundations>

@time-series-foundations fixed what a forecast is and what it may use. The next
question is how to produce one. This section presents the established methods
that provide possible references for the tensor models. The selection ranges
from simple rules to pretrained models and explains the learning principles
needed to understand them; it is not a complete catalogue or an accuracy ranking.

=== Simple Reference Forecasts <ml-baselines>

Before using a complex model, we should ask whether a simple rule already
produces a useful forecast. Such a rule serves as a *baseline*: a reference
against which the accuracy of other methods can be compared. Two standard
examples are the naive and seasonal naive forecasts @hyndman2021[Sec. 5.2].

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Repeat the last value]
]
The *naive forecast* uses the last measured value for every future step,
as shown in @fig-ml-naive. If the last reading is 12 °C, it predicts 12 °C
for the next hour, 12 °C for the hour after that, and so on: the orange line
stays horizontal because the rule predicts no change.

#figure(
  image("../figures/forecasting/07-repeat-last-value.svg", width: 100%,
    alt: "Blue measured temperatures end at Now; the orange forecast then stays at the last measured temperature."),
  caption: [Repeat the last value: measured temperatures in blue, forecasts in orange (invented values).],
) <fig-ml-naive>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Repeat the last seasonal pattern]
]
The *seasonal naive forecast* uses the last observed value from the same
point in the seasonal cycle, as shown in @fig-ml-seasonal. For an hourly
series with a daily cycle, tomorrow's temperatures are predicted by repeating
today's hourly values: the orange line follows the previous day's shape.

#figure(
  image("../figures/forecasting/07-repeat-seasonal-pattern.svg", width: 100%,
    alt: "Blue measured temperatures end at Now; the orange forecast repeats the hourly temperatures from the previous day."),
  caption: [Repeat the previous day: measured temperatures in blue, forecasts in orange (invented values).],
) <fig-ml-seasonal>
]

Neither rule learns a complex relationship from the data. Comparing a learned
model with these references shows whether its extra complexity improves
forecast accuracy. Neither rule is always better: their performance depends
on the series and must be measured on unseen future observations.

=== How Do Forecasting Models Learn from Examples? <ml-learning>

The previous methods repeat old values according to fixed rules. A learned
model instead fits adjustable parameters to historical examples. We still
choose its structure and training procedure; training adapts the parameters
to capture useful relationships in the data @james2023[Ch. 2].

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Turn past observations into examples]
]
Suppose we have already measured 12, 13, 15, and 16 °C at four successive
hours. To create one training example, we give the model the first three
readings as its *input* and keep the fourth as the *target*: the actual value
that its prediction should be compared with (@fig-ml-windows). The 16 °C is
therefore a measurement, not a prediction or a result calculated from the
first three numbers. Training uses many such input--target pairs from the past.

#figure(
  image("../figures/forecasting/08-sliding-windows.svg", width: 100%,
    alt: "Four measured temperatures in time order: hour 1 is 12 degrees, hour 2 is 13, hour 3 is 15, and hour 4 is 16. The first three readings are grouped as the model input; the fourth is the observed target used for comparison."),
  caption: [One training example from four measurements: three input values and the next observed value as the target (invented temperatures in °C).],
) <fig-ml-windows>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Use prediction errors to adjust parameters]
]
For each example, the model produces a prediction and compares it with the
known target. If it predicts 14 °C while the target is 16 °C, it is 2 °C too
low, as illustrated in @fig-ml-training. Training uses such errors across
many examples to adjust the model's parameters with the aim of reducing an
overall error measure @goodfellow2016[Ch. 5]. This learning from inputs and
known targets is called *supervised learning*.

#figure(
  image("../figures/forecasting/08-learning-from-error.svg", width: 100%,
    alt: "Input temperatures 12, 13, and 15 enter a model that predicts 14 degrees. Comparison with the observed target of 16 degrees gives a prediction that is 2 degrees too low; training uses errors to adjust model parameters."),
  caption: [An illustrative training step: compare the prediction with the observed target and use the error to adjust parameters.],
) <fig-ml-training>
]

#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Check whether learning helps on new data]
]
After training, the model must also predict unseen observations well.
This ability is called *generalization*: a good fit to the training examples
alone is insufficient @james2023[Ch. 2]. @evaluation-foundations explains
how this is checked.

The next section shows how a model learns to weight past observations.

=== From Past Values to Learned Forecasts <ml-classical>

The previous section explained how parameters are fitted. We now make this
concrete: what could those parameters be? Throughout this section, the input
is the same three temperature readings, 12, 13, and 15 °C, and the task is to
predict the next reading. Earlier observations used as inputs are called
*lagged values*.

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Learn how strongly to weight each value]
]
Instead of copying the latest value, a *linear regression* can multiply each
input by a learned weight and add the results. With illustrative weights
0.2, 0.3, and 0.5, the prediction is
$ 0.2 times 12 + 0.3 times 13 + 0.5 times 15 = 13.8. $
@fig-ml-linear shows this calculation. During training, the weights are
adjusted using many examples; we do not choose them separately for each
forecast. A linear model may also learn a constant offset
@james2023[Ch. 3].

#figure(
  image("../figures/forecasting/10-simple-weighted-model.svg", width: 100%,
    alt: "Temperatures 12, 13, and 15 are multiplied by illustrative weights 0.2, 0.3, and 0.5, respectively. The three contributions sum to a forecast of 13.8 degrees."),
  caption: [A linear forecast: learned weights determine each input's contribution (illustrative values).],
) <fig-ml-linear>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Allow different predictions under different conditions]
]
A linear model uses the same fitted weights for every input window. A
*decision tree* instead divides the examples into groups using questions
such as whether the latest temperature exceeds 14 °C (@fig-ml-trees).
The training procedure chooses the splits and the predictions within the
groups. The question and output values below are only an illustration;
they have not been fitted to a research dataset @james2023[Ch. 8].

#figure(
  image("../figures/forecasting/11-simple-decision-tree.svg", width: 100%,
    alt: "An illustrative decision tree asks whether the latest temperature exceeds 14 degrees. The yes branch predicts 16 degrees, and the no branch predicts 13 degrees. The example input ends in 15 degrees and follows the yes branch."),
  caption: [A decision tree: different input conditions lead to different predictions (illustrative split and values).],
) <fig-ml-trees>
]

We have now seen two ways to form a learned forecast: weight the past values
or divide inputs into groups using learned conditions. The next section
introduces a third approach: connect adjustable computations into a neural
network.

=== How Neural Networks Process the Same History <ml-neural>

Neural networks solve the same forecasting task and also learn parameters
from examples. Their distinctive feature is that they combine trainable
computations into a network. The following architectures illustrate different
ways to process the history; they are alternatives, not a ranking of accuracy.

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Process the window together: feed-forward networks]
]
A *feed-forward neural network* (*FFNN*) receives the entire input window
together: in our example, the vector of readings 12, 13, and 15 °C.
Each reading occupies a fixed input position, so the network can distinguish
the oldest value from the most recent one. It passes these inputs through
successive layers to produce a forecast (@fig-ml-feedforward).

Intermediate units extend the weighted sum introduced above by applying
nonlinear functions, allowing relationships beyond a single linear
combination @goodfellow2016[Ch. 6]. The key point is that the FFNN processes
the window as one input; it does not carry a recurrent state from one reading
to the next. N-BEATS is a forecasting architecture built from feed-forward
blocks @oreshkin2020.

#figure(
  image("../figures/forecasting/12-simple-feedforward.svg", width: 100%,
    alt: "Three input temperatures connect to two intermediate units that combine inputs and apply nonlinear functions, then to a forecast output."),
  caption: [FFNN: the three readings enter together at fixed input positions and pass through layers to form a forecast (schematic).],
) <fig-ml-feedforward>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Process one reading at a time: recurrent networks]
]
A *recurrent neural network* (*RNN*) receives the same readings one after
another: first 12 °C, then 13 °C, then 15 °C. After reading 12, it updates
an internal *state*. When it reads 13, it uses both that new value and the
previous state; it repeats this step for 15. The final state is then used
to produce the forecast (@fig-ml-recurrent) @goodfellow2016[Ch. 10].

The key difference is therefore how the history enters the computation:
the FFNN receives the whole window together, whereas the RNN passes an
updated summary from one reading to the next. The same recurrent unit and
trained parameters are reused at every step; the state changes as the values
are read. This summary need not retain every detail of the history.
An *LSTM* is a recurrent architecture with gates that control how its state
is updated @hochreiter1997.

#figure(
  image("../figures/forecasting/12-simple-recurrent.svg", width: 100%,
    alt: "Readings 12, 13, and 15 enter successive applications of the same recurrent unit. Each passes an updated state to the next; the final state feeds the forecast."),
  caption: [RNN: the readings enter one at a time, with an updated state passed to the next step; the same unit and parameters are reused.],
) <fig-ml-recurrent>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Compare parts of the history: Transformer models]
]
Which part of the history is useful can depend on the current situation.
For example, information from an earlier interval may help more than the
immediately preceding values. *Transformers* use *self-attention* to form
input-dependent connections between representations of positions in the
window @vaswani2017.

For a position being updated, attention compares learned representations
and computes weights for combining their information. @fig-ml-patches
illustrates the potential benefit: with one current pattern, an older
interval receives more weight; with a different current pattern, another
interval receives more weight. The same trained model can therefore mix
past information differently for different inputs. This differs from the
linear model above, whose fitted input weights remain fixed during prediction.

The useful property is *input-dependent access to information across the
window*, including distant positions. The sketches below illustrate this
idea; real attention weights are learned from representations, not assigned
by visually matching curves. Time-position information must also be supplied.
Attention is a component of a Transformer alongside feed-forward layers and
other operations, and does not guarantee a more accurate forecast
@vaswani2017.

#figure(
  image("../figures/forecasting/13-simple-attention.svg", width: 100%,
    alt: "Two schematic windows have the same three earlier patterns but different current patterns. In window A, the current rising pattern has attention weights 0.7, 0.2, and 0.1 over earlier intervals. In window B, the current flat pattern has weights 0.1, 0.2, and 0.7. Thick links mark greater influence; all weights are chosen for illustration."),
  caption: [Same trained model, different inputs: attention can give different past intervals more influence, including an older interval. Patterns and weights are illustrative, not outputs of a fitted model or explanations of forecast accuracy.],
) <fig-ml-patches>
]

All these architectures require training. Their additional flexibility does
not guarantee better forecasts, so they are compared with the simpler
references on unseen observations. So far, we have discussed how a model
processes its input. The next section asks where its training experience
comes from: only the chosen training data, or a larger pretraining collection.

=== Where Does a Model's Training Experience Come From? <ml-pretrained>

Two models can receive the same recent temperatures, 12, 13, and 15 °C,
but have learned from different data. The recent readings tell each model
what is happening now; its trained parameters reflect what it learned before.
The question is therefore: *which data were used to learn those parameters?*

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Experience from the task's own training data]
]
One option is to start with an untrained model and fit its parameters using
the historical training data for our task. After training, it receives the
recent readings and predicts the next value (@fig-ml-task-training).
Its training experience comes from that task's training data
@goodfellow2016[Ch. 5].

#figure(
  image("../figures/forecasting/14-task-training.svg", width: 100%,
    alt: "The task's historical training data are used to fit model parameters. After training, current readings 12, 13, and 15 are given to the trained model, which produces a forecast."),
  caption: [Train for this task, then forecast: the training data determine the fitted parameters; the recent readings provide the current input.],
) <fig-ml-task-training>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Experience gained from other time series]
]
Another option is to reuse a model already trained on a broad collection
of other time series. This earlier training is called *pretraining*.
In *zero-shot forecasting*, we give that model the same recent readings
and obtain a forecast without updating its parameters for our task
(@fig-ml-pretrained) @ansari2024. It therefore uses our observed history
as input, but brings its training experience from elsewhere.

#figure(
  image("../figures/forecasting/14-simple-pretraining.svg", width: 100%,
    alt: "Other time series are used to pretrain model parameters. The same current readings 12, 13, and 15 are then given to the pretrained model, which produces a forecast without parameter updates on this task."),
  caption: [Pretrain elsewhere, then forecast here: the current input is the same, but the fitted parameters come from other series; zero-shot use leaves them unchanged.],
) <fig-ml-pretrained>
]

A pretrained model can be further trained on our task's training data;
this is *fine-tuning* @ansari2024. Broadly pretrained models intended for reuse
across time-series tasks are often called *time-series foundation models*;
this describes training and reuse, rather than a separate architecture.

For this study, pretrained models are relevant as possible competitors to the
tensor-based models. Both receive the available history of the series being
forecast, but a pretrained model also uses parameters learned from other
series. We compare their accuracy on the same forecasting task and state
which training data each model has used. If a pretrained model performs
better, that result alone does not show that pretraining caused the advantage:
the models may also differ in architecture, size, and training procedure.
