#import "@preview/codly:1.0.0": *
#import "@preview/gentle-clues:0.9.0": *
#import "catgconf.typ": conf, catg-colors

#show: doc => conf(
  title: "Oxford Nanopore Data Analysis",
  authors: ("Diego Alvarez S.", "Jacqueline Aldridge A."),
  doc,
)

#show: codly-init.with()
#show: gentle-clues.with(
  header-inset: 5pt,
  border-radius: 3pt,
)

#codly(
  number-format: none,
  zebra-fill: none,
  fill: rgb("f9f9f9"),
)

#include "sections/1_basecalling.typ"

