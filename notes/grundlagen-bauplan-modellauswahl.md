# Bauplan für Kapitel 2: Tensor-SOTA gegen ML-SOTA

Stand: 17. Oktober 2026. Grundlage ist das [Vergleichsdesign](<../../Analyse Daten/analyse_datensatz/vergleichsdesign_tensor_vs_ml.md>). Die Arbeit prüft ergebnisoffen, ob die besten Tensoransätze unsere Zeitreihen besser, gleich gut oder schlechter vorhersagen als die besten ML-Verfahren. Die Gliederung in [main.typ](../main.typ) bleibt erhalten; die ausformulierten Abschnitte 2.4–2.6 werden ergänzt statt ersetzt.

**Leitprinzipien:**

- **Symmetrie:** Beide Seiten konkurrieren und werden deshalb gleich gründlich erklärt. Die ML-Seite ist keine Orientierung mehr, sondern Gegner auf Augenhöhe.
- **Zweckbindung:** Jeder Abschnitt liefert einen Begriff oder ein Resultat, das ein Kandidat, eine Ablation oder die Vergleichsmethodik später benutzt. Alles andere wird kurze Orientierung oder entfällt.
- **Neutralität:** Die Motivation nennt Argumente für und gegen Tensoransätze. Vorteile werden als prüfbare Hypothesen formuliert.

## Kandidaten, die das Kapitel tragen muss

| Seite | Modelle | Gegenstück für die Ablation |
| --- | --- | --- |
| Tensor | TimeCapsule, BHT-ARIMA, MPS-/TT-Volterra-Regressor; optional HOT-LSTM | TimeCapsule mit Kompression (1,1,1); ARIMA; Ridge- und Polynom-Lags; LSTM |
| ML | Chronos-2 (optional TiRex oder TimesFM-2.5), PatchTST, N-HiTS, LightGBM, DLinear, AutoETS, AutoARIMA, AutoTheta, saisonal naiv | — |

## Begriffskette

1. **2.1** Prognoseursprung, Fenster, Horizont, rekursive und direkte Mehrschrittprognose, lokale und globale Modelle
2. **2.2** ML-Stand der Technik: statistische Referenzen, Lag-Lernen und Bäume, tiefe Prognosemodelle, vortrainierte Modelle
3. **2.3** Was für und was gegen Tensoransätze spricht, als Hypothesen
4. **2.4** Modus-n-Produkt und multilinearer Rang zusätzlich zum bestehenden Text
5. **2.5** HOSVD, HOOI und Procrustes zusätzlich zu TT/MPS, Schnittrang, Kontraktionskosten und kanonischer Form
6. **2.6** Die Tensorkandidaten vollständig
7. **2.7** Methodik des objektiven Vergleichs
8. **2.8** Evidenz auf beiden Seiten und Forschungslücke

## Übersicht

| Abschnitt | Muss liefern | Stand | Seiten |
| --- | --- | --- | ---: |
| 2.1 Zeitreihenprognose | Notation, Informationsstand, Mehrschrittstrategien, lokal und global | Platzhalter | 3 |
| 2.2 ML-Prognoseverfahren | Alle ML-Kandidaten so tief, dass ihre Stärken und Annahmen klar sind | Platzhalter | 7 |
| 2.3 Für und gegen Tensoren | Drei Tensor-Hypothesen, zwei Gegenargumente, Fehlschlagsfälle | Platzhalter | 2 |
| 2.4 Mathematische Grundlagen | + Modus-n-Produkt, multilinearer Rang, Frobenius-Skalarprodukt | ausformuliert, Ergänzung | 4 |
| 2.5 Tensornetzwerk-Prinzipien | + HOSVD mit Fehlerschranke, HOOI, Procrustes | ausformuliert, Ergänzung | 4 |
| 2.6 Tensormodelle für Prognosen | MPS-Volterra, Kernlernen, BHT-ARIMA, TimeCapsule, Abgrenzung | teilweise ausformuliert | 7 |
| 2.7 Objektiver Vergleich | Metriken, Aggregation, Validierung, Budgets, Vorregistrierung, Statistik, Kontamination, Effizienz | Platzhalter | 5 |
| 2.8 Forschungsstand | Leaderboards, Tensorevidenz, Lücke | Platzhalter | 3 |

