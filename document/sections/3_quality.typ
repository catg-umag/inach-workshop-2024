#import "@preview/gentle-clues:0.9.0": *
#import "../catgconf.typ": cmd, github-pill, doi-pill


= Control y Filtros de Calidad

El control de calidad es una fase fundamental en el análisis de datos de secuenciación, especialmente en tecnologías de tercera generación debido a su mayor tasa de error. Entre las tareas más comunes de esta etapa se incluyen la eliminación de secuencias de baja calidad, la remoción de adaptadores, la filtración de secuencias cortas y la descontaminación.

La calidad de las lecturas se codifica en los archivos FASTQ generados por los dispositivos de secuenciación. En el caso de Oxford Nanopore, estos archivos, resultado del proceso de basecalling, contienen tanto la información de la secuencia como la calidad asociada a cada base. Un ejemplo de lectura en formato FASTQ se presenta a continuación:

#figure(
  ```
    @NB551068:9:HK5NLBGXX:1:11101:12901:1044 1:N:0:ATCACG
    GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCGTCTGAGGCTGCTGAACCGCTCTTCCGATCTTCTGCTTGAAA
    +
    IIIIHHHHHHHHHGGGGGGGGGGFFFFFEEEEEEEEDDDDDCCCCCCCBBBBBBBBBAAAAAAAA@@@@@@@######
  ```,
  caption: [
    Ejemplo de lectura en formato FASTQ. La primera línea contiene el identificador de la secuencia, la segunda línea la secuencia de nucleótidos, la tercera línea un carácter `+` y la cuarta línea la calidad de la secuencia.
  ]
) <fastq_example>

Los valores de calidad Q-Score están codificados en formato ASCII, donde cada carácter corresponde a un valor numérico. A partir de este valor, es posible calcular la probabilidad de error asociada a la base utilizando la fórmula $P = 10^frac(-Q,10)$, donde $Q$ representa el Q-Score. En la siguiente tabla se presentan las equivalencias entre los códigos ASCII y los Q-Scores:

