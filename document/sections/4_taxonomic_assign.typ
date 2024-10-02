#import "../catgconf.typ": github-pill
#import "@preview/gentle-clues:0.9.0": *
#import "../catgconf.typ": cmd

= Asignación taxonómica

== NanoCLUST

== EMU

== EPI2ME wf-16S
#github-pill("epi2me-labs/wf-16s")

=== Mediante aplicación de escritorio

=== Mediante línea de comando

Pipeline bioinformático desarrollado por EPI2ME-Labs. Cuenta con dos enfoques para la asignación taxonómica: Alineamiento de secuencias mediante
Minimap2, o asignación taxonómica basada en `k-mers` mediante Kraken2. Permite utilizar tanto la base de datos de SILVA (versión 138) como la base de datos de Genbank de 16S y 18S.

En caso de utilizar Kraken2 se utiliza Bracken2 para la estimación de las abundancias.

El resultado es un archivo en formato tabular (TSV) que contiene la información de la asignación taxonómica por cada muestra, detallando la cantidad de lecturas asignadas a cada categoría taxonómica. 
Adicionalmente, genera un reporte en formato HTML que integra la información de asignación taxonómica, calidad de la secuenciación y métricas de diversidad por muestra.


Filtra las lecturas por tamaño (entre 800pb y 2000pb) pero por defecto no realiza filtros por calidad.
Para considerar una asignación taxonómica exige un porcentaje de identidad de 95 % y una cobertura de 90%.

Por defecto el pipeline realiza la asignación taxonómica con la herramienta Minimap2 y la base de datos de 16S de Genbank. Para cambiar la herramienta de clasificación, utiliza el parámetro `--classifier`, eligiendo entre `kraken2` y `minimap2`. Para seleccionar una base de datos diferente, usa el parámetro `--database_set`, con alguna de las siguientes opciones: `ncbi_16s_18s`, `ncbi_16s_18s_28s_ITS` y `SILVA_138_1`.



=== Ejemplo de uso

```sh
 nextflow run epi2me-labs/wf-16s \
     --classifier kraken2 --database_set SILVA_138_1 \
     --sample_sheet samples.csv \
     --taxonomic_rank G --fastq data  \
     --out_dir wf-16s_minimap_ncbi \
     -profile singularity -resume
```
El pipeline requiere un archivo de muestras en formato CSV que contenga la información de las muestras y los barcodes asociados.

==== Estructura del directorio
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
==== Estructura del archivo de muestras
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