#import "@preview/gentle-clues:0.9.0": *

#import "../catgconf.typ": github-pill


= Basecalling

Basecalling es el proceso por el cual se convierte la señal eléctrica captada por los dipositivos de Oxford Nanopore en secuencias de nucleótidos. Esta conversión requiere de algoritmos computacionales avanzados, como las redes neuronales LSTM y los transformers utilizados por las opciones de basecalling actuales. Este proceso es crucial porque define la calidad de los datos, lo que afectará directamente los análisis posteriores.

Oxford Nanopore ha desarrollado múltiples basecallers a medida que ha habido avances tecnológicos. El basecaller actual es #link("https://github.com/nanoporetech/dorado")[Dorado], el cual se puede utilizar mediante línea de comandos. Adicionalmente, está integrado en MinKNOW.


== Precisión del basecalling

Dorado cuenta con múltiples modelos de basecalling, cada uno con diferentes equilibrios entre precisión y requerimientos computacionales. Actualmente, los modelos disponibles son:


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
  image("../images/raw_accuracy.png", width: 80%),
  caption: [
    Precisión actual de los modelos de basecalling de Oxford Nanopore, usando el Kit V14 y celdas R10.4.1 de PromethION para secuenciación de genoma humano. _Fuente: #link("https://nanoporetech.com/es/platform/accuracy")[nanoporetech.com/es/platform/accuracy]_.
  ],
)

Usar el modelo `sup` es la opción recomendada si se busca obtener la máxima precisión posible. Sin embargo, este modelo tiene un costo computacional tan elevado que se vuelve impráctico de usar sin hardware dedicado (GPU).


== Uso básico de Dorado
#github-pill("nanoporetech/dorado")

