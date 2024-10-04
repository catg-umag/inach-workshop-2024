#import "@preview/gentle-clues:1.0.0": *
#import "../catgconf.typ": cmd, github-pill, doi-pill

= Asignación Taxonómica

== NanoCLUST
#github-pill("genomicsITER/NanoCLUST") #h(3pt) #doi-pill("10.1093/bioinformatics/btaa900")

NanoCLUST es un flujo de trabajo desarrollado en Nextflow para la clasificación de amplicones del gen 16S obtenidos mediante secuenciación por Nanopore. Utiliza un enfoque de clustering no supervisado seguido por una proyección UMAP y una corrección de errores de cada cluster previo a la asignación taxonómica. Para la asignación taxonómica utiliza BLAST y la base de datos de 16S de Genbank.

Para utilizar esta herramienta se debe contar con una versión de Nextflow menor o igual a 22.04 y se debe descargar la base de datos de 16S de Genbank (instrucciones disponibles en el repositorio de NanoCLUST).
```sh
nextflow run main.nf \
    -profile docker \
    --reads 'sample.fastq' \
    --db "db/16S_ribosomal_RNA" \
    --tax "db/taxdb/"
```

#pagebreak()

== EMU
#github-pill("treangenlab/emu") #h(3pt) #doi-pill("10.1038/s41592-022-01520-4")

EMU es una herramienta diseñada para mejorar la precisión de la asignación taxonómica mediante un enfoque de corrección de errores basado en algoritmos de maximización de expectativas y alineamiento de las secuencias corregidas mediante la herramienta Minimap2. EMU es compatible con diversas bases de datos, como Genbank, RDP y Silva (v.138), y también permite la integración de la base de datos UNITE para el análisis de la región ITS, especializada en la taxonomía de hongos y eucariotas.

Para usar EMU, es necesario descargar su base de datos e instalar las dependencias (instrucciones en el repositorio de EMU).
```sh
emu abundance example/full_length.fa
```

== EPI2ME wf-16s
#github-pill("epi2me-labs/wf-16s")

EPI2ME wf-16s es un pipeline bioinformático desarrollado por Oxford Nanopore para la asignación taxonómica de secuencias 16S. Ofrece dos alternativas para la clasificación taxonómica: alineamiento de secuencias mediante Minimap2 o asignación basada en k-mers utilizando Kraken2 y Bracken2. El pipeline permite utilizar bases de datos como SILVA (v.138) y las de 16S y 18S de Genbank.

El resultado incluye un archivo en formato tabular (TSV) con la asignación taxonómica por muestra, especificando el número de lecturas asignadas a cada taxón. También se genera un reporte en formato HTML que integra la información sobre la calidad de la secuenciación, asignación taxonómica y métricas de diversidad.

Este pipeline puede ejecutarse mediante la línea de comandos con Nextflow o mediante la aplicación de escritorio EPI2ME (https://labs.epi2me.io/).

=== Requisitos

Para ejecutar el pipeline, es necesario tener instalados #link("https://www.nextflow.io/")[Nextflow] y #link("https://www.docker.com/")[Docker] (o como alternativa, #link("https://apptainer.org/")[Apptainer]). El pipeline descarga automáticamente las bases de datos necesarias y todas las dependencias para su ejecución.

#question(title: "¿Qué es Nextflow?")[
  Nextflow es un framework para diseñar y ejecutar pipelines bioinformáticos. Utiliza un lenguaje declarativo para definir flujos de trabajo, que pueden ejecutarse de manera reproducible en entornos locales, en la nube o en clústeres de alto rendimiento.
]

#heading([Estructura del archivo de muestras], level: 4, numbering: none)

El pipeline requiere un archivo CSV que contenga la información de las muestras y los códigos de barras (barcodes) asociados. A continuación se muestra un ejemplo de este archivo:

#context [
  #set text(size: 0.9em)
  #figure(
    grid(
      columns: (6cm, 6cm),
      align: (center, center),
      column-gutter: 1em,
      row-gutter: 1em,
      ```
      barcode,sample_id,alias
      barcode01,1M,1M
      barcode06,4H,4H
      barcode08,5H,5H
      barcode10,6H,6H
      barcode11,6M,6M
      barcode12,7H,7H
      barcode13,7M,7M
      ```,
      table(
        columns: 3,
        inset: (y: 3.5pt),
        align: (left, center, left),
        table.header([barcode], [sample_id], [alias]),
        [barcode01], [1M], [1M],
        [barcode06], [4H], [4H],
        [barcode08], [5H], [5H],
        [barcode10], [6H], [6H],
        [barcode11], [6M], [6M],
        [barcode12], [7H], [7H],
        [barcode13], [7M], [7M],
      ),

      [
        Contenido del archivo.
      ],
      [
        Representación del archivo como una tabla.
      ],
    ),
  )
]

#heading([Estructura de los datos de entrada], level: 4, numbering: none)