Summe 35 Seiten, also am oberen Rand des bisherigen Rahmens von 28–35 Seiten. Wird es enger, kürzen sich 2.4/2.5 zuerst, weil sie bereits ausführlich sind.

## 2.1 Zeitreihenprognose

**Liefern:** Multivariate Reihe `x_t ∈ ℝ^N`, Prognoseursprung t, Fensterlänge L, Horizont h ≤ H, Punkt- und Quantilprognose. Dazu der Informationsstand am Ursprung und die Definition von Leakage.

**Mehrschrittstrategien:**

- **rekursiv:** ARIMA, ETS, BHT-ARIMA; Fehler pflanzen sich fort
- **direkt beziehungsweise Multi-Output:** MPS mit Ausgangsbein, N-HiTS, PatchTST, DLinear, TimeCapsule
- **Seq2seq:** HOT-LSTM
- **vortrainiert:** Chronos-2 erzeugt den ganzen Horizont aus dem Kontext

**Lokal und global:** Lokale Modelle (ARIMA, ETS, Theta, BHT-ARIMA) werden je Reihe oder Block und je Ursprung neu angepasst. Globale Modelle werden einmal über viele Fenster und Reihen trainiert. Vortrainierte Modelle sind global über fremde Daten. Die Unterscheidung braucht 2.7 für den Latenzbegriff und für faire Budgets.

**Quellen:** FPP3 (`hyndman2021`) 5.10 und Kapitel 9; Montero-Manso und Hyndman 2021 (neu).

## 2.2 Prognoseverfahren des maschinellen Lernens

### 2.2.1 Statistische Referenzen

Naive und saisonal naive Prognose als Nullpunkt der Skill-Skala. ETS als Zustandsraummodell mit automatischer Auswahl. Theta. AR(p) mit Yule-Walker-Gleichungen `Γ_p φ = γ_p`, Differenzierung, MA(q) und ARIMA mit rekursiver Prognose.

ARIMA wird hier tief behandelt, weil BHT-ARIMA darauf aufbaut. Quellen: FPP3 5.2, 8 und 9; Box et al. 2015 (neu); Hyndman et al. 2002 zu automatischem ETS (neu); Assimakopoulos und Nikolopoulos 2000 zu Theta (neu).

### 2.2.2 Lernen auf Lag-Merkmalen

Prognose als überwachtes Lernen auf Fenstern:

- **Ridge-Lag-Regression** mit geschlossener Lösung. Sie ist zugleich der Rang-2-Spezialfall des MPS-Modells.
- **Polynomiale Lag-Merkmale:** `C(L+D, D)` Monome bis Grad D. Next-Generation Reservoir Computing ist diese dichte Variante mit Ridge (Gauthier et al. 2021, neu) und das Gegenstück zu 2.6.1.
- **Gradient Boosting:** additive Bäume, Histogramm-Split und Blattwachstum bei LightGBM (Ke et al. 2017, neu; `chen2016`). Zeitinformation gelangt nur über kausale Lag- und Kalendermerkmale ins Modell.

### 2.2.3 Tiefe Prognosemodelle

- **N-HiTS:** Blöcke mit Mehrraten-Abtastung und hierarchischer Interpolation, Basisdarstellung wie N-BEATS (`oreshkin2020`; Challu et al. 2023, neu).
- **DLinear:** Zerlegung in Trend und Rest, je ein linearer Abbilder (`zeng2023`). Wichtig als Prüfstein, ob Komplexität überhaupt hilft.
- **Transformer-Grundlagen und PatchTST:** Attention (`vaswani2017`), Patches als Tokens, Kanalunabhängigkeit, Instanznormierung (`nie2023`). Dazu Voraussetzungen für die Fensterlänge bei 600 Zeilen.
- **GRU/LSTM** kompakt (`goodfellow2016` Kapitel 10), nur als Gegenstück zu HOT-LSTM.

iTransformer und weitere Architekturen bleiben bei einer kurzen Einordnung.

### 2.2.4 Vortrainierte Prognosemodelle

Chronos-2 bekommt eine eigene Seite, weil es auf fev-bench und GIFT-Eval führt:

