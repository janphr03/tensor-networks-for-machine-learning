# Tensor Networks for Machine Learning

Studienarbeit zum Thema **Tensor Networks for Machine Learning**.

Die Ausarbeitung wird mit **Typst** geschrieben. Dieses Repository sammelt die Typst-Dateien, Literaturübersicht sowie Code und Experimente zur Studienarbeit.

## Struktur

| Ordner | Inhalt |
| --- | --- |
| `thesis/` | Typst-Ausarbeitung, Metadaten und Kapitel |
| `literature/` | BibLaTeX-Literaturverzeichnis und eigene Zusammenfassungen |
| `src/` | Implementierungen und Hilfsfunktionen |
| `notebooks/` | Explorative Analysen und Demonstrationen |
| `experiments/` | Experimentbeschreibungen, Konfigurationen und Ergebnisse |
| `scripts/` | Installation und PDF-Erstellung unter Windows |
| `build/` | Generierte PDF, von Git ignoriert |

## Typst einrichten (Windows)

Voraussetzungen sind PowerShell, eine Internetverbindung für die Installation und [VS Code](https://code.visualstudio.com/). VS Code ist auf dem Rechner bereits vorhanden.

Im Projektordner ausführen:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup.ps1
```

Das Skript lädt den offiziellen **Typst-Compiler 0.15.1** nach `.tools/typst/` und installiert **Tinymist Typst** im vorhandenen VS Code. Tinymist bietet Syntaxunterstützung, Formatierung und eine Live-Vorschau. Compiler und Downloads werden nicht auf GitHub hochgeladen. Die Skripte ändern den systemweiten `PATH` nicht; im VS-Code-Terminal dieses Workspaces ist der lokale Compiler verfügbar. Die Execution-Policy-Option gilt nur für den gestarteten PowerShell-Prozess.

Die Vorlage verwendet mit Typst ausgelieferte Schriften und integrierte Funktionen für Mathematik und Literatur. Weitere Typst-Pakete sind für den Einstieg nicht erforderlich.

## Schreiben und Vorschau

1. `tensor-networks.code-workspace` in VS Code öffnen.
2. In `thesis/metadata.typ` Name, Hochschule, Studiengang, Betreuung und Datum eintragen.
3. `thesis/main.typ` öffnen und über `Strg+Shift+P` den Befehl **Typst Preview: Preview in Editor** auswählen. Alternativ `Strg+K`, danach `V` drücken.
4. In `thesis/chapters/` schreiben. Weitere Kapitel mit `#include` in `thesis/main.typ` einbinden.
5. Quellen in `literature/references.bib` ergänzen und beispielsweise mit `@stoudenmire2016` zitieren. Der IEEE-Zitierstil kann in `thesis/main.typ` geändert werden.

Titelblatt, Inhaltsverzeichnis, Seitenzahlen, Kapitelnummerierung und Literaturverzeichnis sind vorbereitet. Die Beispieltexte und TODOs sind Platzhalter; Format und Aufbau müssen an die Vorgaben der Hochschule angepasst werden.

## PDF erstellen

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

Ergebnis: `build/studienarbeit.pdf`. Mit `-Open` am Ende des Befehls wird die PDF zusätzlich geöffnet. In VS Code erstellt `Strg+Shift+B` die PDF ebenfalls.

Bei jeder Änderung automatisch neu erstellen (beenden mit `Strg+C`):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1 -Watch
```

Nach dem Setup funktioniert die PDF-Erstellung auch ohne Internet. Auf anderen Betriebssystemen den [offiziellen Typst-Compiler installieren](https://typst.app/open-source/), den Ordner `build` anlegen und im Projektordner ausführen:

```text
typst compile --root . thesis/main.typ build/studienarbeit.pdf
```

Python-Abhängigkeiten für spätere ML-Experimente werden mit den ersten Implementierungen ergänzt.

## Dokumentation

- [Typst-Tutorial](https://typst.app/docs/tutorial/)
- [Literatur und Zitate in Typst](https://typst.app/docs/reference/model/bibliography/)
- [Tinymist für VS Code](https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/vscode/README.md)

## Auf GitHub veröffentlichen

Auf [GitHub ein neues Repository erstellen](https://github.com/new), zum Beispiel mit dem Namen `tensor-networks-for-machine-learning`. Dabei keine README, `.gitignore` oder Lizenz automatisch hinzufügen, da das lokale Repository bereits initialisiert ist.

Anschließend im Terminal in diesem Projektordner ausführen und `DEIN-USERNAME` durch den eigenen GitHub-Benutzernamen ersetzen:

```powershell
git remote add origin https://github.com/DEIN-USERNAME/tensor-networks-for-machine-learning.git
git push -u origin main
```

## Lizenz

Eine Lizenz ist noch nicht festgelegt.
