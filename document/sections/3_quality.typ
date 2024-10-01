#import "@preview/gentle-clues:0.9.0": *
#import "../catgconf.typ": cmd


= Control de calidad y filtros

El control de calidad es una etapa crucial en el análisis de  datos de secuenciación, especialmente en el caso de las tecnologías de tercera generación que presentan un porcentaje de error más alto. 

Dentro de las tareas más comunes de esta etapa se encuentran la eliminación de secuencias de baja calidad, adaptadores, secuencias cortas, eliminación de contaminación, entre otras.

La calidad se encuentra codificada en los archivos FASTQ generados por los dispositivos de secuenciación, en el caso de Oxford Nanopore, por los programas de basecalling. Estos archivos contienen la información de la secuencia junto con la calidad de cada base secuenciada en cada lectura.

Una lectura en un archivo `FASTQ` luce de la siguiente manera:

#figure(
  image("../images/fq.png", width: 80%),
  caption: [
    Ejemplo de una lectura en un archivo FASTQ. 
  ],
)
La cuarta línea contiene la información de calidad de la secuencia, donde cada carácter ASCII tiene un `Q-score` asociado. Estas equivalencias se presentan en la tabla a continuación.

#figure(
  image("../images/illumina_fastq_coding.png", width: 80%),
  caption: [
    Codificación de calidad en archivos FASTQ.
  ],
)
Se puede calcula la probabilidad de error de una base a partir de su `Q-score` con la siguiente fórmula: `10^(-Q/10)`, en donde `Q` representa el puntaje de calidad (`Q-score`).
#align(
  center,
  table(
    columns: 3,
    align: (center, center, center),
    table.header([Puntaje de calidad \ (`q-score`)], [Probabilidad de error], [precisión]),
    [10], [1 en 10], [90%],
    [20], [1 en 100], [99%],
    [30], [1 en 1000], [99.9%],
    [40], [1 en 10000], [99.99%],
  ),
)
== FastQC


== Nanoq
Nanoq es una herramienta para realizar control y filtros de calidad específicamente desarrollada para trabajar con datos de Oxford Nanopore. 
Permite realizar tanto control de calidad como filtros de calidad en sí.

Para realizar control de calidad se debe indicar mediante el parámetro #cmd(`-v /--verbose`).  Existen tres niveles de salida:
- #cmd(`v`): Información básica (cantidad de secuencias, número total de bases, tamaño y calidad promedio).
- #cmd(`vv`): Similar a -v, pero incluye thresholds para la calidad y tamaño de las secuencias.
- #cmd(`vvv`): Similar a -vv pero incluye un ranking de las cinco secuencias con mejor calidad y mayor largo.

#cmd(`Nota`): Al utilizar la opción de salida -v se debe indicar donde se va a imprimir la información, si en la salida estándar #cmd(`-s`) o en nuevo archivo #cmd(`--report`).

El archivo de entrada debe indicarse mediante el parámtero `-i o --input`.  A continuación se presenta un ejemplo de control de calidad, donde la información se almacena en el archivo `bacorde01_stats.txt`:
```sh
nanoq -i barcode01.fastq.gz -vvs -r bacorde01_stats.txt
```

Nanoq ofrece diferentes parámetros que permiten realizar filtros de calidad, los más relevantes se presentan a continuación:
- #cmd(`--max-len (-m)`): Tamaño máximo de las lecturas.
- #cmd(`--min-len (-l)`): Tamaño mínimo de las lecturas.
- #cmd(`--max-qual (-w)`): Calidad máxima para filtrar
- #cmd(`--min-qual (-q)`): Calidad mínima para filtrar.

Mediante el parámetro `-o --output` se indica el archivo que va a almacenar los datos filtrados. A continuación se presenta un ejemplo de filtros de calidad utilizando como calidad mínima 15 y tamaño entre 1.000 y 2.000 pares de bases:
```sh
nanoq --input barcode01.fastq.gz  --min-qual 15 --min-len 1000 --max-len 2000  --output barcode01_filtered.fastq.gz
```
En caso de querer obtener las estádisticas del archivo filtrado se puede indicar que se almacene el resultado en un archivo de salida mediante el parámetro `-r o --report`.

```sh
nanoq --input barcode01.fastq.gz --min-qual 15 --min-len 1000 --max-len 2000  --output barcode01_filtered.fastq.gz -vv --report barcode01_filtered_stats.txt -H
```

== MultiQC
MultiQC es una herramienta que permite generar un único reporte de calidad a partir de reportes de múltiples herramientas y múltiples muestras. Soporta reportes de herramientas como FastQC, Nanoq, Fastp, cutadapt, NanoPlot entre otras. Una lista completa de las herramientas soportadas por MultiQC se pueden encontrar en al documentación oficial #link("https://multiqc.info/docs/#multiqc-modules")[MultiQC modules].

MultiQC necesita el directorio donde se encuentren los reportes generados por las herramientas, el cual puede indicarse inmediatamente luego del comando.
```sh
multiqc reports_directory
```
Se puede indicar el nombre del archivo mediante el parámetro #cmd(`--filename`), en caso de no indicarlo por defecto será `multiqc_report.html`. 

```sh
multiqc --filename multiqc_raw.html reports/
```

Se puede utilizar como shortcut el simbolo #cmd(`.`) para indicarle a multiqc que escanee el directorio actual y busque todos los reportes.
```sh
multiqc --filename multiqc_raw.html .
```