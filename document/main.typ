#import "@preview/codly:1.0.0": *
#import "@preview/gentle-clues:0.9.0": *
#import "catgconf.typ": conf, catg-colors


#show: doc => conf(
  title: "Análisis de Datos de Oxford Nanopore",
  authors: ("Diego Alvarez S.", "Jacqueline Aldridge A."),
  date: "Octubre 2024",
  doc,
)

#show: codly-init.with()
#show: gentle-clues.with(
  header-inset: 4pt,
  content-inset: 6pt,
  border-radius: 3pt,
)

#codly(
  number-format: none,
  zebra-fill: none,
  fill: rgb("#f1f5f6"),
  stroke: rgb("#f1f5f6") + 2pt,
)

// title page
#{
  v(1cm)

  grid(
    columns: 4,
    column-gutter: 1em,
    align: bottom,
    image("images/logo_catg.svg", height: 2cm),
    image("images/logo_umag.svg", height: 1.4cm),
    h(1fr),
    image("images/logo_inach.svg", height: 1.3cm),
  )

  v(4.5cm)

  [
    #set align(center)
    #[
      #set text(size: 1.85em, style: "italic", fill: rgb("2C3E50"))
      Descifrando el Microbioma del Tracto Digestivo del Krill Antártico: \ Aplicando el Flujo de Trabajo MinION
    ]

    #line(length: 85%, stroke: 1pt + catg-colors.blue)

    #[
      #set text(size: 1.3em, fill: rgb("708090"))
      Taller de Análisis de Datos de Oxford Nanopore
    ]

    #v(6cm)

    #[
      #set text(size: 1.1em, fill: rgb("#929eaa"))
      Jacqueline Aldridge A.
      #[
        #set text(fill: rgb("#186b97"))
        [jacqueline.aldridge\@umag.cl]
      ]
      #v(0em)
      Diego Alvarez S.
      #[
        #set text(fill: rgb("#186b97"))
        [diego.alvarez\@umag.cl]
      ]
    ]

    #v(1fr)

    #[
      #set text(size: 1.1em, fill: rgb("929eaa"))
      Punta Arenas, Chile #h(0.5em) / #h(0.5em) Octubre 2024
    ]

    #v(1cm)
  ]

  pagebreak()
}

#context [
  #set par(leading: 1em)
  #show outline.entry.where(level: 1): it => {
    set text(fill: catg-colors.blue)
    v(12pt, weak: true)
    it
  }
  #outline(
    title: "Contenido",
    indent: auto,
    depth: 2,
    fill: repeat([
      #set text(size: 0.5em)
      . #h(3pt)
    ]),
  )

  #v(1fr)
  Repositorio del workshop: https://github.com/catg-umag/inach-workshop-2024
]

#pagebreak()

#include "sections/1_working_env.typ"
#include "sections/2_basecalling.typ"
#include "sections/3_quality.typ"
#include "sections/4_taxonomic_assignment.typ"
#include "sections/5_diversity.typ"
