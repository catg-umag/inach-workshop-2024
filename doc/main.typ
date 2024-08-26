#import "@preview/codly:1.0.0": *
#import "@preview/gentle-clues:0.9.0": *

#let catg-colors = (
	red: rgb("ee273f"),
	blue: rgb("1889c6"),
	green: rgb("0aa55b"),
	yellow: rgb("f8a216")
)

#set text(font: "Lato", lang: "en", size: 11pt)
#show raw: set text(font: "Hack")
#set page(
  paper: "us-letter",
	margin: (top: 2.5cm, right: 2cm, bottom: 2.5cm, left: 2cm),
  numbering: "1 of 1",
	header: context [
		#set text(fill: gray, size: 10pt)
		#grid(
			columns: (1fr, 1fr),
			align: (left, right),
			[Oxford Nanopore Data Analysis],
			emph("Diego Alvarez & Jacqueline Aldridge")
		)
	],
	footer: context [
		#set text(fill: gray, size: 10pt)

		#align(
			right,
			stack(
				dir: ltr,
				rect(fill: catg-colors.red, width: 2.5cm, height: 0.15cm),
				rect(fill: catg-colors.blue, width: 2.5cm, height: 0.15cm),
				rect(fill: catg-colors.green, width: 2.5cm, height: 0.15cm),
				rect(fill: catg-colors.yellow, width: 2.5cm, height: 0.15cm),
			)
		)
		#align(center, counter(page).display("1 / 1", both: true))
	]
)
#set heading(numbering: "1.1")

#show: codly-init.with()
#show: gentle-clues.with(
	header-inset: 5pt,
	border-radius: 3pt
)

#codly(
  number-format: none,
  zebra-fill: none,
	fill: rgb("f9f9f9"),
  languages: (
    bash: (
      name: "Bash",
    )
  )
)


#include "sections/1_basecalling.typ"

