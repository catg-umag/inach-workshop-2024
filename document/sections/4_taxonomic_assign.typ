#import "../catgconf.typ": github-pill


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




== Eliminación de especies poco abundantes


== Normalización por muestra
https://scienceparkstudygroup.github.io/microbiome-lesson/05-data-filtering-and-normalisation/index.html