- **Vortraining** auf realen und synthetischen Reihen, Zero-Shot-Prognose aus dem Kontext
- **Architektur:** Encoder auf skalierten Patches; Gruppen-Attention, die Varianten einer multivariaten Reihe, verwandte Reihen und Kovariaten gemeinsam betrachtet
- **Ausgabe:** Quantile
- **Größen:** 120 M und 28 M Parameter

Kurz eingeordnet werden TiRex (xLSTM-basiert) und TimesFM-2.5 (Decoder auf Patches). Abschnitt 2.7 braucht hier die Begriffe Vortrainingskorpus und Kontamination. Quellen: `ansari2025`; Shchur et al. 2025 zu fev-bench und Aksu et al. 2024 zu GIFT-Eval (beide neu).

## 2.3 Was für und was gegen Tensoransätze spricht

**Für Tensoren, als prüfbare Hypothesen:**

- **T-H1, niedriger Rang über Reihen und Verzögerungen (BHT-ARIMA).** Satz: Erfüllt eine Folge die Rekursion `x_t = Σ_{j=1}^k a_j x_{t−j}`, dann hat jede Hankel-Matrix `H_ij = x_{i+j−1}` höchstens Rang k. Beispiele: Trend Rang 2, Sinus fester Frequenz Rang 2, Summen addieren höchstens. Teilen Reihen dieselben Muster, ist der Block-Hankel-Tensor näherungsweise von niedrigem multilinearem Rang. Quelle: Golyandina et al. 2001 (neu).
- **T-H2, Wechselwirkungen mit kontrolliertem Rang (MPS).** Dichte Polynomexpansionen wachsen mit `C(L+D, D)` beziehungsweise `m^L`. Ein MPS beschränkt sie über Schnittränge; Kosten linear in L, lineare Lag-Regression als Rang-2-Fall enthalten.
- **T-H3, Modus-Kompression bei vielen Variablen (TimeCapsule).** Eine gelernte Kompression je Modus kann Redundanz über Zeit, Variablen und Skalen entfernen. Laut Ablation wirkt sie bei vielen Variablen (Traffic, PEMS) und kaum bei Weather.

**Gegen Tensoren, ebenso ernst genommen:**

- **ML-G1, Vortrainingswissen.** Vortrainierte Modelle bringen Muster aus Millionen fremder Reihen mit. Bei 600 Zeilen je Datei kann das jeden auf unseren Daten geschätzten Strukturvorteil überwiegen.
- **ML-G2, flexible Nichtlinearität ohne Rangannahme.** Bäume und Netze müssen keine niedrige Rangstruktur voraussetzen. Ist die Struktur nicht niedrigrangig, verliert ein Tensormodell durch Abschneiden Information.

**Erwartete Fehlschlagsfälle:**

- nicht zeitgleiche Reihen (M4-Ausschnitt)
- Strukturbrüche (Sprung in `Q4923`)
- Random-Walk-Verhalten (FX)
- Polynomextrapolation außerhalb des Trainingsbereichs
- falsch gewählte Ränge

Ausgangsbefund aus der [Datensatzanalyse](<../../Analyse Daten/analyse_datensatz/Datensatzanalyse.md>): 5–9 PCA-Komponenten für 90 % Varianz auf Niveaus, aber voller numerischer Rang. Niedriger Rang ist also eine Näherung.

## 2.4 Mathematische Grundlagen

Der bestehende Text ([tensor-mathematical-foundations.typ](../chapters/tensor-mathematical-foundations.typ)) bleibt. Ergänzt werden, zusammen etwa eine halbe Seite mit Beispiel am bestehenden Ledger:

- **Modus-n-Produkt** `(𝒳 ×_n U)_{i_1…j…i_N} = Σ_{i_n} 𝒳_{i_1…i_n…i_N} U_{j,i_n}` mit `(𝒳 ×_n U)_(n) = U·X_(n)` (`kolda2009` 2.5). Es wird für Tucker, BHT-ARIMA und TimeCapsule gebraucht.
- **Multilinearer Rang** als Tupel der Ränge der Modus-Entfaltungen.
- **Frobenius-Skalarprodukt** `⟨𝒜, ℬ⟩`, damit das MPS-Modell als `ŷ = ⟨𝒲, Φ(x)⟩` geschrieben werden kann.

