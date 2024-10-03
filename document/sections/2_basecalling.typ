#import "../catgconf.typ": github-pill, cmd


= Basecalling

Basecalling es el proceso por el cual se convierte la señal eléctrica captada por los dispositivos de Oxford Nanopore en secuencias de nucleótidos. Esta conversión requiere de algoritmos computacionales avanzados, como las redes neuronales LSTM y los transformers utilizados por las opciones de basecalling actuales. Este proceso es crucial porque define la calidad de los datos, lo que afectará directamente los análisis posteriores.

Oxford Nanopore ha desarrollado múltiples basecallers haciendo uso de diversos avances tecnológicos. El basecaller actual es #link("https://github.com/nanoporetech/dorado")[Dorado], el cual se puede utilizar mediante línea de comandos, o a través de MinKNOW.


== Precisión del basecalling

Dorado cuenta con múltiples modelos de basecalling, cada uno con diferentes equilibrios entre precisión y requerimientos computacionales: `fast`, `hac`, y `sup`. Estos modelos se actualizan continuamente con nuevas versiones.

#align(
  center,
  table(
    columns: 3,
    align: (left, center, left),
    table.header([Modelo], [Precisión simplex], [Requerimientos computacionales]),
    [fast (`fast`)], [95.50%], [],
    [high accuracy (`hac`)], [99.25%], [7.5 veces lo requerido por #cmd(`fast`)],
    [super accuracy (`sup`)], [99.75%], [8.5 veces lo requerido por #cmd(`hac`)],
  ),
)

#figure(
  image("../images/raw_accuracy.png", width: 80%),
  caption: [
    Precisión actual de los modelos de basecalling de Oxford Nanopore, con el Kit V14 y celdas R10.4.1 de PromethION en secuenciación de genoma humano. _Fuente: #link("https://nanoporetech.com/es/platform/accuracy")_.
  ],
)

El modelo #cmd(`sup`) ofrece la máxima precisión, pero sus altos requisitos computacionales lo hacen impráctico de utilizar sin hardware especializado (GPU de gama alta).


== Uso de Dorado
#github-pill("nanoporetech/dorado")

Dorado posee múltiples subcomandos con distintas funcionalidades, que incluyen basecalling, demultiplexación y descarga de modelos, entre otras.

=== Basecalling

Para basecalling, se utiliza el subcomando #cmd(`dorado basecaller`). Par ejecutar este comando se requiere como mínimo el modelo a utilizar y el directorio con los archivos POD5. Por ejemplo, si tenemos el directorio `pod5/` y queremos utilizar el modelo `sup` en su versión 5.0.0, debemos utilizar el siguiente comando:
```sh
dorado basecaller sup@5.0.0 pod5/ > reads.ubam
```
Existen múltiples opciones adicionales que se pueden visualizar en la ayuda del comando.

=== Demultiplexación

Para demultiplexar los datos, se utiliza el subcomando #cmd(`dorado demux`). Este comando requiere el archivo UBAM con los reads generado en el basecalling y el kit de barcoding. Por ejemplo, si tenemos el archivo el `reads.ubam` y el kit SQK-NBD114-24:
```sh
dorado demux --output-dir basecalled_reads --kit-name SQK-NBD114-24 --emit-fastq reads.ubam
```
En este ejemplo, #cmd(`--output-dir`) indica el directorio donde se guardarán los archivos demultiplexados, y #cmd(`--emit-fastq`) se utiliza para que los archivos generados estén en formato FASTQ (por defecto, se generan en BAM).