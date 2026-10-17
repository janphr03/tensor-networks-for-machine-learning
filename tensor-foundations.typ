// Standalone reading copy without front matter; base settings mirror template.typ.
#set document(title: "Tensor Network Foundations: Concepts, Examples, and Visual Metaphors")
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
#set text(font: "Libertinus Serif", size: 12pt, hyphenate: false, lang: "en", ligatures: true)
#set par(leading: 8pt, justify: true, linebreaks: "optimized")
#show figure: set par(justify: false)
#set figure(numbering: "I")
#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1")
#counter(heading).update(1)

= Theoretical Background <background>

This standalone reading copy contains Sections 2.4–2.6 of the thesis. It develops
the mathematical foundations, general network principles, and the connection to
machine learning. All numerical figures are original teaching examples. Their
values and shapes are independent of the research dataset.

#counter(heading).update((2, 3))
#include "chapters/tensor-mathematical-foundations.typ"
#include "chapters/tensor-network-principles.typ"
#include "chapters/tensor-learning-models.typ"

#bibliography("literature.bib", title: "Bibliography", style: "/ieee-modified.csl")
