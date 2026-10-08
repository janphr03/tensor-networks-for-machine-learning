# Lern- und Quellenplan für die umgegliederte Arbeit

Literaturrecherche: **7. Oktober 2026**; Bearbeitungsstand: **8. Oktober 2026**. Die Grundlagen in **2.4–2.6** sind jetzt als didaktischer englischer Text mit elf originalen Vektorgrafiken ausformuliert und in [main.typ](../main.typ) eingebunden. Die übrigen Abschnitte enthalten weiterhin Schreibaufträge. Zum Lesen des Grundlagenblocks gibt es [tensor-foundations.typ](../tensor-foundations.typ) und die daraus erzeugte PDF. Die [Verifizierungsnotiz](tensor-foundations-verification.md) beschreibt Quellen- und Zahlenprüfung.

**Bekannt:** Die Forschungsdaten stammen laut Projektangabe von **DATEV**. Der Vergleich soll der Forschungsgruppe als Grundlage für ihre Quantenalgorithmen dienen. **Noch offen:** konkrete Variablen, Zeitauflösung, Anzahl und Länge der Reihen, Zielgröße und Prognosehorizont. Buchhaltungs- oder betriebliche Kennzahlen sind mögliche Anwendungen; Börsenkurse sind durch die Herkunft nicht bestätigt.

**Priorität:** Vorhersagegenauigkeit auf ungesehenen Daten zuerst. Parameterzahl, Zeit und Speicher werden ergänzend beschrieben. Die Modellwahl erfolgt anhand der Validierung; die Testdaten dienen der abschließenden Auswertung.

## Aufbau und Umfang

Kapitel 2 folgt jetzt der Argumentation **Zeitreihen → etablierte Verfahren → Motivation für Tensoransätze → Tensorgrundlagen → Tensor-Netzwerke → Vorhersagemodelle → Bewertung → Forschungsstand**.

| Abschnitt in Kapitel 2 | Zweck | Richtwert |
| --- | --- | --- |
| 2.1 Time-Series Forecasting | Problem und Datenstruktur verständlich machen | 3–4 Seiten |
| 2.2 Established Forecasting Methods | Vergleichsverfahren und Lernprinzipien erklären | 5–6 Seiten |
| 2.3 Motivation for Tensor-Based Forecasting | Mögliche Vorteile als prüfbare Hypothesen entwickeln | 2–3 Seiten |
| 2.4 Mathematical Foundations | Indexnotation, Tensorprodukt, Umformen, Kontraktion, Rang und SVD | 4–5 Seiten |
| 2.5 General Principles of Tensor Networks | Faktorisation, Bindungsdimensionen, Topologien, Kontraktionskosten und Gauge-Freiheit | 4–5 Seiten |
| 2.6 Tensor Networks for Machine Learning | Feature Maps, trainierbare Kerne, Hybride und Prognoseaufgabe | 4–5 Seiten |
| 2.7 Evaluating Forecasting Accuracy | Fehlermaße und zeitliche Validierung erklären | 3 Seiten |
| 2.8 Related Work and Evidence for Model Selection | Ergebnisse und Grenzen vorhandener Arbeiten einordnen | 3–4 Seiten |

Damit sind etwa **28–35 Seiten** für die Grundlagen und den Forschungsstand vorgesehen. Für die gesamten 80–100 Seiten sind zunächst etwa 5–7 Seiten Einleitung, 15–20 Seiten Methodik, 25–32 Seiten Ergebnisse und Diskussion sowie 4–6 Seiten Schluss sinnvoll. Die Verteilung hängt später von Daten, Modellen und Ergebnissen ab.

## Quellen für alle Hauptkapitel

