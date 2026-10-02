#import "metadata.typ": metadata

#set document(title: metadata.title, author: metadata.author)
#set page(
  paper: "a4",
  margin: (left: 3cm, right: 2.5cm, top: 2.5cm, bottom: 2.5cm),
  numbering: none,
)
#set text(font: "Libertinus Serif", size: 11pt, lang: "de")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")

// Titelblatt
#align(center)[
  #v(2cm)
  #text(size: 15pt)[#metadata.university]
  #v(2cm)
  #text(size: 25pt, weight: "bold")[#metadata.title]
  #v(1cm)
  #text(size: 17pt)[Studienarbeit]
  #v(2cm)
  #metadata.author \
  Matrikelnummer: #metadata.student-id \
  Studiengang: #metadata.degree
  #v(1cm)
  Betreuung: #metadata.supervisor \
  Abgabedatum: #metadata.submission-date
]

#pagebreak()
#set page(numbering: "i")
#counter(page).update(1)
#heading(numbering: none, outlined: false)[Zusammenfassung]
// TODO: Nach Abschluss der Arbeit die Zusammenfassung schreiben.
Hier die Fragestellung, Vorgehensweise und wichtigsten Ergebnisse zusammenfassen.

#pagebreak()
#outline(title: [Inhaltsverzeichnis], depth: 3)

#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)
#include "chapters/01-introduction.typ"
#include "chapters/02-foundations.typ"
#include "chapters/03-methodology.typ"
#include "chapters/04-results.typ"
#include "chapters/05-conclusion.typ"

#pagebreak()
#bibliography("../literature/references.bib", title: [Literaturverzeichnis], style: "ieee")
