#import "@preview/gentle-clues:1.0.0": *
#import "../catgconf.typ": cmd


= Entorno de Trabajo

== Línea de comandos

La línea de comandos es una interfaz de texto que permite interactuar con el sistema operativo mediante comandos. Es fundamental al procesar datos bioinformáticos, ya que muchas herramientas carecen de interfaz gráfica y el uso de la terminal facilita la automatización y ejecución de tareas en entornos HPC o en la nube.

Un comando es una instrucción que se escribe en la terminal y se ejecuta al presionar #cmd(`Enter`). La estructura típica de un comando es:
```sh
comando [subcomando] [opciones] <argumentos>
```
Los #cmd(`<argumentos>`) suelen ser archivos de entrada y salida, mientras que las #cmd(`opciones`) modifican el comportamiento del comando. Estas pueden ser largas (#cmd(`--opcion`)) o cortas (#cmd(`-o`)), y pueden requerir argumentos. Finalmente, algunos comandos poseen #cmd(`[subcomandos]`), que permiten realizar tareas específicas.

#tip(title: "Ayuda en comandos")[
  Para obtener ayuda sobre un comando, utiliza #cmd(`--help`) o #cmd(`-h`). Por ejemplo: #cmd(`git --help`).

  Los corchetes (#cmd(`[ ]`)) indican argumentos opcionales, mientras que los obligatorios se escriben con corchetes angulares (#cmd(`< >`)) o sin ellos.
]

== Interacción con archivos en Linux

Para ejecutar herramientas desde la terminal, es necesario saber cómo encontrar y manipular archivos. A continuación, se presentan algunos de los comandos más básicos para interactuar con archivos en Linux.

#heading([#cmd(`ls`) -- Listar archivos y directorios], depth: 3, numbering: none)

```sh
ls                                      # Muestra los archivos en el directorio actual
ls -l                                   # Muestra detalles de los archivos
ls -a                                   # Incluye archivos ocultos en la lista
```

#heading([#cmd(`pwd`) -- Imprimir el directorio actual], depth: 3, numbering: none)
```sh
pwd
```

#heading([#cmd(`cd`) -- Cambiar de directorio], depth: 3, numbering: none)
```sh
cd data                                 # Entra a la carpeta indicada
cd ..                                   # Sube un nivel en el árbol de directorios
cd ../..                                # Sube dos niveles
cd ~                                    # Regresa al directorio de inicio
```

#heading([#cmd(`cp`) -- Copiar archivos o directorios], depth: 3, numbering: none)
```sh
cp config.yaml analisis/                # Copia el archivo a la ubicación destino
cp -r results results_bak               # Copia una carpeta y su contenido
```

#heading([#cmd(`mv`) -- Mover o renombrar archivos], depth: 3, numbering: none)
```sh
mv sample01.fastq data/                 # Mueve el archivo al destino
mv config.test.txt config.txt           # Cambia el nombre del archivo
```

#pagebreak()

#heading([#cmd(`rm`) -- Eliminar archivos o directorios], depth: 3, numbering: none)
```sh
rm test.txt                             # Elimina el archivo
rm -r tmp                               # Elimina una carpeta y su contenido
```

#heading([#cmd(`mkdir`) -- Crear directorios], depth: 3, numbering: none)
```sh
mkdir data                              # Crea un directorio en la ubicación actual
mkdir -p analysis/quality               # Crea directorios anidados
```

#heading([#cmd(`head`) / #cmd(`tail`) / #cmd(`less`) -- Visualizar el contenido de archivos], depth: 3, numbering: none)
```sh
less sequences.fasta                    # Permite desplazarse por el contenido
head -n 10 sequences.fasta              # Muestra las primeras 10 líneas
tail -n 5 sequences.fasta               # Muestra las últimas 5 líneas
```

#heading([Redirección de salida], depth: 3, numbering: none)
```sh
head -n 100 sequences.fa > subset.fa    # Guarda la salida del comando ejecutado en un archivo
```

== Tipos de archivos relevantes al procesar datos bioinformáticos

#align(
  center,
  table(
    columns: 3,
    align: (center, center, left),
    table.header([Tipo], [Extensión], [Contenido]),
    [FASTA], [#cmd(`.fasta`) #cmd(`.fa`) #cmd(`.fna`) #cmd(`.fsa`) #cmd(`.faa`)], [Secuencias biológicas],
    [FASTQ], [#cmd(`.fastq`) #cmd(`.fq`)], [Secuencias biológicas con calidad],
    [BAM], [#cmd(`.bam`) #cmd(`.ubam`)], [Alineamiento de secuencias contra una referencia (comprimido)],
    [POD5], [#cmd(`.pod5`)], [Datos crudos de Oxford Nanopore],
    [CSV / TSV], [#cmd(`.csv`) #cmd(`.tsv`)], [Datos tabulares separados por comas (CSV) o tabulaciones (TSV)],
    [YAML], [#cmd(`.yaml`) #cmd(`.yml`)], [Datos estructurados en formato YAML],
  ),
)

#tip(title: "Archivos comprimidos")[
  Es común comprimir los archivos para ahorrar espacio de almacenamiento. Los archivos comprimidos generalmente tienen la extensión adicional #cmd(`.gz`). Para descomprimirlos, debes utilizar el comando #cmd(`gunzip`).
  ```sh
  gunzip sequences.fastq.gz             # Descomprime el archivo
  head sequences.fastq                  # Visualiza las primeras líneas del archivo descomprimido
  ```
]

== Gestión de entorno de trabajo con mamba

Mamba es un gestor de paquetes que facilita la instalación y gestión de paquetes de Python y R, y también herramientas bioinformáticas. Estos paquetes se instalan en 'ambientes', entornos de trabajo aislados y reproducibles que mantienen la instalación de paquetes separada de otros ambientes y del sistema operativo. Los ambientes pueden activarse y desactivarse según sea necesario. Los paquetes están disponibles en 'canales', destacando #link("https://conda-forge.org/")[conda-forge] para paquetes de Python y R y #link("https://bioconda.github.io/")[bioconda] para herramientas bioinformáticas.

Algunas de las tareas más comunes que se pueden realizar con Mamba son:

#heading([Listar, crear y eliminar ambientes], depth: 3, numbering: none)
```sh
mamba env list                          # Lista los ambientes disponibles
mamba create -n qc                      # Crea un ambiente llamado 'qc'
mamba env remove -n analysis            # Elimina el ambiente 'analysis'
```

#pagebreak()

#heading([Activar y desactivar ambientes], depth: 3, numbering: none)
```sh
mamba activate qc                       # Activa el ambiente 'qc'
mamba deactivate                        # Desactiva el ambiente activo
```

#heading([Gestionar paquetes], depth: 3, numbering: none)
```sh
mamba list                              # Lista los paquetes instalados en el ambiente activo
mamba install python                    # Instala Python en el ambiente activo si no está presente
mamba install bioconda::samtools        # Instala el paquete 'samtools' desde el canal 'bioconda'
mamba install bioconda::nanoq=0.9.0     # Instala una versión específica del paquete 'nanoq'
mamba update nanoq                      # Actualiza el paquete 'nanoq'
mamba remove samtools                   # Desinstala el paquete 'samtools'
```

#heading([Exportar e importar ambientes], depth: 3, numbering: none)
```sh
mamba env export -n qc > qc.yaml        # Exporta el ambiente 'qc' a un archivo YAML
mamba env create -f qc.yaml             # Crea un ambiente a partir del archivo YAML
```
