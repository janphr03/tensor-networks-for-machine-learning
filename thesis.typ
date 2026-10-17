#import "template.typ" : *

#show: thesis.with(
  title: "Tensor Networks for Machine Learning",
  author: "Your name",
  type: "Student Research Paper",
  student_id: "Student ID",
  course: "Course",
  date: datetime.today(), // TODO: submission date
  time_period: "Writing period",
  confidentiality_clause: false,
  language: "en",
  supervisor: "Partner supervisor",
  signature: "hide",
	bibliography_path: "literature.bib",
  german_abstract: none, // set to include "./kurzfassung.typ" to enable it
  additional_preamble: (
    // You could put files to place before the table of contents here
  )
)

// Chapters reference numbered equations.
#set math.equation(numbering: "(1)")

// Include your chapters here
#include "chapters/01-Introduction.typ"
#include "chapters/02-Theoretical_Background.typ"
#include "chapters/03-Methodology.typ"
#include "chapters/04-Results_and_Discussion.typ"
#include "chapters/05-Conclusion_and_Outlook.typ"
