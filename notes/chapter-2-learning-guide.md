# Kapitel 2: Lern- und Schreibplan

Diese Gliederung ist bewusst breit angelegt. Du kannst dir zunächst die Grundlagen erarbeiten und anschließend entscheiden, wie viel davon die fertige Arbeit benötigt. Die englischen Überschriften und Schreibaufträge stehen bereits in `main.typ`; diese Notizen begleiten das Lernen auf Deutsch.

Als erste Planung würde ich für Kapitel 2 etwa **25–30 Seiten** innerhalb der insgesamt 80–100 Seiten vorsehen. Die Verteilung ist ein Vorschlag und wird nach Datensatz- und Modellauswahl angepasst.

| Abschnitt | Inhalte und Lernziel | Grober Umfang |
| --- | --- | --- |
| 2.1 Mathematical Foundations | Lineare Algebra, Rang, SVD, Approximation, Wahrscheinlichkeit und Statistik | 2–3 Seiten |
| 2.2 Tensors and Multilinear Operations | Tensorbegriffe, Indizes, Tensorprodukt, Entfaltung, Kontraktion, CP/Tucker | 3–4 Seiten |
| 2.3 Time-Series Forecasting | Prognoseaufgabe, zeitliche Struktur, Fensterbildung und Vorverarbeitung | 3–4 Seiten |
| 2.4 Machine Learning for Forecasting | Lernziele, Optimierung, Generalisierung, Modellfamilien und Vortraining | 3–4 Seiten |
| 2.5 Tensor Networks | Kerne, Bindungsdimension, Topologien, Approximation und Kontraktionskosten | 4–5 Seiten |
| 2.6 Tensor-Network-Based Machine Learning | Feature Maps, tensorisierte Schichten, hybride Modelle und Training | 3–4 Seiten |
| 2.7 Evaluation and Computational Efficiency | Prognosefehler, Ressourcenbedarf und reproduzierbarer Vergleich | 2–3 Seiten |
| 2.8 Related Work and State of the Art | Aktuelle Forschung beider Modellklassen und Auswahlkriterien | 3–4 Seiten |

## 2.1 Mathematische Grundlagen

Erarbeite dir Vektoren, Matrizen, Skalarprodukte, Normen, Rang und Singulärwertzerlegung. Ergänze Erwartungswert, Varianz und Kovarianz, soweit du sie für Zeitreihen und Lernverfahren benötigst.

**Leitfragen:** Was bedeutet eine Approximation mit niedrigem Rang? Welche Information geht beim Weglassen von Singulärwerten verloren? Wie werden Vorhersagen und Fehler mathematisch beschrieben?

**Kleine Übung:** Zerlege eine kleine Matrix mit der SVD, rekonstruiere sie mit reduziertem Rang und vergleiche Fehler und Parameterzahl. Dieses Beispiel lässt sich später zur Tensorzerlegung weiterführen.