## 2.5 Prinzipien von Tensornetzwerken

Der bestehende Text ([tensor-network-principles.typ](../chapters/tensor-network-principles.typ)) deckt alles ab, was das MPS-Modell braucht. Im Tucker-Teil kommen etwa 1–1,5 Seiten hinzu:

- **HOSVD** mit Fehlerschranke `‖𝒳 − 𝒳̂‖_F² ≤ Σ_n Σ_{i>R_n} (σ_i^(n))² ≤ N·‖𝒳 − 𝒳_best‖_F²`, also quasi-optimal (De Lathauwer et al. 2000a, neu).
- **HOOI** als alternierende Verbesserung (De Lathauwer et al. 2000b, neu; `kolda2009` 4.2).
- **Orthogonales Procrustes-Problem:** `min ‖A − U·B‖_F` unter `UᵀU = I` wird gelöst durch `U = P·Qᵀ` aus der SVD `A·Bᵀ = P·Σ·Qᵀ` (Schönemann 1966, neu). BHT-ARIMA aktualisiert so seine Faktoren.

Die QR-Verschiebung des Orthogonalitätszentrums bleibt, weil 2.6.2 sie braucht.

## 2.6 Tensormodelle für Prognosen

### 2.6.1 MPS-/TT-Volterra-Regressor

Baut auf dem vorhandenen Abschnitt „Feature Maps and Prediction Functions“ auf.

- **Modell:** `ŷ_{t+h} = ⟨𝒲, φ(x_{t−L+1}) ⊗ ⋯ ⊗ φ(x_t)⟩_h` mit offenem Ausgangsbein für direkte Mehrschrittprognosen.
- **Merkmale:** `(1, x)` oder Legendre-Polynome auf dem aus Trainingsdaten skalierten Intervall. Mit polynomieller `φ` ist das Modell eine abgeschnittene Volterra-Reihe (`martinez2026`; Batselier et al. 2017; Exponential Machines).
- **Satz (Rang 2):** Mit `φ(x) = (1, x)` hat jede affine Funktion `b + Σ_n w_n x_n` TT-Rang ≤ 2:
  - erster Kern `(1, b + w_1·x_1)`
  - innere Kerne `[[1, w_n·x_n], [0, 1]]`
  - letzter Kern `(w_L·x_L, 1)ᵀ`

  Ridge-Lags sind also exakt Rang 2, Produkte lokaler Funktionen Rang 1, Summen aus R separablen Termen Rang ≤ R. Numerisch geprüft.
- **Multivariat:** ein Kern je Zeitschritt mit `φ(x_t) = (1, x_t^(1), …, x_t^(N))` oder ein Kern je Paar aus Lag und Variable; dann bestimmt die Anordnung die Schnittränge.
- **Kosten:** etwa `L·(m+1)·r²` Multiplikationen je Prognose, bei L = 24, m = 2, r = 8 also 4.608. Der volle Tensor hätte `m^L` Koeffizienten. Die Begründung liefert die Kontraktionsreihenfolge aus `fig-order`.

**Neue Abbildung:** MPS-Kette über ein Lag-Fenster mit Ausgangsbein.

### 2.6.2 Lernen der Kerne

Ergänzt den vorhandenen Abschnitt „Learning Tensor Cores“:

- **ALS-Sweeps:** Bei festen übrigen Kernen ist die Prognose linear im aktuellen Kern. Die Zeilen der Designmatrix sind `linke Umgebung ⊗ φ(x_n) ⊗ rechte Umgebung`; gelöst wird ein Ridge-Problem, danach folgt eine QR-Verschiebung.
- **Monotonie:** Der Trainingsverlust fällt monoton, ein globales Optimum ist nicht garantiert (Holtz et al. 2012, Batselier et al. 2017, beide neu).
- **Ränge:** Zwei-Kern-Updates mit SVD-Abschneiden passen sie an (`stoudenmire2016`).
- **Alternative:** Lösung in geschlossener Form über die Pseudoinverse in MPO-Darstellung (`martinez2026`).

### 2.6.3 Block-Hankel-Tensor-ARIMA

Neuer Abschnitt, etwa zwei Seiten (`shi2020` Abschnitte 3–4, Gleichungen 6–15):