| Hauptkapitel | Vorrangige Literatur und genaue Lesestellen | Eigene Aufgabe |
| --- | --- | --- |
| 1 Introduction | [Hyndman und Athanasopoulos: Forecasting — Principles and Practice, 3. Auflage](https://otexts.com/fpp3/); [DATEV: Datenservice Export Rechnungswesen](https://www.datev.de/web/de/shop/produkt-details/datev-datenservice-export-rechnungswesen-92913) als öffentlicher Anwendungskontext | Konkretes Projektproblem, Datenherkunft und Forschungsfragen formulieren. Die DATEV-Webseite ersetzt keine Beschreibung der Forschungsdaten. |
| 2 Theoretical Background | Auswahl und Lesestellen in den Abschnitten unten | Begriffe so erklären, dass Modellvergleich und Experimente nachvollziehbar werden. |
| 3 Methodology | FPP3 [5.8 Evaluating point forecast accuracy](https://otexts.com/fpp3/accuracy.html), [5.10 Time series cross-validation](https://otexts.com/fpp3/tscv.html); [Qiu et al.: TFB](https://www.vldb.org/pvldb/vol17/p2363-hu.pdf), insbesondere Abschnitt 4.3 zu Evaluation und 4.4 zur gemeinsamen Pipeline; Originalpaper der ausgewählten Modelle | Tatsächliche Datenschnitte, Zielgrößen, Tuningbudgets, Modellanpassungen und Messverfahren festlegen. |
| 4 Results and Discussion | Die in 2.8 ausgewählten Originalarbeiten für den Vergleich; FPP3 5.8 für die Interpretation von Prognosefehlern | Eigene Messungen berichten. Literaturergebnisse dienen der Einordnung und dürfen keine eigenen Ergebnisse ersetzen. |
| 5 Conclusion and Outlook | Forschungsfragen aus Kapitel 1 und eigene Ergebnisse aus Kapitel 4 | Belegte Antworten und daraus abgeleitete nächste Schritte formulieren. Hier wird keine neue Modellliteratur eingeführt. |
| Appendix | Originalimplementierungen und ihre Dokumentation; die tatsächlich verwendeten Daten- und Softwarebeschreibungen | Konfigurationen, Versionen, Befehle, zusätzliche Herleitungen und vollständige Ergebnistabellen sammeln. |

## 2.1 Zeitreihen und Prognoseaufgaben

**Kernquelle:** Hyndman und Athanasopoulos, *Forecasting: Principles and Practice* (FPP3, `hyndman2021`).

Lies zuerst [2.3 Time series patterns](https://otexts.com/fpp3/tspatterns.html), [2.8 Autocorrelation](https://otexts.com/fpp3/acf.html) und [9.1 Stationarity and differencing](https://otexts.com/fpp3/stationarity.html). Ergänze 5.2, 5.8 und 5.10 für Prognoseaufgabe, Referenzverfahren und Datenteilung.

**Erarbeiten:** univariat/multivariat, Zeitindex, Trend, Saisonalität, Rauschen, Autokorrelation, Eingabefenster, Ziel und Horizont. Erläutere, welche Informationen zum Prognosezeitpunkt bekannt sind.

**Übung:** Beschreibe eine rein illustrative monatliche Kennzahlenreihe mit zwölf beobachteten Monaten und drei vorherzusagenden Monaten. Kennzeichne ausdrücklich, dass dies noch keine Eigenschaft der DATEV-Daten ist.

## 2.2 Etablierte Prognoseverfahren

**Kernquelle für klassische ML-Grundlagen:** [James et al.: An Introduction to Statistical Learning with Applications in Python](https://link.springer.com/book/10.1007/978-3-031-38747-0) (`james2023`), Kapitel 2 *Statistical Learning*, 3 *Linear Regression*, 6 *Linear Model Selection and Regularization* und 8 *Tree-Based Methods*. Kapitel 9 *Support Vector Machines* nur bei Auswahl von SVR. Die [Autorenseite](https://www.statlearning.com/) bietet das Buch und Lernmaterial.

**Kernquelle für neuronale Netze:** [Goodfellow, Bengio und Courville: Deep Learning](https://www.deeplearningbook.org/) (`goodfellow2016`), Kapitel 5 *Machine Learning Basics*, 6 *Deep Feedforward Networks*, 7 *Regularization for Deep Learning*, 8 *Optimization for Training Deep Models* und 10 *Sequence Modeling*. Kapitel 9 für Faltungen ergänzen.

**Originalarbeiten nach Modellfamilie:**

| Thema | Quelle | Leseschwerpunkt |
| --- | --- | --- |
| Naive/seasonal-naive und ARIMA | FPP3 [5.2](https://otexts.com/fpp3/simple-methods.html) und [Kapitel 9](https://otexts.com/fpp3/arima.html) | Einfache Referenz und statistische Prognose |
| Gradient Boosting | [Chen und Guestrin: XGBoost](https://arxiv.org/abs/1603.02754), `chen2016` | Lernprinzip; zeitliche Information separat durch kausale Lag-Features bereitstellen |
| Zeitliche Faltungen | [Bai et al.](https://arxiv.org/abs/1803.01271), `bai2018` | Kausale Faltungen und zeitliches Rezeptivfeld |
| Attention | [Vaswani et al.](https://arxiv.org/abs/1706.03762), `vaswani2017` | Grundmechanismus; die Originalaufgabe ist Sprachverarbeitung |
| Lineare neuronale Referenz | [Zeng et al.: DLinear](https://ojs.aaai.org/index.php/AAAI/article/view/26317), `zeng2023` | Einfache Architektur und kritischer Modellvergleich |
| Univariate neuronale Prognose | [Oreshkin et al.: N-BEATS](https://arxiv.org/abs/1905.10437), `oreshkin2020` | Residualblöcke und Basisdarstellungen |
| Patch-Transformer | [Nie et al.: PatchTST](https://arxiv.org/abs/2211.14730), `nie2023` | Patches und geteilte Verarbeitung der Kanäle |
| Multivariate Attention | [Liu et al.: iTransformer](https://proceedings.iclr.cc/paper_files/paper/2024/hash/2ea18fdc667e0ef2ad82b2b4d65147ad-Abstract-Conference.html), `liu2024` | Variablen als Tokens |
| Vortrainierte Prognose | [Ansari et al.: Chronos-2](https://arxiv.org/abs/2510.15821), `ansari2025` | Gruppen-Attention und zusätzliche Vortrainingsdaten |

**Schreibziel:** Erkläre die verwendeten Modellfamilien ausreichend tief. Die Tabelle ist eine Leseliste und keine aktuelle Rangliste. Wähle die tatsächlichen Konkurrenten nach Datensichtung und einem Pilotvergleich.

**Übung:** Zeichne den Weg vom selben Eingabefenster zur Prognose für Lag-Regression und LSTM.

## 2.3 Motivation für Tensoransätze

**Kernquellen:** [Yu et al.: Higher Order Tensor RNNs](https://arxiv.org/abs/1711.00073v3) (`yu2019`) und [Novikov et al.: Tensorizing Neural Networks](https://arxiv.org/abs/1509.06569) (`novikov2015`).

Leite aus der Prognoseaufgabe mögliche Anforderungen ab: Interaktionen zwischen Variablen, längere Historie, begrenzte Daten und eine geeignete Modellstruktur. Formuliere mögliche Genauigkeitsvorteile als Hypothesen. Erkläre, warum ein gut angepasstes Strukturmodell besser generalisieren könnte und warum eine ungeeignete Rangbeschränkung Information verlieren kann.

**Übung:** Formuliere eine positive und eine negative Hypothese zur Tensorzerlegung, jeweils mit einem Experiment, das sie prüfen könnte.

## 2.4 Tensoren und multilineare Operationen

**Ausformulierter Text:** [tensor-mathematical-foundations.typ](../chapters/tensor-mathematical-foundations.typ). Die vier Unterabschnitte entsprechen jetzt Indexnotation, Tensorprodukt/Umformen, Kontraktion und Rang/SVD. Die Ledger-, Webstuhl- und Rekonstruktionsbilder sind eigene Lehrbeispiele.

**Kernquelle:** [Kolda und Bader: Tensor Decompositions and Applications](https://www.mathsci.ai/publication/TensorReview.pdf) (`kolda2009`): Abschnitt 2 *Notation and Preliminaries*, 3 zur CP-Zerlegung und 4 zur Tucker-Zerlegung.

**Ergänzung:** Goodfellow, Kapitel 2 *Linear Algebra*, sowie [Bridgeman und Chubb](https://arxiv.org/abs/1603.03039) (`bridgeman2017`), Abschnitt 1.1–1.3 und *Aside 1* zur SVD.

Erarbeite Vektoren/Matrizen, Normen, Rang, SVD, Tensornotation, Moden, Umformen, Entfalten, Tensorprodukt und Kontraktion. Unterscheide CP-Rang, multilinearen Tucker-Rang und TT-Ränge.

**Übung:** Beschreibe Beispiele × Zeitschritte × Variablen als Tensor. Schreibe eine Matrixmultiplikation als Kontraktion. Rekonstruiere anschließend eine Matrix mit reduzierter SVD und vergleiche Approximation und Parameterzahl.

## 2.5 Tensor-Netzwerke

**Ausformulierter Text:** [tensor-network-principles.typ](../chapters/tensor-network-principles.typ). Zusätzlich zu TT/MPS werden die generischen Prinzipien von Bindungsdimensionen, Netzwerkschnitten, Kontraktionsreihenfolge und Gauge-Freiheit erklärt. [Orús](https://arxiv.org/abs/1306.2164), [Cichocki et al.](https://arxiv.org/abs/1609.00893) und [Pérez-García et al.](https://arxiv.org/abs/quant-ph/0608197) ergänzen die Kernquellen.

**Kernquelle für den Einstieg:** [Bridgeman und Chubb: Hand-waving and Interpretive Dance](https://arxiv.org/pdf/1603.03039), Abschnitt 1 *Introduction to Tensor Network Notation* und Abschnitt 3 *Matrix Product States*. Abschnitt 3.5 behandelt Operatoren; Abschnitt 5 Algorithmen. Abschnitt 7 zu MERA ist eine Vertiefung, wenn dieses Modell ausgewählt wird.

**Kernquelle für TT:** [Oseledets: Tensor-Train Decomposition](https://doi.org/10.1137/090752286) (`oseledets2011`).

Erarbeite Kerne, offene/kontrahierte Indizes, Bindungsdimension, TT/MPS und MPO. Behandle Trunkierung, Kontraktionsreihenfolge und die Beziehung zwischen Rang und Ausdrucksfähigkeit. Bäume, MERA und kanonische Formen werden nach der Modellauswahl vertieft.

**Übung:** Zeichne ein Netzwerk aus drei Kernen, beschrifte sämtliche Indizes und zähle seine Parameter. Vergleiche mehrere innere Ränge.

## 2.6 Tensor-Netzwerke und Hybridmodelle für Prognosen

**Ausformulierter Text:** [tensor-learning-models.typ](../chapters/tensor-learning-models.typ). Eine Interaktionsfläche und eine tatsächlich trainierte synthetische Kurve illustrieren Feature Maps und das Lernen der Kerne. Die Beispiele liefern keine empirischen Aussagen über die DATEV-Daten.

**Kernquelle für den Lernmechanismus:** [Stoudenmire und Schwab: Supervised Learning with Tensor Networks](https://arxiv.org/abs/1605.05775) (`stoudenmire2016`). Das Beispiel ist Klassifikation; den Übergang zur Regression musst du selbst erklären.

**Für tensorisierte Schichten:** Novikov et al. (`novikov2015`).

**Für konkrete Prognosemodelle:** Yu et al. (`yu2019`) für HOT-LSTM, [Shi et al.](https://ojs.aaai.org/index.php/AAAI/article/view/6032) (`shi2020`) für Tucker + ARIMA und [Meng und Yang](https://www.mdpi.com/1099-4300/23/11/1491) (`meng2021`) für LSTM-MERA. [Su et al.](https://arxiv.org/abs/2002.09131) (`su2020`) sind eine Vertiefung für räumliche oder bildartige Folgen.

Erkläre für jedes ausgewählte Modell: Eingang, Tensoranteil, trainierbare Parameter, Ausgang und Optimierung. Unterscheide das Ersetzen einer Gewichtsmatrix durch TT von höhergeordneten Zustandsinteraktionen. Ein Quantenbezug erklärt Herkunft und Einordnung; die hier recherchierten klassischen Ausführungen sind noch kein Nachweis eines Quantenvorteils.

**Übung:** Zeichne den vollständigen Informationsfluss eines Kandidaten. Entwirf eine Ablation ohne Tensoranteil.

## 2.7 Prognosegenauigkeit und Vergleich

**Kernquellen:** FPP3 [5.8](https://otexts.com/fpp3/accuracy.html) und [5.10](https://otexts.com/fpp3/tscv.html); [TFB](https://www.vldb.org/pvldb/vol17/p2363-hu.pdf) (`qiu2024`).

Definiere eine primäre, zur Zielgröße passende Fehlermetrik vor dem abschließenden Test. Ergänze beispielsweise MAE und RMSE; bei unterschiedlichen Skalen kommen MASE/RMSSE infrage, sofern deren Skalierung sinnvoll definiert ist. Aggregation über Horizonte und Reihen muss ausdrücklich festgelegt werden.

Trenne numerische Prognosefehler, Trefferquote einer Richtungsklassifikation und wirtschaftliche Ergebnisse. Modelle werden zeitlich validiert; zufällige ML-Kreuzvalidierung darf nicht unverändert auf zeitlich abhängige Prognosefenster übertragen werden.

**Übung:** Entwerfe eine Ergebnistabelle mit Genauigkeit zuerst und Ressourcen dahinter. Kennzeichne Training, Validierung, Test und verfügbare Vergangenheit für jeden Prognoseursprung.

## 2.8 Forschungsstand und Modellwahl

Die geprüften Kandidaten, Zahlen, Quellen und Einschränkungen stehen in [tensor-model-literature-review.md](tensor-model-literature-review.md). Beginne mit BHT-ARIMA und HOT-LSTM; prüfe ihre Eignung nach Sichtung der DATEV-Daten. Finanzmarkt- und Chaosmodelle sind weitere Kandidaten mit jeweils eigenem Anwendungsspektrum.

| Paper / geprüfte Version | Aufgabe / Daten | Tensoranteil | Vergleichsmodelle | Metrik / Horizont / Split | Genauigkeitsbefund | Code / Datenzugang | Eignung für DATEV-Aufgabe |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Für ausgewählte Arbeiten ausfüllen | | | | | | | |

**Auswahlkriterien in dieser Reihenfolge:** passende Zielgröße und verfügbare Eingaben, belastbare Genauigkeitsevidenz, starke Vergleichsmodelle, Reproduzierbarkeit und praktische Durchführbarkeit. Parameterzahl ist kein Ersatz für Genauigkeit.

## Vorgehen beim Lernen

1. Zeitreihenaufgabe verstehen und ein vorläufiges Datenprofil anlegen.
2. Einfache und etablierte Prognoseverfahren sowie Validierung erarbeiten.
3. Motivation in eigene Hypothesen übersetzen.
4. Tensoroperationen und TT/MPS an kleinen Beispielen nachvollziehen.
5. Einen Prognosekandidaten und seine konventionelle Vergleichsarchitektur vollständig verstehen.
6. Erst nach Datensichtung und Pilotexperimenten die Modellwahl und den Umfang der Vertiefungen festlegen.

Längere Herleitungen und Übungen können in den Lernnotizen oder im Anhang bleiben. Im Haupttext trägt jeder Abschnitt zum Verständnis einer Methode, einer Auswertung oder einer Einschränkung bei.