#context [
  #show table.cell: set text(size: 0.85em)
  #figure(
    grid(
      columns: 3,
      align: (center, center, center),
      gutter: 10pt,
      table(
        columns: 4,
        align: (center, center, center, center),
        inset: 4pt,
        table.header([Símbolo], [Código ASCII], [Q-Score], [Precisión]),
        [!], [33], [0], [0%],
        [\"], [34], [1], [20%],
        [\#], [35], [2], [36.9%],
        [\$], [36], [3], [50%],
        [%], [37], [4], [60%],
        [&], [38], [5], [68.4%],
        ['], [39], [6], [75%],
        [(], [40], [7], [80%],
        [)], [41], [8], [84.1%],
        [\*], [42], [9], [87.5%],
        [+], [43], [10], [90%],
        [,], [44], [11], [92.1%],
        [-], [45], [12], [93.7%],
        [.], [46], [13], [95%],
      ),
      table(
        columns: 4,
        align: (center, center, center, center),
        inset: 4pt,
        table.header([Símbolo], [Código ASCII], [Q-Score], [Precisión]),
        [/], [47], [14], [96%],
        [0], [48], [15], [96.8%],
        [1], [49], [16], [97.5%],
        [2], [50], [17], [98%],
        [3], [51], [18], [98.4%],
        [4], [52], [19], [98.7%],
        [5], [53], [20], [99%],
        [6], [54], [21], [99.2%],
        [7], [55], [22], [99.4%],
        [8], [56], [23], [99.5%],
        [9], [57], [24], [99.6%],
        [:], [58], [25], [99.7%],
        [;], [59], [26], [99.8%],
        [<], [60], [27], [99.8%],
      ),
      table(
        columns: 4,
        align: (center, center, center, center),
        inset: 4pt,
        table.header([Símbolo], [Código ASCII], [Q-Score], [Precisión]),
        [=], [61], [28], [99.84%],
        [>], [62], [29], [99.87%],
        [?], [63], [30], [99.9%],
        [\@], [64], [31], [99.92%],
        [A], [65], [32], [99.94%],
        [B], [66], [33], [99.95%],
        [C], [67], [34], [99.96%],
        [D], [68], [35], [99.97%],
        [E], [69], [36], [99.98%],
        [F], [70], [37], [99.98%],
        [G], [71], [38], [99.99%],
        [H], [72], [39], [99.99%],
        [I], [73], [40], [99.99%],
      ),
    ),
    caption: [
      Codificación de calidad en archivos FASTQ para Q-Score 1 a 40.
    ],
  )
]


== FastQC
#github-pill("s-andrews/FastQC") \
FastQC es una herramienta ampliamente utilizada para realizar el control de calidad de datos de secuenciación. Permite evaluar la calidad de las secuencias, identificar adaptadores, secuencias repetitivas y otros problemas comunes en los datos de secuenciación. Los resultados de las métricas evaluadas son presentadas en un reporte en formato HTML.

Para ejecutar FastQC se debe indicar el o los archivos de entrada como argumentos al comandos. Otros parámetros relevantes son:
- #cmd(`--outdir / -o`): Almacena los reportes generados en un directorio específico (debe estar creado).
- #cmd(`--threads / -t`): Número de hilos a utilizar, lo que permite acelerar el proceso.
- #cmd(`--memory`): Cantidad de memoria RAM (en MB) a utilizar por hilo de ejecución.

A continuación se presentan algunos ejemplos de ejecución:
```sh
# Ejecuta FastQC en el archivo 'sample1.fastq.gz'
fastqc sample1.fastq.gz
# Ejecuta FastQC en múltiples archivos, con 4 hilos, almacenando los reportes en 'reports'
fastqc -t 4 -o reports/ sample1.fastq.gz sample2.fastq.gz
```

== nanoq
#github-pill("esteinig/nanoq") #h(3pt) #doi-pill("10.21105/joss.02991") \
Nanoq es una herramienta para realizar control y filtros de calidad específicamente desarrollada para trabajar con datos de Oxford Nanopore. Permite realizar tanto control de calidad como filtros de calidad en sí.

Para realizar control de calidad se debe indicar mediante el parámetro #cmd(`-v`) / #cmd(`--verbose`). Existen tres niveles de salida:
- #cmd(`-v`): Información básica (cantidad de secuencias, número total de bases, tamaño y calidad promedio).
- #cmd(`-vv`): Similar a #cmd(`-v`), pero incluye thresholds para la calidad y tamaño de las secuencias.
- #cmd(`-vvv`): Similar a #cmd(`-vv`) pero incluye un ranking de las cinco secuencias con mejor calidad y mayor largo.
Al utilizar la opción de salida -v se debe indicar donde se va a imprimir la información, si en la salida estándar #cmd(`-s`) o en nuevo archivo #cmd(`--report`).

El archivo de entrada debe indicarse mediante el parámtero #cmd(`-i / --input`). A continuación se presenta un ejemplo de control de calidad, donde la información se almacena en el archivo `bacorde01_stats.txt`:
```sh
nanoq -i barcode01.fastq.gz -vvs -r bacorde01_stats.txt
```

Nanoq ofrece diferentes parámetros que permiten realizar filtros de calidad, los más relevantes se presentan a continuación:
- #cmd(`--max-len / -m`): Tamaño máximo de las lecturas.
- #cmd(`--min-len / -l`): Tamaño mínimo de las lecturas.
- #cmd(`--max-qual / -w`): Calidad máxima para filtrar
- #cmd(`--min-qual / -q`): Calidad mínima para filtrar.

Mediante el parámetro `-o --output` se indica el archivo que va a almacenar los datos filtrados. A continuación se presenta un ejemplo de filtros de calidad utilizando como calidad mínima 15 y tamaño entre 1.000 y 2.000 pares de bases:
```sh
nanoq --input barcode01.fastq.gz --min-qual 15 --min-len 1000 --max-len 2000 --output barcode01_filtered.fastq.gz
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