El pipeline está diseñado para ejecutarse después de la etapa de basecalling. Se espera que los archivos FASTQ estén organizados por barcode en directorios correspondientes, como se muestra a continuación:
```
input_directory
├── barcode01
│   ├── reads0.fastq
│   └── reads1.fastq
├── barcode02
│   └── reads0.fastq
└── barcode03
    └── reads0.fastq
```

=== Configuración

Este pipeline incluye múltiples parámetros configurables mediante parámetros de línea de comandos si se ejecuta mediante Nextflow, o mediante opciones gráficas si se utiliza la aplicación de escritorio EPI2ME.

Por defecto, las lecturas son filtradas por tamaño entre 800 pb y 2000 pb y no se aplican filtros de calidad. El porcentaje de identidad requerido para la asignación taxonómica es del 95% y la cobertura del 90%.

El pipeline utiliza Minimap2 con la base de datos de 16S de Genbank de forma predeterminada. Para el método de clasificación se puede escoger entre `kraken2` y `minimap2`, mientras que para la base de datos las opciones son `ncbi_16s_18s`, `ncbi_16s_18s_28s_ITS` y `SILVA_138_1`.

=== Ejecución mediante aplicación de escritorio

La aplicación EPI2ME permite ejecutar diversos pipelines de análisis de datos de secuenciación de Oxford Nanopore. En este caso, debemos seleccionar el pipeline 16s e iniciar su instalación. La aplicación verificará si el equipo cumple con los requisitos computacionales y descargará el pipeline en un directorio local.

#context [
  #set text(size: 0.9em)
  #figure(
    grid(
      align: horizon,
      columns: (8cm, 7.5cm),
      gutter: 0.5em,
      image("../images/16_pipeline.png"), image("../images/pipeline_install.png"),
      [Selección del pipeline 16s en la aplicación EPI2ME.], [Cuadro de instalación del pipeline.],
    ),
  )
]

Una vez instalado, el botón #cmd([Install]) cambiará a #cmd([Launch]). Al hacer clic en #cmd([Launch]), se abrirán las opciones de configuración del pipeline, donde seleccionaremos el directorio con los archivos de entrada, la base de datos, el método de clasificación, la planilla de muestras y otros parámetros (@fig:pipeline-config).

#figure(
  placement: auto,
  image("../images/pipeline_config.png", width: 90%),
  caption: [Configuración del pipeline EPI2ME wf-16s.],
) <fig:pipeline-config>

Al finalizar la ejecución, podremos visualizar el reporte generado en la misma aplicación y acceder al directorio con los resultados.

=== Ejecución mediante línea de comandos

Para ejecutar el pipeline mediante la línea de comandos, debe especificarse como mínimo los datos de entrada con el parámetro #cmd(`--fastq`). Para configurar el clasificador debe utilizarse el parámetro #cmd(`--classifier`), y para configurar la base de datos se utiliza el parámetro #cmd(`--database_set`).

Ejemplo de uso:
```sh
 nextflow run epi2me-labs/wf-16s \
    --fastq data \
    --sample_sheet samples.csv \
    --out_dir wf-16s_kraken2_silva \
    --classifier kraken2 \
    --database_set SILVA_138_1 \
    --taxonomic_rank G \
    -profile docker
```

#pagebreak()

= Post Procesamiento de Asignación Taxonómica

== Eliminación de especies poco abundantes

En el análisis de datos de microbioma, es común eliminar especies poco abundantes, ya que pueden introducir ruido y afectar la interpretación de los resultados. Se puede establecer un umbral de abundancia mínima y eliminar los taxones que no lo cumplan.

Por ejemplo, podemos eliminar todos los taxones cuya abundancia sea inferior al 0.1% en todas las muestras. Adicionalmente, podemos excluir las lecturas no clasificadas. Todo esto podemos lograrlo con el siguiente código en R:

```R
library(tidyverse)

count_data_filtered <- count_data %>%
    column_to_rownames("tax") %>%
    filter_all(any_vars(. / sum(.) > 0.0001))  %>%
    select(-total, -starts_with("Unclassified"))
```

== Normalización por muestra
Es común que la cantidad de lecturas varíe significativamente entre las muestras, lo que provoca que los conteos obtenidos en la asignación taxonómica presenten grandes variaciones. Para comparar las muestras de manera justa, es necesario normalizar los datos y corregir el sesgo en la abundancia de especies debido a estas diferencias.

Existen diversas metodologías para normalizar: el submuestreo utilizando un tamaño mínimo, el escalamiento dividiendo cada abundancia por un factor para compensar el sesgo de muestreo, entre otras.

Por ejemplo, podemos normalizar mediante Total Sum Scaling (TSS), usando la función #link("https://vegandevs.github.io/vegan/reference/decostand.html")[#cmd(`decostand`)] de la librería vegan en R.

```R
data_normalized <- decostand(count_data_filtered, method = "total")
```