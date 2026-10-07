// Layout based on the T2000. Edit the thesis content and details in main.typ.
#let blue = rgb("174f86")
#let muted = rgb("70839c")
#let hairline = rgb("bdc9d6")
#let chapter-gray = rgb("e2e5e9")

#let placeholder(body) = text(fill: rgb("777777"), style: "italic", body)

#let running-header() = context {
  let current-page = here().page()
  let chapters = query(heading.where(level: 1))
    .filter(it => it.location().page() <= current-page)
  if chapters.len() > 0 {
    let chapter = chapters.last()
    place(top + left, dx: 2.5cm, dy: 0.95cm, block(width: 16cm)[
      #align(right, text(size: 10pt, fill: muted)[
        #if chapter.numbering != none {
          numbering(chapter.numbering, ..counter(heading).at(chapter.location()))
          h(0.65em)
          [·]
          h(0.65em)
        }
        #chapter.body
      ])
      #v(9pt)
      #line(length: 100%, stroke: 0.35pt + hairline)
    ])
  }
}

#let page-footer() = context {
  align(right, text(size: 10pt, fill: muted)[
    #box(width: 1cm, line(length: 100%, stroke: 0.35pt + hairline))
    #h(0.8em)
    #counter(page).display()
  ])
}

#let thesis(body) = {
  set page(
    paper: "a4",
    margin: (left: 2.5cm, right: 2.5cm, top: 2.8cm, bottom: 2.4cm),
    numbering: none,
    footer: none,
    footer-descent: 1.1cm,
  )
  set text(font: "Latin Modern Roman 12", size: 12pt, lang: "en", hyphenate: true)
  set par(justify: true, leading: 0.6em, spacing: 0.5em, first-line-indent: 0pt)
  set heading(numbering: none, supplement: [Section])
  set math.equation(numbering: "(1)")
  set figure(numbering: "1")
  show figure.where(kind: image): set figure(supplement: [Figure])
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure.caption: set text(size: 10pt)
  set terms(hanging-indent: 1cm, spacing: 0.9em)
  set table(stroke: none, inset: (x: 0pt, y: 4pt))
  show link: set text(fill: blue)
  show heading.where(level: 1): it => {
    if it.numbering != none { pagebreak(weak: true) }
    block(width: 100%, above: 0pt, below: 0.85em, {
      if it.numbering != none {
        context {
          let chapter-number = counter(heading).at(it.location()).first()
          let display-number = if it.numbering == "A.1" {
            numbering("A", chapter-number)
          } else {
            if chapter-number < 10 { "0" + str(chapter-number) } else { str(chapter-number) }
          }
          place(right, dx: 1.7cm, dy: -17pt,
            text(size: 44pt, fill: chapter-gray, display-number))
        }
      }
      pad(right: if it.numbering == none { 0pt } else { 1.2cm },
        text(size: 17.28pt, weight: "bold", it.body))
    })
  }
  show heading.where(level: 2): it => block(above: 1.5em, below: 0.7em)[
    #text(size: 14.4pt, weight: "bold")[
      #context {
        if it.numbering != none {
          text(fill: blue, counter(heading).display(it.numbering))
          h(0.5em)
        }
      }
      #it.body
    ]
  ]
  show heading.where(level: 3): it => block(above: 1.1em, below: 0.55em)[
    #text(size: 12pt, weight: "bold")[
      #context {
        if it.numbering != none {
          text(fill: blue, counter(heading).display(it.numbering))
          h(0.5em)
        }
      }
      #it.body
    ]
  ]
  show outline.entry: it => context {
    show link: set text(fill: black)
    if it.level == 1 and it.element.func() == heading {
      block(inset: (top: 7pt, bottom: 4pt), text(weight: "bold",
        it.indented(it.prefix(), link(it.element.location())[
          #it.body() #h(1fr) #counter(page).display(at: it.element.location())
        ])))
    } else {
      block(inset: (y: 3pt), link(it.element.location(),
        it.indented(it.prefix(), it.inner())))
    }
  }
  body
}

#let title-page(data) = {
  let logo-slot(body, path) = if path == none {
    block(width: 3.5cm, height: 1.2cm,
      stroke: 0.4pt + hairline, align(center + horizon, placeholder(body)))
  } else { image(path, width: 3.5cm, height: 1.2cm, fit: "contain") }
  place(top + left, dy: -1.55cm, logo-slot([Partner logo], data.partner-logo))
  place(top + right, dy: -1.55cm, logo-slot([University logo], data.university-logo))
  v(3.7cm)
  align(center)[
    #text(size: 20.74pt, weight: "bold", data.title)
    #v(1.9cm)
    #text(size: 14.4pt, weight: "bold", data.work-type)
    #v(0.55cm)
    #text(size: 14.4pt, data.degree)
    #v(0.25cm)
    #text(size: 14.4pt, data.university)
    #v(1.8cm)
    by
    #v(0.45cm)
    #text(size: 17.28pt, weight: "bold", data.author)
  ]
  v(1fr)
  align(center, table(
    columns: (auto, auto), align: left, column-gutter: 0.6cm,
    row-gutter: 3pt, inset: (x: 0pt, y: 1.5pt),
    [Writing period], [#data.period],
    [Student ID, course], [#data.student-id, #data.course],
    [Partner organisation], [#data.partner],
    [Academic supervisor], [#data.supervisor],
    [Partner supervisor], [#data.partner-supervisor],
    [Submission date], [#data.submission-date],
  ))
  pagebreak()
}

#let unnumbered(title, listed: true) = {
  pagebreak(weak: true)
  heading(numbering: none, outlined: listed, title)
}

#let figure-list(kind, title) = {
  unnumbered(title)
  context {
    let items = query(figure.where(kind: kind, outlined: true))
    if items.len() == 0 {
      placeholder([No entries yet.])
    } else {
      show outline.entry: it => context {
        show link: set text(fill: black)
        block(inset: (y: 3pt), link(it.element.location(), it.indented(
          counter(figure.where(kind: kind)).display(
            it.element.numbering, at: it.element.location()),
          it.inner(),
        )))
      }
      outline(title: none, target: figure.where(kind: kind), indent: auto)
    }
  }
}

#let appendix-list() = {
  unnumbered([List of Appendices])
  show outline.entry: it => context {
    show link: set text(fill: black)
    block(inset: (y: 3pt), link(it.element.location(),
      it.indented(it.prefix(), it.inner())))
  }
  outline(title: none, target: heading.where(level: 1, numbering: "A.1"))
}

#let sources(path) = {
  unnumbered([References])
  context {
    if query(cite).len() > 0 {
      bibliography(path, title: none, style: "ieee")
    } else {
      placeholder([Add sources to references.bib and cite them in the text.])
    }
  }
}
