#import "@preview/codly:1.0.0": *
#import "@preview/gentle-clues:0.9.0": *
#import "catgconf.typ": conf, catg-colors


#show: doc => conf(
  title: "Análisis de datos de Oxford Nanopore",
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
]

#pagebreak()

#include "sections/1_working_env.typ"
#include "sections/2_basecalling.typ"
#include "sections/3_quality.typ"
#include "sections/4_taxonomic_assignment.typ"
#include "sections/5_diversity.typ"
