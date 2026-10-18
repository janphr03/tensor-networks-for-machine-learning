== Time-Series Forecasting <time-series-foundations>

Before comparing forecasting models, the task itself must be clear. This
section answers three questions: What is a time series? Which patterns might
help us predict it? And which past values are used to predict which future
values? An invented example of hourly temperature readings connects these
questions. It illustrates the concepts and does not describe the research data.

#pagebreak(weak: true)
#block(breakable: false)[
=== What Is a Time Series? <ts-basics>

A *time series* is a sequence of measurements, each assigned to a point in
time and kept in chronological order @hyndman2021[Ch. 2].
Recording only one quantity, such as temperature every hour, gives a
*univariate* time series (@fig-ts-tracks).
Recording several variables, such as temperatures at two locations at the same
hours, gives a *multivariate* time series (@fig-ts-multivariate).

#figure(
  image("../figures/forecasting/01-simple-time-series.svg", width: 100%,
    alt: "Eight hourly temperature readings: 12, 13, 15, 16, 15, 14, 13, and 12 degrees Celsius."),
  caption: [One quantity over time: hourly temperature (invented values).],
) <fig-ts-tracks>

#figure(
  image("../figures/forecasting/01-simple-multivariate.svg", width: 100%,
    alt: "Two temperature curves, labelled Location A and Location B, share one coordinate system with hour on the horizontal axis and degrees Celsius on the vertical axis."),
  caption: [Two variables at the same times: temperatures at locations A and B (invented values).],
) <fig-ts-multivariate>
]

#pagebreak(weak: true)
=== Which Patterns Can Help a Forecast? <ts-structure>

Past measurements can help predict future values when a development continues
or a pattern repeats. Three common patterns are *trend*, *seasonality*, and
*cycles* @hyndman2021[Sec. 2.3]. The following invented examples show them
separately so that their differences are easy to see.

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Trend]
]
A trend is a longer-term increase or decrease, such as demand growing
over several years. If this development continues, it provides a starting
point for forecasting future demand.

#figure(
  image("../figures/forecasting/02-pattern-trend.svg", width: 90%,
    alt: "An invented demand index increases from 65 to 110 over eight years."),
  caption: [Trend: demand increases over several years (invented values).],
) <fig-ts-trend>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Seasonality]
]
A seasonal pattern repeats at fixed intervals, such as sales
peaking every December. Knowing the time of year therefore helps predict
when the next peak is likely to occur.

#figure(
  image("../figures/forecasting/02-pattern-seasonality.svg", width: 90%,
    alt: "An invented monthly demand index repeats the same pattern over three years, with a peak every December."),
  caption: [Seasonality: a peak every December, twelve months apart (invented values).],
) <fig-ts-seasonality>
]

#block(breakable: false)[
#block(inset: (top: 6pt, bottom: 6pt))[
  #text(size: 12.5pt, weight: "bold", fill: blue)[Cycles]
]
Cycles are rises and falls without a fixed period, such as demand
changing with economic conditions. They can help describe longer-term
movements, but their varying duration makes the next turning point harder to
predict than a seasonal peak.

#figure(
  image("../figures/forecasting/02-pattern-cycles.svg", width: 90%,
    alt: "An invented demand index has peaks at years 2, 6, and 13: the gaps between peaks are four and seven years."),
  caption: [Cycles: peaks occur after different intervals (invented values).],
) <fig-ts-cycles>
]

These patterns can occur together, and they do not guarantee accurate
forecasts: a trend can change and a repeating pattern can weaken.
Past values and other variables can also provide useful information; for
example, the current temperature can help predict the temperature one hour
later. Unpredictable noise, by contrast, cannot be forecast reliably.

=== Why Can Past Observations Help Predict the Future? <ts-tasks>

The patterns above matter because future observations may follow relationships
already present in the past. Hyndman and Athanasopoulos identify two conditions
for quantitative forecasting: numerical observations of the past must be
available, and it must be reasonable to assume that some aspects of past
patterns will continue into the future @hyndman2021[Sec. 1.4].

For example, if demand has repeatedly increased every December, this gives
us a reason to expect higher demand next December. The future values do not
have to match the old values exactly; the useful information is the recurring
relationship between the time of year and demand.

This is an assumption to assess, not a guarantee. Customer behaviour can
change, a trend can end, and unexpected events can disrupt an established
pattern. Past observations are therefore useful only to the extent that they
contain information relevant to the future being predicted. Forecasts must
be checked against later observations to see whether the learned relationships
actually remain useful @hyndman2021[Secs. 1.1 and 1.7].

A forecasting model turns this idea into a concrete task: use known past
values to estimate unknown future values. In the temperature example below,
the *input window* contains four past readings and the *forecast horizon*
covers the next two hours.

#figure(
  image("../figures/forecasting/04-simple-window.svg", width: 100%,
    alt: "Four known temperature readings at hours 5 to 8 are used to predict the two unknown values at hours 9 and 10."),
  caption: [From available observations to unknown future values: four inputs and two prediction targets.],
) <fig-ts-window>

The following section introduces methods for learning or representing such
relationships. Their usefulness is assessed on unseen future observations
using the evaluation principles in @evaluation-foundations.
