#import "layout.typ": *

// Edit your title and personal details here.
#let data = (
  title: "Tensor Networks for Machine Learning",
  work-type: "Student Research Paper",
  author: "Your name",
  degree: "Degree programme",
  university: "University",
  student-id: "Student ID",
  course: "Course",
  period: "Writing period",
  partner: "Partner organisation",
  supervisor: "Academic supervisor",
  partner-supervisor: "Partner supervisor",
  submission-date: "Submission date",
  partner-logo: none, // Replace none with an image path, e.g. "partner.png".
  university-logo: none,
)

// Optional front matter. Enable only the sections required for this thesis.
#let with-confidentiality = false
#let with-german-abstract = false

#set document(title: data.title, author: data.author)
#show: thesis
#title-page(data)

#if with-confidentiality {
  unnumbered([Confidentiality Notice], listed: false)
  placeholder([Insert the confidentiality notice.])
  pagebreak()
}

#unnumbered([Declaration of Originality], listed: false)
#placeholder[Insert the declaration of originality required for this thesis.]
#v(2cm)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 2cm,
  [#placeholder[Place, date]\ #line(length: 100%)\ Place, date], [#v(1em) #line(length: 100%)\ Signature],
)

// Front matter: Roman page numbers, no running header.
#pagebreak()
#set page(numbering: "I", footer: page-footer())
#counter(page).update(1)
#align(center, heading(numbering: none, outlined: false)[Abstract])
#placeholder[Insert the English abstract.]

#if with-german-abstract {
  pagebreak()
  align(center, heading(numbering: none, outlined: false)[German Abstract])
  placeholder([Insert the German abstract.])
}

#pagebreak()
#outline(title: [Table of Contents], depth: 3, indent: 1.5em)

#figure-list(image, [List of Figures])
#figure-list(table, [List of Tables])
#appendix-list()

#unnumbered([List of Abbreviations])
// Keep entries in alphabetical order; spell out abbreviations on first use.
/ ACRONYM: #placeholder[Insert the full term.]

#unnumbered([Glossary])
// Keep entries in alphabetical order; use concise definitions.
/ Term: #placeholder[Insert the definition.]

// Main matter: Arabic page numbers, each chapter starts on a new page.
#pagebreak()
#set page(numbering: "1", foreground: running-header())
#counter(page).update(1)
#set heading(numbering: "1.1", supplement: [Section])

= Introduction <introduction>
#placeholder[Insert the chapter introduction.]

== Motivation <motivation>
#placeholder[Insert the motivation.]

== Problem Statement
#placeholder[Insert the problem statement.]

== Objectives and Research Questions
#placeholder[Insert the objectives and research questions.]

== Structure of the Thesis
#placeholder[Insert the structure of the thesis.]

= Theoretical Background <background>
#placeholder[Insert the chapter introduction.]

== Fundamentals
#placeholder[Insert the fundamentals.]

== Related Work
#placeholder[Insert the related work.]

= Methodology <methodology>
#placeholder[Insert the chapter introduction.]

== Research Approach
#placeholder[Insert the research approach.]

== Experimental Setup
#placeholder[Insert the experimental setup.]

= Results and Discussion <results>
#placeholder[Insert the chapter introduction.]

== Results
#placeholder[Insert the results.]

== Discussion and Limitations
#placeholder[Insert the discussion and limitations.]

= Conclusion and Outlook <conclusion>
#placeholder[Insert the chapter introduction.]

== Summary
#placeholder[Insert the summary.]

== Future Work
#placeholder[Insert possible future work.]

#sources("references.bib")

#unnumbered([Declaration of AI Use])
#placeholder[Document the tools used, their purposes, and your own verification.]

// Appendices: A, B, ...; subsections A.1, A.2, ...; page numbers continue.
#pagebreak()
#counter(heading).update(0)
#set heading(numbering: "A.1", supplement: [Appendix])

= Appendix Title <appendix>
#placeholder[Insert the appendix.]

== Section Title
#placeholder[Insert the supplementary materials.]
