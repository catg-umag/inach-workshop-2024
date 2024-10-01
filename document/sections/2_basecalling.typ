#import "../catgconf.typ": github-pill, cmd


= Basecalling

Basecalling es el proceso por el cual se convierte la señal eléctrica captada por los dipositivos de Oxford Nanopore en secuencias de nucleótidos. Esta conversión requiere de algoritmos computacionales avanzados, como las redes neuronales LSTM y los transformers utilizados por las opciones de basecalling actuales. Este proceso es crucial porque define la calidad de los datos, lo que afectará directamente los análisis posteriores.

Oxford Nanopore ha desarrollado múltiples basecallers haciendo uso de diversos avances tecnológicos. El basecaller actual es #link("https://github.com/nanoporetech/dorado")[Dorado], el cual se puede utilizar mediante línea de comandos, o a través de MinKNOW.


== Precisión del basecalling

Dorado cuenta con múltiples modelos de basecalling, cada uno con diferentes equilibrios entre precisión y requerimientos computacionales. Actualmente, los modelos disponibles son tres:


#align(
  center,
  table(
    columns: 3,
    align: (left, center, left),
    table.header([Modelo], [Precisión Simplex], [Requerimientos computacionales]),
    [fast (`fast`)], [95.5%], [],
    [high accuracy (`hac`)], [99.25%], [7.5 veces lo requerido por #cmd(`fast`)],
    [super accuracy (`sup`)], [99.75%], [8.5 veces lo requerido por #cmd(`hac`)],
  ),
)

#figure(
  image("../images/raw_accuracy.png", width: 80%),
  caption: [
    Precisión actual de los modelos de basecalling de Oxford Nanopore, usando el Kit V14 y celdas R10.4.1 de PromethION para secuenciación de genoma humano. _Fuente: #link("https://nanoporetech.com/es/platform/accuracy")_.
  ],
)

Usar el modelo #cmd(`sup`) es la opción recomendada si se busca obtener la máxima precisión posible. Sin embargo, este modelo tiene un costo computacional tan elevado que se vuelve impráctico de usar sin hardware dedicado (GPU).


== Uso básico de Dorado
#github-pill("nanoporetech/dorado")

Dorado posee múltiples subcomandos con distintas funcionalidades, que incluyen basecalling, demultiplexación, descarga de modelos y otras.

=== Basecalling

Para basecalling, se utiliza el subcomando #cmd(`dorado basecaller`). La forma más básica de ejecutar este comando necesita el modelo a utilizar en el basecalling y el directorio con los archivos POD5. Por ejemplo, si tenemos el directorio `pod5/` y queremos utilizar el modelo `sup`, se ejecuta el siguiente comando:
```sh
dorado basecaller sup pod5/ > reads.ubam
```
Adicionalmente, existen múltiples opciones adicionales que se pueden visualizar en la ayuda del comando.

=== Demultiplexación

Para demultiplexar los datos, se utiliza el subcomando #cmd(`dorado demux`). Este comando requiere el archivo UBAM con los reads generado en el basecalling y el kit de barcoding. Por ejemplo, si tenemos el archivo el `reads.ubam` y el kit SQK-NBD114-24:
```sh
dorado demux --output-dir basecalled_reads --kit-name SQK-NBD114-24 --emit-fastq reads.ubam
```
En este ejemplo, #cmd(`--output-dir`) indica el directorio donde se guardarán los archivos demultiplexados, y #cmd(`--emit-fastq`) se utiliza para que los archivos generados estén en formato FASTQ (por defecto, se generan en BAM).