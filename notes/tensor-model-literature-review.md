# Tensor- und Hybridmodelle: geprüfte Prognoseevidenz

Recherchestand: **7. Oktober 2026**. Schwerpunkt: **Vorhersagegenauigkeit**, danach Parameterzahl und Ressourcenbedarf. Die Angaben unten stammen aus den verlinkten Originalarbeiten; sie wurden nicht durch eigene Experimente reproduziert.

Die Forschungsdaten stammen laut Projektangabe von **DATEV**. Ihre Zielgrößen, Frequenz, Dimension und Länge sind noch offen. DATEV beschreibt öffentlich die Weitergabe von Buchhaltungsdaten an nachgelagerte Analysesysteme ([DATEV-Datenservice](https://www.datev.de/web/de/shop/produkt-details/datev-datenservice-export-rechnungswesen-92913)). Das macht betriebliche Zeitreihen zu einem möglichen Anwendungskontext, identifiziert aber nicht den Forschungsdatensatz. Es bestätigt insbesondere keine Börsen- oder Währungsdaten.

## Antwort auf die Modellfrage

**Ja: Es gibt Tensor- und Hybridverfahren, die in bestimmten Experimenten genauer als die dort verglichenen etablierten Verfahren waren.** Die deutlichsten hier geprüften Ausgangspunkte sind BHT-ARIMA und HOT-LSTM. Ein Finanz-TT-RNN liefert zusätzliche Evidenz für Richtungsklassifikation. Daraus folgt noch keine allgemeine Überlegenheit auf DATEV-Daten oder gegenüber der aktuellen stärksten Modellkonkurrenz.

| Kandidat | Tensoranteil | Aufgabe und Genauigkeitsevidenz | Einschränkung für unsere Auswahl |
| --- | --- | --- | --- |
| **BHT-ARIMA** (Shi et al., AAAI 2020) | Delay-Embedding, Tucker-Zerlegung, ARIMA auf Kerntensoren | Tabelle 2: PC-Sales-NRMSE **0,490**, gegenüber **0,524** für GRU und **0,618** für XGBoost; etwa **6,5 %** weniger Fehler als GRU | Besonders interessant bei mehreren verwandten kurzen Reihen. Der Vorteil gilt nicht für alle Horizonte: Auf Traffic80 ist GRU nach 15 Schritten etwas genauer. |
| **HOT-LSTM / HOT-RNN** (Yu et al., geprüfte arXiv-v3, 2019) | Höhergeordnete Zustandsinteraktionen mit Tensor-Train-Faktorisierung | Abbildung 6: geringere RMSE auf Genz-, Verkehrs- und Klimareihen gegenüber LSTM/MLSTM; der Abstract berichtet 5–12 % Verbesserungen | Gute Hybrididee für numerische Prognosen; damalige Vergleichsmodelle, keine Prüfung gegen heutige Patch-/Foundation-Modelle. |
| **Finanz-TT-RNN** (Xu et al., geprüfte arXiv-v1, 2021) | Tensorisierte Eingang-Gewichtsmatrix eines RNN | Tabelle III: nächste JPYUSD-Kursrichtung, **52,04 %** Trefferquote gegenüber **36,05 %** für RNN, **51,06 %** für TTNN und **51,67 %** für STM | Dreiklassen-Klassifikation, keine RMSE-Prognose von Geldbeträgen. Ein Währungspaar und ein zurückgehaltener Testzeitraum. |

Quellen zu den Tabellenangaben: [BHT-ARIMA, Tabellen 1–2 und Langfristvergleich](https://ojs.aaai.org/index.php/AAAI/article/download/6032/5888), [HOT-RNN, Abschnitt 6 und Abbildung 6](https://arxiv.org/pdf/1711.00073v3), [Finanz-TT-RNN, Abschnitt III und Tabelle III](https://arxiv.org/pdf/2105.04983).

Die **6,5 %** sind eine relative Fehlerreduktion: (0,524 − 0,490) / 0,524. Die **52,04 %** sind eine Klassifikationstrefferquote. Diese Zahlen dürfen nicht als dieselbe Art von Genauigkeitsgewinn zusammengeführt werden.

## Genauere Einordnung und Reproduzierbarkeit

### BHT-ARIMA

**Literaturschlüssel:** `shi2020`. **Lesestelle:** Modellbeschreibung und Experimente, besonders Tabellen 1–2 und der Langfristvergleich.

Das Verfahren ist ein Tensorzerlegungs-Hybrid mit Tucker-Struktur; es ist kein TT-/MPS-Modell. Bei mehreren verwandten betrieblichen Reihen wäre es ein besonders prüfenswerter Kandidat. Sein Nutzen hängt davon ab, ob eine gemeinsame niedrigdimensionale Struktur zu den tatsächlichen Daten passt.

**Originalcode:** [yokotatsuya/BHT-ARIMA](https://github.com/yokotatsuya/BHT-ARIMA). Die bereitgestellte Implementierung verwendet MATLAB. Vor Auswahl müssen Eingabeform, erforderliche Reihenlänge und die Umsetzung derselben zeitlichen Validierung wie bei den Konkurrenten geprüft werden.

### HOT-LSTM

**Literaturschlüssel:** `yu2019`. **Geprüfte Fassung:** arXiv:1711.00073v3 vom 24. August 2019; frühere Fassungen heißen *Tensor-Train RNNs*. Ein endgültiger JMLR-Publikationsnachweis wurde hier nicht festgestellt; die Bibliographie zitiert die überprüfbare arXiv-Fassung.

Der Ansatz verändert die Zustandsübergänge eines rekurrenten Modells. Er unterscheidet sich damit vom unten genannten Finanz-TT-RNN, das Eingangsgewichte faktorisiert.

**Originalcode:** [yuqirose/tensor_train_RNN](https://github.com/yuqirose/tensor_train_RNN), TensorFlow-Code. Eine Übernahme in die spätere Experimentumgebung muss fachlich geprüft werden. Vergleich mit gewöhnlichem LSTM plus stärkeren taskgerechten Konkurrenten vorsehen.

### Finanz-TT-RNN

**Literaturschlüssel:** `xu2021`. **Lesestelle:** Abschnitt III, besonders die Zieldefinition und Tabelle III.

Eingänge umfassen mehrere Finanzsignale und abgeleitete Merkmale. Die Ausgabe unterscheidet Kursanstieg, Kursrückgang und nahezu unveränderten Kurs. Die Autoren verwenden die ersten 90 % des Zeitraums zum Training und die letzten 10 % zum Testen.

**Reproduzierbarkeit:** Im geprüften Paper wurde kein Code-Repository gefunden; die Daten stammen von Bloomberg. Vor einer Übernahme sind Datenzugang, Klassenverteilung, naive Klassenreferenz und ein unabhängiges zeitliches Tuningprotokoll zu klären. Bei DATEV-Betragsprognosen wäre eine eigene Regressionserweiterung nötig.

## Weitere relevante Kandidaten und Gegenbefunde

### LSTM-MERA: Mehr Genauigkeit bei chaotischen Ein-Schritt-Prognosen

[Meng und Yang, Entropy 2021](https://www.mdpi.com/1099-4300/23/11/1491) (`meng2021`) kombinieren LSTM mit MPS beziehungsweise MERA. Abschnitt 4 und Abbildung 3 vergleichen Ein-Schritt-RMSE auf chaotischen Systemen mit gewöhnlichen, breiteren und tieferen LSTMs bei ähnlicher Parameterzahl.

Der Befund unterstützt die Untersuchung eines Architekturbeitrags. Die Autoren begrenzen den Vorteil in ihrer Diskussion ausdrücklich auf kurzfristige Nichtlinearität. **Einordnung:** optional bei einer passenden dynamischen Datenstruktur, keine belegte Übertragbarkeit auf die DATEV-Reihen. Die beschriebenen Experimente verwenden Mathematica 12.0/MXNet.

### MPO/Volterra: Aktuelle Fassung zeigt vergleichbare Genauigkeit

[Martínez-Peña und Orús, arXiv:2505.17740v2](https://arxiv.org/html/2505.17740v2) (`martinez2026`) untersuchen 70 chaotische Prognoseaufgaben gegenüber Echo State Networks. Im **Results**-Abschnitt der am **16. Juni 2026** überarbeiteten Fassung sind die optimierten Medianwerte ähnlich; Tensor-Modelle haben teilweise geringere Streuung.

**Einordnung:** nützlicher reiner Tensoransatz, aber kein belastbarer pauschaler Genauigkeitssieg. Ältere Abstract-Formulierungen fallen stärker aus als dieser konkrete Befund. **Code:** [RMPhys/tnrc_paper](https://github.com/RMPhys/tnrc_paper), Julia. Für den jetzigen Genauigkeitsschwerpunkt nachrangig, sofern die DATEV-Aufgabe keinen passenden Dynamikkontext bietet.

### Hierarchisches TNM: Guter Aufbau, noch schwache Vergleichsevidenz

[You, Kong und Ye, arXiv:2511.09233](https://arxiv.org/html/2511.09233) (`you2025`) untersuchen Lorenz- und Rössler-Dynamik. Der Hauptvergleich betrifft homogene und inhomogene Parametrisierung des eigenen Tensor-Modells. Damit lässt sich die Modellstruktur studieren; ein systematischer Sieg über starke heutige Forecasting-Verfahren ist damit nicht nachgewiesen. Im geprüften Text wurde kein Code-Repository gefunden.

### Conv-TT-LSTM: Starker Hybrid für räumliche Folgen

[Su et al., NeurIPS 2020](https://arxiv.org/pdf/2002.09131) (`su2020`) kombinieren zeitliche Faltungen, LSTM und Tensor-Train-Struktur. Abschnitt 5 und Tabelle 4 liefern Video-Prognosevergleiche gegen ConvLSTM, PredRNN++ und E3D-LSTM mit bildbezogenen Metriken.

**Einordnung:** vertiefen, wenn die tatsächlichen Daten räumliche oder bildartige Struktur haben. Ein Ergebnis auf Moving-MNIST oder KTH ist kein direkter Genauigkeitsnachweis für betriebliche Beträge.

### Finanzstudie mit Quantum Neural Network und Tensor Network

[Kobayashi et al., Quantum Machine Intelligence 2023](https://link.springer.com/article/10.1007/s42484-023-00136-x) (`kobayashi2023`) vergleichen lineare Regression, kleine neuronale Netze, ein simuliertes Quantenschaltkreis-Modell und ein Tensor-Netzwerk. Abschnitt 3.4 und Tabelle 2 berichten bessere Portfolio-Überrendite und Information Ratio für das Tensor-Modell.

**Einordnung:** passend zum Quantenbezug, aber cross-sektionale Aktienrenditeprognose mit Portfolioauswertung. Das ersetzt keinen Nachweis geringerer Zeitreihen-RMSE. Die untersuchten Daten sind laut Artikel aus Lizenzgründen nicht öffentlich verfügbar.

### NASDAQ-Tensorregression: Hilfreiches Beispiel ohne universellen Sieg

[da Costa et al., arXiv:2101.09184v3, 2021](https://arxiv.org/pdf/2101.09184v3) (`dacosta2021`) vergleichen TT-Regression und MLPs. Abschnitt 6.4, Abbildungen 15–16 und Anhang A berichten NASDAQ-Prognosen. In der geprüften Fassung ist TT nicht durchgehend genauer: Bei einem Tagesprognosevergleich beträgt die Test-MSE 0,0115 für TT gegenüber 0,0109 für ein Tanh-MLP.

**Einordnung:** gut zum Lernen von Feature Maps und alternierender Optimierung. Die Zahlen beziehen sich ausdrücklich auf diese Preprint-Fassung, nicht auf eine ungeprüfte spätere Zeitschriftenfassung.

## Abgrenzung bei der Suche

- [FATE, geprüfte arXiv-v3 vom Juni 2026](https://arxiv.org/html/2408.11336v3) verarbeitet mehrdimensionale Eingaben mit tensorialer Modulation. Aus dem Begriff „tensorized“ allein folgt keine TT-/MPS-Faktorisierung. Das Paper wurde deshalb nicht als Beleg für den gesuchten TT-/MPS-Modellvorteil ausgewählt.
- [MPSTime](https://arxiv.org/abs/2412.15826) behandelt vor allem Klassifikation und Imputation. Diese Zeitreihenaufgaben sind relevant für den allgemeinen Tensor-Kontext, liefern hier aber keinen direkten Zukunftsprognosevergleich.
- Eine kleinere Parameterzahl oder schnelleres Training wurde bei der Auswahl nicht als Beleg für höhere Genauigkeit gewertet.

## Vorläufige Empfehlung für die DATEV-Aufgabe

**Zuerst die Datenaufgabe feststellen, dann zwei Kandidaten gezielt prüfen:**

1. **BHT-ARIMA**, falls viele verwandte, eher kurze numerische Reihen vorliegen.
2. **HOT-LSTM**, falls eine rekurrente numerische Prognose mit ausreichend Trainingsbeispielen sinnvoll ist.

Diese Priorisierung ist eine **Eignungshypothese**, kein Ergebnis auf den DATEV-Daten. Der Finanz-TT-RNN wird höher priorisiert, wenn tatsächlich eine Richtungsklassifikation auf Markt- oder vergleichbaren Signalen gefordert ist. Chaos- und Videoansätze benötigen eine entsprechende Datenstruktur.

Für einen aussagekräftigen Vergleich vorsehen: naive/seasonal-naive Referenz; ARIMA oder eine passende Lag-Regression; Gradient Boosting; den konventionellen Gegenpart des Hybrids; ein bis zwei starke neuronale Konkurrenten und gegebenenfalls einen passenden vortrainierten Forecaster. [TFB](https://www.vldb.org/pvldb/vol17/p2363-hu.pdf) hilft beim Vergleichsprotokoll. [DLinear](https://ojs.aaai.org/index.php/AAAI/article/view/26317), [N-BEATS](https://arxiv.org/abs/1905.10437), [PatchTST](https://arxiv.org/abs/2211.14730), [iTransformer](https://arxiv.org/abs/2310.06625) und [Chronos-2](https://arxiv.org/abs/2510.15821) sind Ausgangspunkte, keine vollständige aktuelle Rangliste.

Die Hauptauswahl und Hyperparameteroptimierung richten sich nach einer vordefinierten Validierungsmetrik. Parameter-matched Ablationen sind zusätzliche Versuche zur Erklärung des Tensorbeitrags; die Hauptkonkurrenz wird nicht allein durch identische Parameterzahlen festgelegt.

## Suchumfang und nächste Schritte

Gesucht wurde nach Tensor Networks, Tensor Train, Tucker, Hybrid-RNN/LSTM und ARIMA in Verbindung mit forecasting, accuracy, benchmarks und financial time series. Ausgangspunkte waren Originalarbeiten auf arXiv, AAAI/NeurIPS, Verlagsseiten und den von Autoren verlinkten Repositories. Grundlagenquellen sind separat im [Lernplan](chapter-2-learning-guide.md) zugeordnet.

Für die hervorgehobenen Ergebnisse wurden Volltexte und konkrete Ergebnisstellen gelesen, nicht nur Abstracts. Die PDF-Tabellen wurden anhand des verfügbaren extrahierten Volltexts geprüft; die Browser-Screenshotfunktion war für diese PDFs nicht verfügbar. Eine eigene Reproduktion und ein vollständiger systematischer Review stehen noch aus. Bei endgültiger Modellwahl sind Versionen und passende aktuelle Benchmark-Konkurrenten erneut zu prüfen.
