# Verifizierung der generischen Tensorgrundlagen

Stand: **8. Oktober 2026**. Geprüfter Text: Abschnitte **2.4–2.6**, eingebunden
in [main.typ](../main.typ) und separat lesbar über [tensor-foundations.typ](../tensor-foundations.typ).

## Inhalt und Quellen

Der Grundlagenblock besteht aus drei ausformulierten englischen Abschnitten:

1. **Mathematical Foundations:** Tensoren und Indexnotation; Tensorprodukte,
   Umformen und Entfalten; Kontraktion; Rang, SVD und Approximation.
2. **General Principles of Tensor Networks:** Faktorisation; Bindungsdimension
   und Kapazität; CP, Tucker, TT/MPS, MPO und Bäume; Kontraktionsreihenfolge;
   Gauge-Freiheit und kanonische Formen.
3. **Tensor Networks for Machine Learning:** Feature Maps; Vorhersagefunktionen;
   Lernen der Kerne; tensorisierte Schichten und Hybride; Übergang zur
   Zeitreihenaufgabe und Einordnung des Quantenbezugs.

Definitionen und Einordnung wurden mit Originalarbeiten beziehungsweise den
wissenschaftlichen Überblicksarbeiten abgeglichen:

| Thema | Quellen im Text |
| --- | --- |
| Notation, Moden, CP und Tucker | Kolda und Bader, kolda2009 |
| Tensoroperationen und Rechenstruktur | Lee und Cichocki, lee2016; Bridgeman und Chubb, bridgeman2017 |
| Beste Matrixapproximation mit begrenztem Rang | Eckart und Young, eckart1936 |
| TT-Format, Speicherzählung und TT-SVD | Oseledets, oseledets2011 |
| Netzwerkfamilien und Schnittstruktur | Cichocki et al., cichocki2017; Orús, orus2014 |
| Gauge-Freiheit und kanonische MPS | Pérez-García et al., perez2007; Bridgeman und Chubb |
| Lernbare Produkt-Feature-Modelle | Stoudenmire und Schwab, stoudenmire2016 |
| Tensorisierte neuronale Gewichte | Novikov et al., novikov2015 |
| Konkrete Beispiele für Hybride | Yu et al., yu2019; Shi et al., shi2020 |
| Optimierer der gezeichneten Lernkurve | Kingma und Ba, kingma2015 |

Die Metaphern, Abbildungen und konkreten Lehrzahlen sind eigene Konstruktionen.
Die Quellen belegen die mathematischen Konzepte und Architekturen; sie sind nicht
die Quelle der gezeichneten Ledgerwerte, Muster oder Trainingsbeobachtungen.

## Numerische Prüfungen

Das [Verifizierungsskript](../scripts/verify-tensor-foundations.mjs) führt zwölf
Prüffälle aus. Die vollständigen Resultate stehen in
[verification.json](../figures/tensors/verification.json).

| Prüfbereich | Unabhängige Kontrolle | Ergebnis |
| --- | --- | --- |
| Ledger und Entfaltung | Alle zwölf Werte und Rückzuordnung des Spaltenindex | Bestanden; markierter Wert 11 |
| Äußeres Produkt | Handwerte und verschwindende 2 × 2-Minoren | Bestanden; Rang 1 |
| Kontraktion | Vorzeichenbeispiel und direkte Matrixmultiplikation | Bestanden; Summe 8 |
| SVD-Muster | Eigenwerte der Gram-Matrix durch Jacobi-Diagonalisierung | Bestanden; Singularwerte 9, 3, 1 |
| SVD-Trunkierung | Direkte Frobenius-Abstände der Rekonstruktionen | Bestanden; Fehler √10, 1, 0 |
| TT-Beispiel | Alle 64 Kontraktionen gegen die explizite Zwei-Term-Summe; Ränge beider Schnitte | Bestanden; Schnittränge 2 und 2 |
| Kontraktionsreihenfolge | Beide Produkte gerechnet und Multiplikationen gezählt | Bestanden; 4.800 versus 280, gleiche Ausgabe |
| Gauge und Basiswechsel | Originalprodukt gegen kompensiert transformierte Faktoren | Bestanden; Wert 11 bleibt erhalten |
| QR/Kanonisierung | QᵀQ sowie Rekonstruktion und Absorption in den Nachbarn | Bestanden; Orthogonalitätsfehler unter 10⁻¹⁰ |
| Interaktionsfunktion | Kontraktion der Produktfeatures und numerische Ableitung | Bestanden; Vorhersage 0,636 |
| Kerngradienten | Analytische Gradienten gegen zentrale finite Differenzen und dense Referenzauswertung | Bestanden; maximaler Gradientfehler unter 2 × 10⁻⁷ |
| Lernen und Grafikdaten | Tatsächlicher Trainingslauf; Manifest gegen die geprüften Zahlen | Bestanden; Trainings-MSE 0,364407 → 0,000290 |

