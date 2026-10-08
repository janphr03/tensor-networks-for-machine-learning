#import "layout.typ": *

#set document(title: "Tensor Network Foundations: Concepts, Examples, and Visual Metaphors")
#show: thesis
#set page(numbering: "1", foreground: running-header(), footer: page-footer())
#set heading(numbering: "1.1", supplement: [Section])
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

#sources("references.bib")