Einstieg: [Goodfellow, Bengio und Courville: Deep Learning](https://www.deeplearningbook.org/), insbesondere die Kapitel zu linearer Algebra, Wahrscheinlichkeit und ML-Grundlagen; anschließend [Oseledets: Tensor-Train Decomposition](https://epubs.siam.org/doi/abs/10.1137/090752286).

## 2.2 Tensoren und multilineare Operationen

Ein eigener Tensorabschnitt ist als Grundlage sinnvoll. Behandle zunächst Ordnung, Form, Moden und Indizes. Danach folgen Tensorprodukt, Umformung, Entfaltung und Kontraktion. CP und Tucker geben einen ersten Überblick über Zerlegungen.

**Leitfragen:** Wie unterscheidet sich die Ordnung eines Tensors von seinem Rang? Welche Bedeutung haben die Achsen eines Zeitreihen-Batches? Was passiert bei der Kontraktion eines gemeinsamen Index?

**Kleine Übung:** Beschreibe einen Eingabetensor mit den Achsen Beispiele × Zeitschritte × Variablen. Schreibe eine Matrixmultiplikation als Kontraktion und zeichne das zugehörige Tensordiagramm. Ein mehrdimensionaler Eingabearray allein definiert noch kein Tensor-Netzwerk-Modell.

Einstieg: [Kolda und Bader: Tensor Decompositions and Applications](https://www.kolda.net/publication/koba09/). CP-Rang, multilinearer Rang und TT-Ränge sollten später sauber unterschieden werden.

## 2.3 Zeitreihen und Prognoseaufgaben

Definiere univariate und multivariate Zeitreihen, Eingabefenster, Prognosehorizont, Zielvariablen und zusätzliche Einflussgrößen. Erarbeite Trend, Saisonalität, Rauschen, Autokorrelation, Stationarität und Veränderungen der Datenverteilung.

**Leitfragen:** Welche Informationen stehen zum Prognosezeitpunkt tatsächlich zur Verfügung? Werden mehrere zukünftige Werte direkt oder schrittweise vorhergesagt? Welche zeitlichen und variablenübergreifenden Abhängigkeiten muss ein Modell erfassen?

**Kleine Übung:** Formuliere eine Aufgabe mit beispielsweise 48 beobachteten Zeitschritten, drei Variablen und zwölf zukünftigen Zielwerten. Gib Ein- und Ausgabeform an und erläutere, wie Trainingsbeispiele entstehen. Kennzeichne zusätzliche Größen, deren zukünftige Werte wirklich vorab bekannt sind.

Einstieg: [Hyndman und Athanasopoulos: Forecasting — Principles and Practice](https://otexts.com/fpp3/), besonders Zeitreihenmuster, Prognosegrundlagen und Vorverarbeitung.

## 2.4 Machine Learning für Zeitreihen

Behandle Regression, Verlustfunktionen, Gradientenverfahren, Regularisierung, Überanpassung und Validierung. Erarbeite die Grundideen linearer oder MLP-basierter Modelle, rekurrenter Netze, zeitlicher Faltungen und Attention. Bei Transformern sind Patches und der Umgang mit mehreren Variablen interessant. Ergänze Vortraining, Zero-shot-Prognosen und Fine-Tuning als mögliche weitere Modellklasse.

**Leitfragen:** Woher erhält eine Architektur ihre Information über die zeitliche Reihenfolge? Wie verarbeitet sie Beziehungen zwischen Variablen? Welche zusätzlichen Daten nutzt ein vortrainiertes Modell?

**Kleine Übung:** Zeichne den Informationsfluss für zwei Modellfamilien. Erkläre in eigenen Worten, wie dieselbe Prognoseaufgabe jeweils umgesetzt werden kann.

Einstieg: [Deep Learning](https://www.deeplearningbook.org/) und [Vaswani et al.: Attention Is All You Need](https://arxiv.org/abs/1706.03762). [PatchTST](https://arxiv.org/abs/2211.14730) illustriert zeitliche Patches; [Chronos-2](https://arxiv.org/abs/2510.15821) ist ein Lesebeispiel für einen vortrainierten Forecaster mit multivariaten Eingaben und Kovariaten. Die konkrete Konkurrenz wird später aus der aktuellen Literatur gewählt.

## 2.5 Tensor-Netzwerke

Erarbeite Kerntensoren, offene und kontrahierte Indizes, Bindungsdimensionen und Netzwerktopologien. MPS beziehungsweise TT eignen sich als erstes anschauliches Beispiel einer Kette. Ergänze einen Überblick über MPO und TTN. Vertiefe anschließend die für eure ausgewählten Modelle benötigten Algorithmen und Topologien.

**Leitfragen:** Wie ersetzt ein Netzwerk einen großen dichten Tensor? Welche Rolle spielt die Bindungsdimension? Wie beeinflussen Rangtrunkierung und Kontraktionsreihenfolge die Genauigkeit und den Ressourcenbedarf?

**Kleine Übung:** Zeichne eine Kette aus drei Kerntensoren, beschrifte alle Indizes und zähle ihre Parameter. Vergleiche mit dem vollständig rekonstruierten Tensor. Untersuche, wie sich die Zahl bei größeren inneren Rängen verändert.

Einstieg: [Bridgeman und Chubb: Hand-waving and Interpretive Dance](https://arxiv.org/abs/1603.03039) und [Oseledets: Tensor-Train Decomposition](https://epubs.siam.org/doi/abs/10.1137/090752286). Die Vorlesungsnotizen von Bridgeman und Chubb bieten auch Übungsaufgaben mit Lösungen.

## 2.6 Tensor-Netzwerke im maschinellen Lernen

Verbinde die bisherigen Begriffe mit einer lernbaren Vorhersagefunktion: Feature Maps, tensorisierte Gewichte, hybride Architekturen und Optimierung der Kerntensoren. Unterscheide dabei das Komprimieren bereits trainierter Gewichte vom direkten Training einer faktorisierten Parametrisierung.

**Leitfragen:** An welcher Stelle des Modells wird ein Tensor-Netzwerk eingesetzt? Was sind seine trainierbaren Parameter? Welche Annahmen über die Daten bringt die gewählte Darstellung mit?

**Kleine Übung:** Skizziere den Weg von einem Zeitfenster über seine Feature-Darstellung und eine Tensorkontraktion bis zum Prognosewert. Erläutere, welche Dimensionen und Parameter bei jedem Schritt auftreten.

Einstieg: [Stoudenmire und Schwab: Supervised Learning with Tensor Networks](https://papers.nips.cc/paper/6211-supervised-learning-with-tensor-networks.pdf) für Feature Maps und lernbare Tensor-Netzwerke; [Novikov et al.: Tensorizing Neural Networks](https://arxiv.org/abs/1509.06569) für faktorisierte neuronale Schichten. Das erste Beispiel behandelt Klassifikation; der Übergang zur Zeitreihenregression muss eigens erläutert werden.

Ein kurzer Quantenbezug kann die Herkunft der Begriffe erklären und eure Rolle als klassische beziehungsweise quantum-inspired Vergleichsbasis einordnen. Vertiefungen zu Schmidt-Zerlegung, Verschränkung oder Born-Modellen hängen vom tatsächlich eingesetzten Ansatz ab.

## 2.7 Bewertung und Effizienz

Definiere geeignete Prognosefehler und deren Aggregation über Variablen und Horizonte. Behandle Parameterzahl, Trainingszeit, Inferenzzeit, Spitzenspeicher und Rechenaufwand. Ergänze zeitlich geordnete Datenteilungen, Rolling-origin-Evaluation und Reproduzierbarkeit.

**Leitfragen:** Auf welcher Skala werden Fehler gemessen? Wie verändert sich die Bewertung mit dem Prognosehorizont? Wann ist ein etwas ungenaueres Modell wegen seines Ressourcenbedarfs trotzdem interessant? Welche Kosten eines vortrainierten Modells sind in eurem Vergleich sichtbar?

**Kleine Übung:** Entwerfe eine Ergebnistabelle mit Fehler und Ressourcenbedarf für zwei fiktive Modelle. Erkläre den Genauigkeits-Effizienz-Abwägungsfall. Skizziere anschließend einen zeitlichen Trainings-, Validierungs- und Testschnitt, bei dem die Vorverarbeitung nur aus den Trainingsdaten gelernt wird.

Einstieg: die Abschnitte zu [Prognosefehlern](https://otexts.com/fpp3/accuracy.html) und [Zeitreihen-Cross-Validation](https://otexts.com/fpp3/tscv.html) bei Hyndman und Athanasopoulos. Die konkreten Messverfahren, Datenschnitte und Tuningbudgets werden in Kapitel 3 festgelegt.

## 2.8 Forschungsstand und Modellauswahl

Hier untersucht ihr aktuelle Tensor-Netzwerk-Verfahren für eure Art der Zeitreihen und aktuelle starke Vergleichsverfahren. Die Grundlagenquellen aus den vorherigen Abschnitten helfen beim Verständnis; für die Auswahl werden zusätzliche aktuelle Originalarbeiten, passende Benchmark-Ergebnisse und Implementierungen benötigt. Haltet den Zeitpunkt und Umfang der Recherche fest.

Als erster spezifischer Suchanker bietet sich [Tensor Network Framework for Forecasting Nonlinear and Chaotic Dynamics](https://arxiv.org/abs/2511.09233) an, falls eure Daten nichtlineare oder chaotische Dynamik zeigen. Die Arbeit verwendet Lorenz- und Rössler-Systeme; prüft deshalb, wie weit ihre Ergebnisse auf eure Forschungsdaten übertragbar sind. Prüft bei Preprints außerdem den aktuellen Publikationsstatus. Dieser Hinweis legt noch kein Modell fest.

Für jedes relevante Paper könnt ihr diese Tabelle ausfüllen:

| Paper / Jahr / Status | Modell und Darstellung | Daten / Variablen | Fenster / Horizont / verfügbare Eingaben | Vergleich und Prognosefehler | Ressourcenbedarf | Code und Reproduzierbarkeit | Eignung für unsere Daten |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Noch zu recherchieren | | | | | | | |

**Ergebnis dieses Abschnitts:** begründete Auswahlkriterien und eine Forschungslücke. Die endgültige Auswahl der Modelle und die Versuchsanordnung folgen in Kapitel 3. State of the Art wird dabei anhand relevanter Evidenz für die Aufgabe beurteilt; das Erscheinungsjahr allein reicht dafür nicht.

## Vorgehen beim Erarbeiten und späteren Kürzen

1. Beginne mit 2.1 und 2.2. Halte Definitionen, Notation und die kleinen Beispiele in eigenen Worten fest.
2. Erarbeite 2.3 und 2.4 parallel zur ersten Sichtung der Datensätze.
3. Vertiefe 2.5 und 2.6. Versuche mindestens eine kleine Kontraktion und eine faktorisierte Vorhersagefunktion vollständig nachzuvollziehen.
4. Lege mit 2.7 fest, was ein aussagekräftiger Vergleich erklären muss, und sammle in 2.8 die aktuelle Modellliteratur.
5. Kürze erst nach der Modellauswahl. Entscheidend für den Haupttext ist, ob ein Abschnitt später das Verständnis einer Methode, einer Auswertung oder einer Einschränkung trägt.

**Voraussichtlich zentral:** Forecasting-Aufgabe, Tensornotation und Kontraktion, Rang beziehungsweise Bindungsdimension, die verwendeten ML- und TN-Mechanismen sowie Fehler- und Effizienzbewertung.

**Je nach Auswahl vertiefen oder kürzen:** CP/Tucker, einzelne Topologien, kanonische Formen, probabilistische Modelle, Foundation Models, chaotische Dynamik und Quantenformalismus. Ausführliche Übungen und Herleitungen können als Lernnotizen erhalten bleiben oder in den Anhang wandern.