Die zwölf automatischen Prüffälle fassen teilweise mehrere Tabellenzeilen
zusammen. Allgemeine Sätze werden dadurch nicht für beliebige Tensoren bewiesen;
die Tests prüfen die konkreten Rechnungen und Implementierungen der Lehrbeispiele.

## Fachliche Kontrollen

- Ordnung, Modengröße, CP-Rang, Tucker-Ränge und TT-Ränge sind getrennt definiert.
- Tensorprodukt erhält Indizes; Kontraktion summiert passende Indizes aus.
- Die Entfaltung hat eine ausdrücklich festgelegte Spaltenreihenfolge.
- Die Bond-Grenze wird aus einer Matrixfaktorisierung hergeleitet.
- Speicherzählungen beschreiben gespeicherte Einträge, keine unabhängigen
  Freiheitsgrade nach Berücksichtigung der Gauge-Freiheit.
- Die beste rangbeschränkte Matrixapproximation wird von einer sequentiellen
  Tensorapproximation und von prognostischer Generalisierung unterschieden.
- Die Lernkurve hat 16 gespeicherte Kernparameter gegenüber acht dichten
  Tensorwerten; sie demonstriert Lernen und behauptet keine Kompression.
- Die gezeichnete Referenzkurve ist nur im synthetischen Beispiel bekannt.
- Keine Lehrzahl wird als Messergebnis auf DATEV-Daten ausgegeben.

## Grafiken und Dokument

Alle elf SVG-Dateien wurden als XML geprüft und mit Typst gerendert.
Die Grafiken wurden zunächst gemeinsam und danach auf ihren gesetzten Seiten
visuell geprüft: Beschriftung, Vorzeichen, Indexzuordnung, gleiche Skalen,
Abstände, Lesbarkeit und Verbindung zum erklärenden Text.

Die Kurvengrafik beruht auf einem tatsächlichen deterministischen Training der
TT-Kerne. Das SVD-Bild zeigt berechnete Muster auf gemeinsamer Farbskala. Die
Kostengrafik benennt skalare Multiplikationen, keine gemessenen Laufzeiten.

Beide Dokumente werden mit dem lokalen Typst-Compiler und den Projektschriften
erzeugt. Bibliographieschlüssel, Querverweise und Abbildungsnummerierung sind
geprüft. Die vollständige Arbeit enthält die drei Abschnitte an Position 2.4–2.6;
die übrigen projektspezifischen Kapitel behalten ihre Schreibaufträge.

## Reproduktion

Vom Projektverzeichnis aus:

    node scripts/build-tensor-figures.mjs
    node scripts/verify-tensor-foundations.mjs
    typst compile --font-path fonts main.typ thesis.pdf
    typst compile --font-path fonts tensor-foundations.typ tensor-foundations.pdf

Das numerische Skript benötigt keine zusätzlichen Node-Pakete. Die
verwendeten Originalquellen sind in [references.bib](../references.bib) hinterlegt.
