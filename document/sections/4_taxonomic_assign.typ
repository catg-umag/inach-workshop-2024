#import "../catgconf.typ": cmd, github-pill, doi-pill

= Asignación taxonómica

== NanoCLUST
#github-pill("genomicsITER/NanoCLUST") #h(3pt) #doi-pill("10.1093/bioinformatics/btaa900") \
NanoCLUST es un flujo de trabajo desarrollado en Nextflow para la clasificación de amplicones del gen 16S obtenidos mediante secuenciación por Nanopore. Utiliza un enfoque de clustering no supervisado seguido por una proyección UMAP y una corrección de errores de cada cluster previo a la asignación taxonómica. Para la asignación taxonómica utiliza BLAST y la base de datos de 16S de Genbank.

Para utilizar esta herramienta se debe contar con una versión de Nextflow menor o igual a 22.04 y se debe descargar la base de datos de 16S de Genbank (instrucciones en el repositorio de NanoCLUST).
```sh
nextflow run main.nf \ 
    -profile docker \ 
    --reads 'sample.fastq' \ 
    --db "db/16S_ribosomal_RNA" \ 
    --tax "db/taxdb/"
```

== EMU
#github-pill("https://github.com/treangenlab/emu") #h(3pt) #doi-pill("10.1038/s41592-022-01520-4")

EMU es una herramienta diseñada para mejorar la precisión de la asignación taxonómica mediante una corrección de errores utilizando un enfoque basado en algoritmos de maximización de expectativas y alineamiento de las secuencias corregidas mediante la herramienta Minimap2. Ofrece compatibilidad con diversas bases de datos, como Genbank, RDP y Silva (v.138). Además, en el caso de realizar análisis de la región ITS, permite integrar las base de datos de UNITE que se especializa en taxonomía de hongos y eucariotas.

Para utilizar EMU se debe descargar su base de datos e instalar las dependencias necesarias (instrucciones de instalación en el repositorio de EMU).
```sh
emu abundance example/full_length.fa
```

== EPI2ME wf-16S
#github-pill("epi2me-labs/wf-16s") \
Pipeline bioinformático desarrollado por EPI2ME-Labs. Cuenta con dos enfoques para la asignación taxonómica: Alineamiento de secuencias mediante Minimap2, o asignación taxonómica basada en k-mers mediante Kraken2 (y bracken2 para la corrección). Permite utilizar tanto la base de datos de SILVA (versión 138) como la base de datos de Genbank de 16S y 18S.

Por defecto filtra las lecturas por tamaño (entre 800pb y 2000pb) y no realiza filtros por calidad.
Para considerar una asignación taxonómica exige un porcentaje de identidad de 95 % y una cobertura de 90%.
Todos estos parámetros pueden ser modificados por el usuarios.

El resultado es un archivo en formato tabular (TSV) que contiene la información de la asignación taxonómica por cada muestra, detallando la cantidad de lecturas asignadas a cada categoría taxonómica. 
Adicionalmente, genera un reporte en formato HTML que integra la información de asignación taxonómica, calidad de la secuenciación y métricas de diversidad por muestra.


Por defecto el pipeline realiza la asignación taxonómica con la herramienta Minimap2 y la base de datos de 16S de Genbank. Para cambiar la herramienta de clasificación, utiliza el parámetro `--classifier`, eligiendo entre `kraken2` y `minimap2`. Para seleccionar una base de datos diferente, usa el parámetro `--database_set`, con alguna de las siguientes opciones: `ncbi_16s_18s`, `ncbi_16s_18s_28s_ITS` y `SILVA_138_1`.

Puede ejecutarse mediante la interfaz de línea de comandos o mediante una aplicación de escritorio.

=== Mediante aplicación de escritorio

=== Mediante línea de comando

