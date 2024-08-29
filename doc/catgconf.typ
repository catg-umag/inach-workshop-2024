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

  set text(font: "Lato", lang: "es", size: 10.5pt)
  set par(justify: true)
  show raw: set text(font: "Hack")

  set page(
    paper: "us-letter",
    margin: (top: 2.5cm, right: 2cm, bottom: 2.5cm, left: 2cm),
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
      #set text(fill: gray, size: 0.8em)

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
        #counter(heading).display(it.numbering) #h(4pt) | #h(4pt) #it.body
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
  show table.cell: set text(size: 0.95em)
  show table.cell.where(y: 0): set text(weight: "bold")
  let frame(stroke) = (
    (x, y) => (
      left: none,
      right: none,
      top: if y < 2 {
        stroke
      } else {
        0pt
      },
      bottom: stroke,
    )
  )
  set table(
    stroke: frame(rgb("21222C") + 0.8pt),
  )

  show link: set text(fill: rgb("#144e6e"))

  doc
}