1. **MDT:** Aus `X ∈ ℝ^{N×T}` entsteht `𝒳̂ ∈ ℝ^{N×τ×(T−τ+1)}` über eine Duplikationsmatrix. Die Inverse mittelt über die Pseudoinverse (Yokota et al. 2018, neu).
2. **Tucker:** Geteilte orthonormale Faktoren; die Kerne `𝒢_t` liegen nahe an `𝒳̂_t ×_1 U^(1)ᵀ ×_2 U^(2)ᵀ` und folgen einer ARIMA-Dynamik.
3. **Gemeinsames Ziel (Gleichung 10)** aus ARIMA-Residuum und Projektionsabweichung. Geschlossenes Kern-Update (Gleichung 13), Procrustes für die Faktoren (Gleichung 15), Yule-Walker auf Kerntensoren.
4. **Prognose:** vorhersagen, zurückprojizieren, Differenzierung umkehren, MDT invertieren; mehrere Schritte rekursiv.
5. **Annahmen:** skalare AR- und MA-Koeffizienten für ganze Kerne, zeitgleiche vollständige Reihen, Stationarität nach Differenzierung, Neuanpassung je Ursprung.

Beim Lesen beachten: Das MA-Vorzeichen unterscheidet sich zwischen Gleichung 9 und 10, und der Nenner in Gleichung 18 ist gedruckt negativ.

**Neue Abbildung:** Pipeline aus Reihen, Hankel-Tensor, Kernfolge mit ARIMA und Rückprojektion.

### 2.6.4 TimeCapsule

Neuer Abschnitt, etwa 1,5 Seiten (Lu et al., KDD 2025, neu):

- Darstellung jeder Reihe als 3D-Tensor aus Zeit, Variable und Ebene der Mehrskalen-Zerlegung
- Kompression je Modus über Modus-n-Produkte mit gelernten Niedrigrang-Faktoren `M = C·E`; das ähnelt Tucker, ohne explizite Zerlegung
- Prognose im komprimierten Raum, unterstützt durch eine JEPA-Hilfsaufgabe; Rückführung der Residualinformation
- **Was die Ablation zeigt:** Kompression (1,1,1) entspricht einem reinen MLP. Weather 0,219 → 0,220, PEMS04 0,120 → 0,156.
- **Anpassung an 600 Zeilen:** Lookback 48–96 statt 512.

### 2.6.5 Tensorisierte Schichten und rekurrente Hybride

Kurz: TT-Schichten (`novikov2015`) und HOT-RNN mit erweitertem Zustand, Ordnung P und TT-Übergangstensor (`yu2019`). Effizient ausgewertet wächst der Aufwand nur linear in P, weil der Eingang Rang 1 hat; die Referenzimplementierung bildet dagegen das volle äußere Produkt.

LiQSS dient als Beispiel, warum der Tensorbeitrag isoliert werden muss: 0,9 % TT-Parameter. Wird HOT-LSTM implementiert, kommt Theorem 1 aus `yu2019` mit seinen Voraussetzungen hinzu.

### 2.6.6 Herkunft der Tensornetzwerke

Höchstens ein kurzer Absatz: MPS und verwandte Netzwerke stammen aus der Quantenphysik. In dieser Arbeit sind sie klassische Prognosemodelle auf gewöhnlicher Hardware. Der vorhandene Abschnitt „Classical and Quantum-Inspired Interpretation“ und die Quantenbezüge in README und `main.typ` werden mit dem Betreuer geklärt; bis dahin genügt dieser Absatz.

## 2.7 Methodik des objektiven Vergleichs

Der umfangreichste neue Methodenabschnitt; er wird vor den Experimenten fertiggestellt.

- **Fehlermaße:** MASE (Hyndman und Koehler 2006, neu), RMSSE, WQL für Quantile. Warum MAPE bei Nullen und Celsius ungeeignet ist (FPP3 5.8).
- **Aggregation wie fev-bench:** geometrisches Mittel relativer Fehler gegenüber saisonal naiv, Skill-Score, Gewinnrate.
- **Zeitliche Validierung:** Rolling Origin, Neuanpassungsregel lokaler Modelle (FPP3 5.10, `qiu2024`).
- **Fairness:**
  - Vertreterwahl je Seite nur auf Validierung, weil sonst die Seite mit mehr Kandidaten bevorzugt wird
  - gleiches Tuningbudget
  - gleiche Eingabeinformation
  - mehrere Seeds
