# Tensor Networks for Machine Learning

Wir untersuchen, ob Tensor-Netzwerk-basierte ML-Modelle oder Hybridmodelle die Zeitreihen der Forschungsgruppe unseres Professors genauer vorhersagen können als starke etablierte Prognoseverfahren. Die Forschungsdaten stammen laut Projektangabe von **DATEV**; die konkreten Variablen, Zielgrößen, Zeitauflösung und Prognosehorizonte sind noch offen. Der Vergleich soll eine reproduzierbare klassische beziehungsweise quantum-inspired Grundlage für die Quantenalgorithmen der Forschungsgruppe liefern.

Der geplante Umfang der Studienarbeit beträgt **80–100 Seiten**.

Dazu analysieren wir die Datensätze und recherchieren den aktuellen Forschungsstand für beide Modellklassen. Die Auswahl der Tensor-Netzwerk-Ansätze und der Vergleichsmodelle richtet sich nach dem State of the Art und ihrer Eignung für die konkreten Daten. Wir implementieren bzw. adaptieren die ausgewählten Verfahren und evaluieren sie unter vergleichbaren Bedingungen.

**Primär bewertet wird die Vorhersagegenauigkeit auf ungesehenen Daten.** Parameterzahl, Trainings- und Inferenzzeit sowie Speicher- und Rechenbedarf sind ergänzende Kriterien. Modellkonfigurationen werden anhand einer zur Aufgabe passenden Validierungsmetrik ausgewählt; die Testdaten bleiben für die abschließende Auswertung reserviert. Ziel ist es, Nutzen, Grenzen und geeignete Einsatzbedingungen der Tensor-Modelle zu bestimmen und mögliche Weiterentwicklungen abzuleiten.

Die Grundlagen in `main.typ` folgen der Reihenfolge **Zeitreihen → etablierte Prognoseverfahren → Motivation für Tensoransätze → Tensoren → Tensor-Netzwerke → Tensor- und Hybridmodelle → Genauigkeitsbewertung → Forschungsstand**.

- [Lern- und Quellenplan für alle Kapitel](notes/chapter-2-learning-guide.md): kuratierte Bücher, genaue Kapitel/Abschnitte, Originalpapers und Übungen.
- [Geprüfte Tensor- und Hybridmodelle](notes/tensor-model-literature-review.md): konkrete Genauigkeitsbefunde, Vergleichsmodelle, Anwendungsgrenzen und Originalcode; Recherchestand 7. Oktober 2026.
- `references.bib`: Literaturangaben zu den Quellen im Schreibgerüst.

**Ausformulierte Grundlagen, Stand 8. Oktober 2026:** Die Abschnitte 2.4–2.6 erklären die gemeinsame Mathematik der Tensor-Netzwerke in verständlichem Englisch. Elf eigene Vektorgrafiken verbinden Metaphern mit nachgerechneten Beispielen: ein Ledger, ein Webstuhl, passende Beitragskanäle, Rekonstruktionsschichten, Koordinatenwechsel und eine lernende Kurve. Der Text liegt in chapters/ und ist in die Arbeit eingebunden.

[tensor-foundations.typ](tensor-foundations.typ) erzeugt eine separate Lesefassung dieser Abschnitte. [figures/tensors/README.md](figures/tensors/README.md) beschreibt die Grafiken und ihre Erzeugung. Die fachlichen und numerischen Prüfungen sind in [notes/tensor-foundations-verification.md](notes/tensor-foundations-verification.md) dokumentiert.

Die Grafiken und Prüfungen benötigen Node.js ohne zusätzliche Pakete:

    node scripts/build-tensor-figures.mjs
    node scripts/verify-tensor-foundations.mjs

Mit Typst lassen sich die vollständige Arbeit und der separate Grundlagenblock bauen:

    typst compile --font-path fonts main.typ thesis.pdf
    typst compile --font-path fonts tensor-foundations.typ tensor-foundations.pdf
