#import "../catgconf.typ": cmd

= Línea de Comandos

La línea de comandos es una interfaz de texto que permite interactuar con el sistema operativo mediante comandos. Su uso es fundamental al realizar análisis bioinformáticos, ya que la mayoría de las herramientas no cuentan con una interfaz gráfica, además de ofrecer ventajas a la hora de automatizar y ejecutar tareas en entornos HPC o en la nube.

Un comando es una instrucción que se escribe en la terminal y que se ejecuta al presionar la tecla Enter. Cada comando tiene una estructura específica, comunmente similar a la siguiente:
```sh
comando [subcomando] [opciones] <argumentos>
```
Los #cmd(`<argumentos>`) generalmente corresponde a los archivos de entrada y salida del comando y son obligatorios. Por otro lado, las opciones se utilizan para modificar el comportamiento del comando y suelen ser opcionales. Normalmente se usa el formato #cmd(`--opcion`) (forma larga) o #cmd(`-o`) (forma corta) y pueden tener un argumento asociado a la opción. Dependiendo de la herramienta, pueden existir #cmd(`[subcomandos]`).