- **Vorregistrierung:** Was vor dem ersten Test festgehalten wird und warum (Hewamalage et al. 2023, neu).
- **Statistische Entscheidung:**
  - Bayesianischer Vorzeichen-Rang-Test mit ROPE, der direkt „besser/gleich/schlechter“ liefert (Benavoli et al. 2017, neu)
  - ergänzend Wilcoxon mit TOST und Diebold-Mariano mit Harvey-Korrektur (Diebold und Mariano 1995, Harvey et al. 1997, neu)
  - Holm-Korrektur bei Mehrfachvergleichen
- **Kontamination** vortrainierter Modelle; Prüfung je Datei.
- **Effizienz:**
  - Latenz bei Batchgröße 1 auf CPU und GPU als Median und p95; bei lokalen Modellen einschließlich Neuanpassung
  - Multiplikationen pro Prognose, Parameter, Speicher
  - Pareto-Front
  - Warum Parameterzahl keine Latenz ist (Valverde et al. 2026, neu; Hoefler und Belli 2015, neu)

**Neue Abbildung:** Rolling-Origin-Schema mit Training, Validierung, Test und Neuanpassungspunkten.

## 2.8 Forschungsstand

- **ML-Seite:** Entwicklung von aufgabenspezifischen Modellen zu vortrainierten Modellen. Im GIFT-Eval-Paper von 2024 lag PatchTST insgesamt vorn; inzwischen führen vortrainierte Modelle die Leaderboards an.
- **Tensorseite:**

| Arbeit | Kernaussage für den Vergleich |
| --- | --- |
| TimeCapsule (KDD 2025) | Knapp vor PatchTST auf Langfrist-Benchmarks; Tensorwirkung vor allem bei vielen Variablen |
| BHT-ARIMA (AAAI 2020) | Bester Beleg für kurze, verwandte Reihen; vor allem ein Schritt |
| HOT-RNN/HOT-LSTM | Starke Theorie; als TTRNN im Drittvergleich schwächer als GRU |
| MPO/Volterra (`martinez2026`) | Ähnlich wie ESN auf chaotischen Systemen; Trainingszeitvorteil |
| LiQSS | TT-Anteil 0,9 % |
| Übersicht Valverde et al. 2026 | Kaum Vergleiche mit aktuellen Spitzenmodellen |

- **Forschungslücke:** In den gefundenen Leaderboard-Ständen von fev-bench und GIFT-Eval steht kein Tensormodell, und kein unabhängiger Vergleich stellt aktuelle Tensoransätze gegen aktuelle ML-Verfahren unter einem gemeinsamen Protokoll. Diese Arbeit liefert ihn.

## Neue Literatur für references.bib