Para ejecutarlo mediante línea de comando solamente se debe contar con Nextflow ya que las bases de datos se van a descargar automáticacamente. Ejemplo de uso:
```sh
 nextflow run epi2me-labs/wf-16s \
     --classifier kraken2 --database_set SILVA_138_1 \
     --sample_sheet samples.csv \
     --taxonomic_rank G --fastq data  \
     --out_dir wf-16s_minimap_ncbi \
     -profile singularity -resume
```

==== Estructura del archivo de muestras
El pipeline requiere un archivo de muestras en formato CSV que contenga la información de las muestras y los barcodes asociados.

Podemos generar el arhivo mediante un editor de textos:
```
barcode,sample_id,alias
barcode01,1M,1M
barcode06,4H,4H
barcode08,5H,5H
barcode10,6H,6H
barcode11,6M,6M
barcode12,7H,7H
barcode13,7M,7M
```

Al visualizar el archivo en un procesador de hojas de cálculo, se vería de la siguiente manera:
#align(
  center,
  table(
    columns: 3,
    align: (left, center, left),
    table.header([barcode], [sample_id], [alías]),
    [barcode01], [1M], [1M],
    [barcode06], [4H], [4H],
    [barcode08], [5H], [5H],
    [barcode10], [6H], [6H],
    [barcode11], [6M], [6M],
    [barcode12], [7H], [7H],    
    [barcode13], [7M], [7M],
  ),
)

==== Estructura del directorio

Este pipeline esta pensando para ser ejecutado luego de la etapa de basecalling, por lo que se espera que los archivos FASTQ estén en la carpeta correspondiente de cada barcode. Cada carpeta de los barcodes a analizar debe encontrarse dentro de la carpeta que se indicara con el parámetro `--fastq`. La estructura del directorio debe ser la siguiente:
 
 ```
─── input_directory
        ├── barcode01
        │   └── reads0.fastq
        ├── barcode02
        │   └── reads0.fastq
        └── barcode03
            └── reads0.fastq
 ```



==  Eliminación de especies poco abundantes y normalización por muestra

Una práctica común en el análisis de datos de microbioma es la eliminación de especies poco abundantes, ya que estas pueden representar ruido en los análisis afectando la interpretación de los resultados.

Para esto, se puede establecer un umbral de abundancia mínima, eliminando las especies que no cumplen con este criterio. En este caso, eliminaremos todos los taxones que no cumplan con un umbral de abundancia del 0.1% en alguna muestra. También eliminaremos las lecturas que no lograron clasificarse, esto lo haremos mediante R:

```R
count_data_filtered <- count_data %>%
    column_to_rownames("tax") %>%
    filter_all(any_vars(. / sum(.) > 0.0001))  %>%
    select(-total,-starts_with("Unclassified")) %>%
```

==  Normalización por muestra

// https://scienceparkstudygroup.github.io/microbiome-lesson/05-data-filtering-and-normalisation/index.html

// https://anf-metabiodiv.github.io/course-material/courses/beta_diversity.pdf

Muchas veces la cantidad de lecturas varía significativamente entre las muestras, y eso hace que los conteos obtenidos en la asignación taxonómica varien de manera notoria. Es por esto, que se hace necesario normalizar los datos para poder comparar las diferentes muestras. La normalización de los datos se realiza para corregir el sesgo en la abundancia de las especies debido a la cantidad de secuencias generadas por muestra. 
El objetivo de la normalización es tener el mismo tamaño de librería para todas las muestras.

Esto se puede hacer mediante varias metodologías: normalización por submuestreo utilizando un tamaño mínimo; escalamiento donde se divide cada abundancia por un factor para eliminar el sesgo de muestreo desigual, etc

Utilizaremos una normalización por XXX mediante la función #cmd(`decostat`) de la librería vegan en R.

```R
data_normalized <- decostand(count_data_filtered, method = "total")
```


//https://scienceparkstudygroup.github.io/microbiome-lesson/05-data-filtering-and-normalisation/index.html