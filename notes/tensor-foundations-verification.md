# Verifizierung der generischen Tensorgrundlagen

Stand: **8. Oktober 2026**. Geprüfter Text: Abschnitte **2.4–2.6**, eingebunden
in [main.typ](../main.typ) und separat lesbar über [tensor-foundations.typ](../tensor-foundations.typ).

**Nachtrag 19. Oktober 2026:** Abschnitt 2.4.1 erklärt Ordnung, Slice und Fiber
an denselben Messwerten. Die zusätzliche Grafik `01b-order-slice-fiber.svg`
zeigt die Auswahl von Ort 2 und anschließend der Temperaturspalte (7, 9, 11).
Der Grafikbestand umfasst damit zwölf SVGs; die numerischen Lehrwerte bleiben
gleich. Der Tensor selbst hat weiter Ordnung drei, die ausgewählten Teile
haben Ordnung zwei beziehungsweise eins.

**Überarbeitung von 2.4.2 am 19. Oktober 2026:** Eine kompakte Grafik zeigt
die Grundreihe (2, 4, 6, 8) und ihre Multiplikatoren (1, 2, 3): sieben
Faktorwerte ergeben zwölf Gewichte. Jedes Kästchen trägt ein kleines
Gewichtssymbol für einen gelernten Parameter; die Grafik enthält keine
Rechenwege. Intern prüft das Skript zusätzlich die Übereinstimmung von
5 × 12 und 5 × (2 × 6) sowie alle 2 × 2-Minoren der Gewichtstabelle.

Die zusätzliche Mini-Grafik `03b-rank-comparison.svg` vergleicht Rang 1
mit Rang 2. In der zweiten Matrix wird nur der Eintrag (2,4) von 16 auf
17 geändert. Ein nicht verschwindender 2 × 2-Minor und die unveränderte
Beziehung Zeile 3 = 3 × Zeile 1 sichern Rang genau 2. Die Sammlung enthält
damit dreizehn Grafiken.

**Getrennte Themen in 2.4:** Tensorprodukte und gemeinsame Gewichte stehen
in 2.4.2. Reshaping und Matricization bilden nun 2.4.3 mit eigener Motivation:
Eine Zeile pro Ort bereitet beide Orte gemeinsam für Matrixverfahren vor;
das Umordnen selbst komprimiert keine Daten. Die kompakte Entfaltungsgrafik (920 × 170) zeigt zwei
Tabellen neben einer Matrix und passt mit dem Text auf dieselbe Seite.
Rang/SVD folgt direkt in 2.4.4: Wie finden wir die kleinen Faktoren?
Kontraktion in 2.4.5 beantwortet danach, wie wir direkt mit ihnen rechnen.
Querverweise verwenden weiterhin die Abschnittslabels.

**Zusammenhängendes Rechenbeispiel:** 2.4.5 verwendet wieder die vier
Basisgewichte (2, 4, 6, 8) und die drei Multiplikatoren (1, 2, 3).
Für den Eingang (1, 2, 3, 4) ergibt die gemeinsame gewichtete Summe 60;
die Ausgaben sind (60, 120, 180). Das Prüffall-Skript vergleicht diese
Faktorrechnung mit der vollständigen Matrixmultiplikation, zusätzlich für
drei Eingänge mit Nullen, negativen und nicht ganzzahligen Werten.
Die Diagrammnotation steht nun beim Einstieg in 2.5.1, unmittelbar vor
dem ersten verbundenen Faktornetzwerk.

**SVD-Einstieg:** Die Musterfindung wird als beste Annäherung durch eine
Basiszeile und Zeilenmultiplikatoren erklärt, gefolgt von der Annäherung
des verbleibenden Rests. Dies beschreibt die SVD mathematisch, ohne einen
bestimmten numerischen Lösungsalgorithmus vorzuschreiben. Die Grafik
zeigt nur noch vier kompakte Matrizen (920 × 215); Stärkebalken und
zusätzliche Beschriftungen entfallen. Zahlen und Farbskala bleiben gleich.

**Nachtrag 17. Oktober 2026:** Der Text der Abschnitte 2.4–2.6 wurde didaktisch gekürzt und beginnt jeweils mit einer kurzen Überleitung. Einige Rechenbeispiele stehen seitdem nicht mehr im Fließtext: die TT-Kerne U, V, W mit T(4,2,3) = 3, das Gauge-Zahlenbeispiel, die Vorhersage 0,636 und die Kerngradienten. Sie bleiben in den Skripten und Abbildungen enthalten und werden weiterhin geprüft. Alle Zahlen, die im Text verblieben sind, stimmen mit den Prüffällen überein.

## Inhalt und Quellen

Der Grundlagenblock besteht aus drei ausformulierten englischen Abschnitten:

1. **Mathematical Foundations:** Tensoren und Indexnotation; Tensorprodukte,
   Umformen und Entfalten; Rang, SVD und Approximation; Kontraktion.
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
| Kontraktion | Faktorrechnung gegen vollständige Matrixmultiplikation; zusätzliche Eingänge und Vorzeichenbeispiel | Bestanden; gemeinsame Summe 60, Ausgaben (60, 120, 180) |
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
