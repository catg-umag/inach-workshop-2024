#import "@preview/gentle-clues:0.9.0": *
#import "../catgconf.typ": cmd


= Entorno de Trabajo

== Línea de Comandos

La línea de comandos es una interfaz de texto que permite interactuar con el sistema operativo mediante comandos. Es fundamental al procesar datos bioinformáticos, ya que muchas herramientas carecen de interfaz gráfica y el uso de la terminal facilita la automatización y ejecución de tareas en entornos HPC o en la nube.

Un comando es una instrucción que se escribe en la terminal y se ejecuta al presionar Enter. La estructura típica de un comando es:
```sh
comando [subcomando] [opciones] <argumentos>
```
Los #cmd(`<argumentos>`) suelen ser archivos de entrada y salida, mientras que las #cmd(`opciones`) modifican el comportamiento del comando. Estas pueden ser largas (#cmd(`--opcion`)) o cortas (#cmd(`-o`)), y a veces requieren argumentos. Finalmente, algunos comandos poseen #cmd(`[subcomandos]`).

#tip[
  Para obtener ayuda sobre un comando, utiliza #cmd(`--help`) o #cmd(`-h`). Por ejemplo: #cmd(`git --help`).

  Los corchetes (#cmd(`[ ]`)) indican argumentos opcionales, mientras que los obligatorios se escriben con corchetes angulares (#cmd(`< >`)) o sin ellos.
]

== Interacción con Archivos en Linux

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

== Tipos de Archivos Comunes al Procesar Datos Bioinformáticos

#align(
  center,
  table(
    columns: 3,
    align: (left, center, left),
    table.header([Tipo], [Extensión], [Contenido]),
    [FASTA],
    [#cmd(`.fasta`) #cmd(`.fa`) #cmd(`.fna`) #cmd(`.fsa`) #cmd(`.faa`)],
    [Archivo de texto plano que contiene secuencias biológicas],

    [FASTA], [#cmd(`.fastq`) #cmd(`.fq`)], [Archivo de texto que almacena secuencias biológicas y su calidad],
    [SAM], [#cmd(`.sam`)], [Archivos de alineación de secuencias],
    [BAM], [#cmd(`.bam`) #cmd(`.ubam`)], [Archivos de alineación de secuencias (comprimido)],
    [CSV/TSV], [#cmd(`.csv`) #cmd(`.tsv`)], [Archivos de alineación de secuencias],
  ),
)

#tip[
  Es común encontrar comprimir los archivos para ahorrar espacio de almacenamiento. Los archivos comprimidos tienen la extensión adicional #cmd(`.gz`). Para descomprimirlos, debes utilizar el comando #cmd(`gunzip`).
  ```sh
  gunzip sequences.fastq.gz             # Descomprime el archivo
  head sequences.fastq                  # Visualiza las primeras líneas del archivo descomprimido
  ```
]

== Gestión de Entorno de Trabajo con Mamba

Mamba es un gestor de paquetes que facilita la instalación y gestión de paquetes de Python y R, además de posibilitar la instalación de herramientas bioinformáticas.
Estas herramientas y paquetes se instalan en "ambientes", que permiten aislar las dependencias de proyectos específicos y obtener un entorno de trabajo reproducible. Estos entornos pueden activarse y desactivarse según sea necesario.

#heading([Crear ambientes], depth: 3, numbering: none)
```sh
mamba create -n qc                      # Crea un ambiente llamado 'qc'
mamba create -n analysis python=3.12    # Crea el ambiente `qc`, incluyendo Python 3.12
```

#heading([Listar ambientes], depth: 3, numbering: none)
```sh
mamba env list
```

#heading([Activar y desactivar ambientes], depth: 3, numbering: none)
```sh
mamba activate qc                       # Activa el ambiente 'qc'
mamba deactivate                        # Desactiva el ambiente activo
```

#heading([Gestión de paquetes], depth: 3, numbering: none)
```sh
mamba install bioconda::samtools        # Instala el paquete 'samtools' en el ambiente activo
mamba install bioconda::nanoq=0.9.0     # Instala una versión específica del paquete 'nanoq'
mamba update nanoq                      # Actualiza el paquete 'nanoq'
mamba remove samtools                   # Desinstala el paquete 'samtools'
mamba list                              # Lista los paquetes instalados en el ambiente activo
```

#heading([Exportar e importar ambientes], depth: 3, numbering: none)
```sh
mamba env export -n qc > qc.yaml        # Exporta el ambiente 'qc' a un archivo YAML
mamba env create -f qc.yaml             # Crea un ambiente a partir del archivo YAML
```
