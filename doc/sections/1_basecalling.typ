#import "@preview/gentle-clues:0.9.0": *


= Basecalling

Basecalling es el proceso por el cual se convierte la señal eléctrica captada por los dipositivos de Oxford Nanopore en secuencias de nucleótidos. Lograr esta conversión requiere de algoritmos computacionales avanzados, como las redes neuronales LSTM y los transformers utilizados por las opciones de basecalling actuales. Este proceso es crucial porque define la calidad de los datos, lo que afectará directamente la calidad de los análisis posteriores.

A lo largo de los años, Oxford Nanopore ha desarrollado distintos basecallers, haciendo uso de distintas tecnologías. El basecaller actual es #link("https://github.com/nanoporetech/dorado")[Dorado]#footnote("https://github.com/nanoporetech/dorado"), el cual se puede utilizar mediante línea de comandos. Adicionalmente, está integrado en MinKNOW.


== Precisión del basecalling

Dorado cuenta con múltiples modelos de basecalling, cada uno con diferentes equilibrios entre precisión y capacidad de cómputo requerida para su ejecución. Actualmente, los modelos disponibles son:



#align(
  center,
  table(
    columns: 3,
    align: (left, center, left),
    table.header(
      [Modelo],
      [Precisión Simplex],
      [Requerimientos computacionales],
    ),

    [fast \[`fast`\]], [95.5%], [],
    [high accuracy \[`hac`\]], [99.25%], [],
    [super accuracy \[`sup`\]], [99.75%], [],
  ),
)

#figure(
  image("../images/raw_accuracy.png", width: 75%),
  caption: [
    Precisión actual de los modelos de basecalling de Oxford Nanopore, usando el Kit V14 y celdas R10.4.1 de PromethION en secuenciación de genoma humano. Fuente: #link("https://nanoporetech.com/es/platform/accuracy")[nanoporetech.com/es/platform/accuracy].
  ],
)