| Schlüssel | Quelle | Abschnitt |
| --- | --- | --- |
| `montero2021` | Montero-Manso, Hyndman: Locality and globality, IJF 37(4), 2021 | 2.1 |
| `box2015` | Box, Jenkins, Reinsel, Ljung: Time Series Analysis, 5. Aufl., 2015 | 2.2.1 |
| `hyndman2002` | Hyndman, Koehler, Snyder, Grose: State space framework for automatic exponential smoothing, IJF 18(3), 2002 | 2.2.1 |
| `assimakopoulos2000` | Assimakopoulos, Nikolopoulos: The theta model, IJF 16(4), 2000 | 2.2.1 |
| `ke2017` | Ke et al.: LightGBM, NeurIPS 2017 | 2.2.2 |
| `gauthier2021` | Gauthier et al.: Next generation reservoir computing, Nature Communications 12, 2021 | 2.2.2, 2.6.1 |
| `challu2023` | Challu et al.: N-HiTS, AAAI 2023 | 2.2.3 |
| `shchur2025` | Shchur et al.: fev-bench, arXiv:2509.26468 | 2.2.4, 2.7 |
| `aksu2024` | Aksu et al.: GIFT-Eval, arXiv:2410.10393 | 2.2.4, 2.8 |
| `golyandina2001` | Golyandina, Nekrutkin, Zhigljavsky: SSA, 2001 | 2.3 |
| `delathauwer2000a`, `delathauwer2000b` | Multilinear SVD; best rank-(R1,…,RN) approximation, SIAM J. Matrix Anal. Appl. 21(4), 2000 | 2.5 |
| `schonemann1966` | Orthogonal Procrustes problem, Psychometrika 31(1), 1966 | 2.5 |
| `novikov2017` | Novikov, Trofimov, Oseledets: Exponential Machines, arXiv:1605.03795 | 2.6.1 |
| `batselier2017` | Batselier, Chen, Wong: TN-ALS for MIMO Volterra, Automatica 84, 2017 | 2.6.1, 2.6.2 |
| `holtz2012` | Holtz, Rohwedder, Schneider: ALS in the TT format, SIAM J. Sci. Comput. 34(2), 2012 | 2.6.2 |
| `yokota2018` | Yokota et al.: Missing slice recovery in embedded space, CVPR 2018 | 2.6.3 |
| `lu2025` | Lu et al.: TimeCapsule, KDD 2025, arXiv:2504.12721 | 2.6.4 |
| `hyndman2006` | Hyndman, Koehler: Another look at measures of forecast accuracy, IJF 22(4), 2006 | 2.7 |
| `hewamalage2023` | Hewamalage, Ackermann, Bergmeir: Forecast evaluation for data scientists, DMKD 37, 2023 | 2.7 |
| `benavoli2017` | Benavoli et al.: Time for a change, JMLR 18, 2017 | 2.7 |
| `diebold1995`, `harvey1997` | Comparing predictive accuracy, JBES 1995; Testing equality of prediction MSE, IJF 1997 | 2.7 |
| `hoefler2015` | Hoefler, Belli: Scientific benchmarking of parallel computing systems, SC 2015 | 2.7 |
| `valverde2026` | Valverde et al.: Quantum-inspired tensor networks in ML models, arXiv:2604.14287 | 2.7, 2.8 |
| `rezazadeh2026` | Rezazadeh et al.: LiQSS, arXiv:2601.12375v3 | 2.6.5, 2.8 |

Online abgeglichen sind bisher die arXiv-Fassungen, die Repositories, die KDD-Angabe von TimeCapsule und der Automatica-Nachweis von Batselier et al. Die übrigen Angaben vor dem Eintragen an der Verlagsseite prüfen. Im vorhandenen Eintrag `ansari2025` fehlt der Backslash im Umlaut: `K{"u}ken` muss `K{\"u}ken` lauten.

## Was gekürzt wird

- Finanzspezifische Bewertung (Richtungsklassifikation, Portfolio): nur im Forschungsstand.
- iTransformer und weitere Transformer-Varianten: kurze Einordnung statt eigener Unterabschnitte.
- HOT-RNN: etwa eine Seite in 2.6.5, sofern es nicht implementiert wird.

## Reihenfolge beim Schreiben

1. **2.7:** zuerst, weil die Vorregistrierung vor den Experimenten stehen muss.
2. **2.6.1 und 2.6.2:** Rang-2-Satz, Kosten und ALS; baut direkt auf vorhandenem Text auf.
3. **2.2:** ML-Seite, parallel zur Einrichtung der ML-Pipeline.
4. **2.3, 2.4 und 2.5:** Hypothesen, Modus-n-Produkt, HOSVD und Procrustes.
5. **2.6.3 und 2.6.4:** BHT-ARIMA und TimeCapsule.
6. **2.1 und 2.8:** zuletzt; 2.8 wird nach den eigenen Ergebnissen aktualisiert.

**Prüffragen zum Selbsttest:**

- Warum hat ein Sinus fester Frequenz eine Hankel-Matrix vom Rang 2?
- Welche Kerne stellen `3 + 2x_1 − x_2 + 0,5x_3` als MPS dar?
- Warum darf der beste Vertreter einer Seite nicht auf den Testdaten gewählt werden?
- Was unterscheidet „nicht signifikant schlechter“ von „praktisch gleichwertig“?
- Welche Zeit zählt als Inferenz bei BHT-ARIMA, welche bei Chronos-2?
