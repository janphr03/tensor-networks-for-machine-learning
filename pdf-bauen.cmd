@echo off
chcp 65001 >nul
rem Baut thesis.pdf und tensor-foundations.pdf neu. Doppelklick genügt.
cd /d "%~dp0"
echo Baue thesis.pdf ...
".tools\typst\typst.exe" compile --root . --font-path fonts main.typ thesis.pdf
if errorlevel 1 goto fehler
echo Baue tensor-foundations.pdf ...
".tools\typst\typst.exe" compile --root . --font-path fonts tensor-foundations.typ tensor-foundations.pdf
if errorlevel 1 goto fehler
echo.
echo Fertig: Beide PDFs sind aktualisiert.
pause
exit /b 0
:fehler
echo.
echo Das Bauen ist fehlgeschlagen, siehe Meldung oben. Häufigste Ursache: Ein PDF
echo ist gerade in einem PDF-Programm geöffnet und kann nicht überschrieben werden.
echo Programm schließen und diese Datei erneut starten.
pause
exit /b 1
