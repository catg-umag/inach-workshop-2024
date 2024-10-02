#import "@preview/gentle-clues:0.9.0": *
#import "../catgconf.typ": cmd, github-pill, doi-pill


= Control y Filtros de Calidad

El control de calidad es una fase fundamental en el análisis de datos de secuenciación, especialmente en tecnologías de tercera generación debido a su mayor tasa de error. Entre las tareas más comunes de esta etapa se incluyen la eliminación de secuencias de baja calidad, eliminación de adaptadores, filtro de secuencias cortas y descontaminación.

La calidad de las lecturas se codifica en los archivos FASTQ generados por los dispositivos de secuenciación, y en el caso de Oxford Nanopore son resultado del proceso de basecalling. Contienen tanto la información de la secuencia como la calidad asociada a cada base. Un ejemplo de lectura en formato FASTQ se presenta a continuación:

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
FastQC es una herramienta ampliamente utilizada para realizar el control de calidad de datos de secuenciación. Permite evaluar la calidad de las secuencias, identificar adaptadores, secuencias repetitivas y otros problemas comunes. Los resultados de las métricas evaluadas son presentadas en un reporte en formato HTML.

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
Nanoq es una herramienta para realizar control y filtros de calidad diseñada para trabajar con datos de Oxford Nanopore.

#heading([Control de calidad], level: 3, numbering: none)

Para obtener métricas de calidad se utiliza el parámetro #cmd(`-s / --stats`). Esto genera una tabla con cantidad de secuencias, número total de bases, tamaño y calidad promedio. Se puede usar #cmd(`--report`) para guardar la información generada en un archivo. Existen opciones que permiten obtener información adicional, las cuales son:
- #cmd(`-v`) : Información básica en formato extendido.
- #cmd(`-vv`): Similar a #cmd(`-v`), pero incluye una compartimentación de la calidad y tamaño de las secuencias.
- #cmd(`-vvv`): Similar a #cmd(`-vv`), pero incluye un ranking de las cinco secuencias con mejor calidad y mayor largo.

El archivo de entrada debe indicarse mediante el parámtero #cmd(`-i / --input`).

Ejemplo de uso para control de calidad:
```sh
nanoq -i barcode01.fastq.gz -svv -r bacorde01_stats.txt
```

#heading([Filtros de calidad], level: 3, numbering: none)

Al usar nanoq para realizar filtros de calidad, los parámetros más relevantes son #cmd(`--min-len / -l`), #cmd(`--max-len / -m`), #cmd(`--min-qual / -q`) y #cmd(`--max-qual / -w`). Mediante el parámetro #cmd(`--output / -o`) se indica el archivo que va a almacenar los datos filtrados.

En el siguiente ejemplo se filtra con calidad mínima 15 y tamaño entre 1.000 y 2.000 pares de bases:
```sh
nanoq -i barcode01.fastq.gz -q 15 -l 1000 -m 2000 -o barcode01_filtered.fastq.gz
```

Al usar filtros de calidad, se puede utilizar la opción `--report` para generar el reporte de estadísticas del archivo filtrado:
```sh
nanoq --input barcode01.fastq.gz --output barcode01_filtered.fastq.gz \
      --min-qual 15 --min-len 1000 --max-len 2000 \
      -vv --report barcode01_filtered_stats.txt
```

== MultiQC
#github-pill("MultiQC/MultiQC") \
MultiQC permite presentar resultados de reportes de múltiples herramientas y múltiples muestras en un único reporte HTML. Soporta un gran cantidad herramientas bioinformáticas como FastQC, nanoq, fastp, cutadapt y NanoPlot. La lista de herramientas soportadas se puede encontrar en la sección #link("https://multiqc.info/docs/#multiqc-modules")[MultiQC modules] de la documentación.

MultiQC requiere como argumento el directorio donde se encuentren los reportes generados por las herramientas. Si se indica #cmd(`.`), MultiQC buscará los reportes en el directorio actual. Ejemplo:
```sh
multiqc reports/
```

Por defecto el nombre del reporte será `multiqc_report.html`, pero se puede indicar con #cmd(`--filename`):
```sh
multiqc --filename multiqc_raw.html reports/
```
