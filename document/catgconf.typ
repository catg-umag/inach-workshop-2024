#import "@preview/octique:0.1.0": *


#let catg-colors = (
  red: rgb("ee273f"),
  blue: rgb("1889c6"),
  green: rgb("0aa55b"),
  yellow: rgb("f8a216"),
)

#let conf(
  title: none,
  authors: (),
  doc,
) = {
  set document(
    title: title,
    author: authors,
  )

  set text(font: "Lato", lang: "es", size: 9.5pt)
  set par(justify: true)
  show raw: set text(font: ("Hack", "mono"))

  set page(
    paper: "us-letter",
    margin: (top: 2.3cm, right: 2cm, bottom: 2.3cm, left: 2cm),
    numbering: "1 of 1",
    header: context [
      #set text(fill: gray, size: 0.9em)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [Oxford Nanopore Data Analysis], emph(authors.join(" & ")),
      )
    ],
    footer: context [
      #set text(fill: gray, size: 0.9em)

      #align(
        right,
        stack(
          dir: ltr,
          rect(fill: catg-colors.red, width: 2.5cm, height: 0.15cm),
          rect(fill: catg-colors.blue, width: 2.5cm, height: 0.15cm),
          rect(fill: catg-colors.green, width: 2.5cm, height: 0.15cm),
          rect(fill: catg-colors.yellow, width: 2.5cm, height: 0.15cm),
        ),
      )
      #align(center, counter(page).display("1 / 1", both: true))
    ],
  )

  // Heading
  set heading(numbering: "1.1")

  show heading: it => {
    set text(
      size: if it.level == 1 {
        1em
      } else {
        0.9em
      },
      weight: "regular",
      fill: catg-colors.blue,
    )
    block(
      above: 1.5em,
      inset: (bottom: 0.3em),
      [
        #if (it.numbering != none) [
          #counter(heading).display(it.numbering) #h(4pt) | #h(4pt) 
        ]
        #it.body
      ],
    )
  }

  // Caption
  show figure.caption: c => [
    #set text(size: 0.9em)

    #text(weight: "bold")[
      #c.supplement.text #c.counter.display(c.numbering).
    ]
    #c.body
  ]

  // Table
  show table.cell: set text(size: 0.9em)
  show table.cell.where(y: 0): set text(fill: white)
  let frame(stroke) = (
    (x, y) => (
      left: if x == 0 { stroke } else { 0pt },
      right: stroke,
      top: if y < 2 { stroke } else { 0pt },
      bottom: stroke,
    )
  )
  set table(
    stroke: frame(rgb("#418dc0") + 0.7pt),
    fill: (_, y) => if y == 0 { rgb("#418dc0") },
  )

  show link: set text(fill: rgb("#144e6e"))

  doc
}

#let cmd(content) = {
  show: box.with(
    fill: rgb("#ebf3f4"),
    inset: (x: 2pt, y: 0pt),
    outset: (x: 0pt, y: 3pt),
    radius: 2pt,
  )
  content
}

#let pill(content, fill: gray) = {
  set text(weight: "regular", size: 8pt)
  show: box.with(fill: fill, inset: (x: 0.4em, y: 0.3em), outset: 1pt, radius: 3pt, clip: true)
  content
}

#let github-pill(repo) = {
  set text(fill: white)
  show link: this => text(this, fill: white)
  pill(
    link("https://github.com/" + repo)[
      #grid(
        columns: 2,
        column-gutter: 5pt,
        align: horizon,
        octique("mark-github", color: white, width: 0.85em), repo,
      )
    ],
    fill: rgb("#596882"),
  )
}

#let article-pill(doi) = {
  set text(fill: white)
  show link: this => text(this, fill: white)
  pill(
    link("https://doi.org/" + doi)[
      #grid(
        columns: 2,
        column-gutter: 5pt,
        align: horizon,
        octique("log", color: white, width: 0.85em), doi,
      )
    ],
    fill: rgb("#7f55a1"),
  )
}