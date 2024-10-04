#import "@preview/gentle-clues:1.0.0": *
#import "../catgconf.typ": github-pill, cmd


= Análisis de Diversidad
#github-pill("vegandevs/vegan")

== Rarefacción
La rarefacción es una técnica que permite evaluar la riqueza de especies dentro de una comunidad en función del número de secuencias obtenidas. Es útil para determinar si las secuencias obtenidas son suficientes para capturar la diversidad de la comunidad. Para ello, se utilizan muestreos aleatorios y se visualiza en una curva el número de especies observadas a medida que aumenta el número de secuencias.

Para construir las curvas de rarefacción, podemos utilizar la función #link("https://vegandevs.github.io/vegan/reference/rarefy.html")[#cmd(`rarecurve()`)] del paquete vegan en R. El parámetro `sample` agrega una línea vertical al gráfico, útil para comparar la riqueza observada con la muestra de menor número de secuencias.
```R
library(vegan)

min_reads <- min(rowSums(count_data_t))  # número mínimo de secuencias en una muestra
rarecurve(count_data_t, step = 20, sample = min_reads)
```

#pagebreak()

== Diversidad Alfa

Las métricas de diversidad alfa se emplean para medir la diversidad dentro de una muestra o ecosistema, es decir, la cantidad de especies y/o su abundancia relativa.

Las métricas más comunes de diversidad alfa incluyen:

- *Riqueza*: Número de especies observadas en una muestra.
- *Equidad*: Grado de uniformidad en la distribución de las abundancias de las especies en una muestra. \
  _Interpretación_: Valores cercanos a uno indican que todas las especies tienen abundancias similares, mientras que valores cercanos a cero sugieren que una o pocas especies dominan la comunidad.
- *Shannon*: Índice que mide la diversidad considerando tanto la riqueza como la equidad de las especies en una muestra. \
  _Interpretación_: Valores altos indican mayor diversidad y equidad, mientras que valores bajos pueden señalar una baja equidad o riqueza.
- *Chao1*: Estimación de la riqueza total, incluyendo especies no observadas. \
  _Interpretación_: Si el valor de Chao1 es significativamente mayor que la riqueza observada, indica que el muestreo fue insuficiente para detectar todas las especies presentes.

Para calcular estas métricas en R, también usaremos el paquete vegan.
```R
library(vegan)

data_richness <- estimateR(data_otu)
data_evenness <- diversity(data_otu) / log(specnumber(data_otu))
data_shannon <- diversity(data_otu, index = "shannon")
```
#info(title: "Normalización y diversidad alfa")[
  La diversidad alfa habitualmente se calcula sobre los datos sin procesar y sin normalizar, ya que se busca evaluar la diversidad por muestra y no comparar muestras entre sí.
]

#heading([Pruebas estadísticas], level: 3, numbering: none)

Podemos utilizar diferentes test estádisticos para comprobar si existen diferencias significativas entre los grupos: pruebas no paramétricas como el test de Kruskal-Wallis o el test de Mann-Whitney o pruebas parámetricas como t-test y ANOVA. Antes de utilizar pruebas parámetricas se debe comprobar la normalidad y hococedasticidad de los datos.

== Diversidad Beta
La diversidad beta se utiliza para evaluar las diferencias de diversidad entre muestras o ecosistemas, es decir, qué tan similares o diferentes son las comunidades microbianas entre sí. Estas métricas de distancia varían entre cero y uno, y las más comunes son: // Bray-Curtis, Jaccard, Unifrac, entre otros.
- *Bray-Curtis*: Calcula la disimilitud entre muestras basándose en la abundancia de los taxones presentes en ellas.
- *Jaccard*: Calcula la disimilitud tomando en cuenta solo la presencia o ausencia de los taxones, sin considerar la abundancia.
- *Unifrac*: Calcula la distancia filogenética entre comunidades. Se puede calcular en dos formas:
  - *Unweighted UniFrac*: Considera solo la presencia o ausencia de OTUs (sin abundancia).
  - *Weighted UniFrac*: Incluye tanto la abundancia como la evolución filogenética de los OTUs. // Se basa en la presencia/ausencia de las especies en las muestras, incluyendo información de la abundancia.

#pagebreak()

Para calcular la diversidad beta, necesitamos el archivo de abundancias generado en el paso anterior y un archivo de metadatos. A continuación, un ejemplo de archivo de metadatos:
```TSV
sample	sex	    Area	latitude	long	    deep
1M	    Male	  48.2	60° 25,0	46° 41.8	 60-80
4H	    Female	48.2	60° 33,1	46° 02.3	120-150
5H	    Female	48.2	60° 30,0	46° 36.4	 30-30
6H	    Female	48.2	60° 30,1	46° 42.7	 30-33
6M	    Male	  48.2	60° 30,1	46° 42.7	 30-33
7H	    Female	48.1	62° 37,0	55° 26.7	 30-29
7M	    Male	  48.1	62° 37,0	55° 26.7	 30-29
```

Para visualizar la diversidad beta, se utilizan matrices de disimilitud, como Bray-Curtis o Jaccard, que luego se proyectan en un espacio bidimensional utilizando un Análisis de Coordenadas Principales (PCoA). Esta técnica reduce la dimensionalidad de los datos, facilitando la visualización de las relaciones entre muestras.

Algunas funciones útiles para este análisis en R son:
- #link("https://vegandevs.github.io/vegan/reference/vegdist.html")[#cmd(`vegdist()`)]: Calcula una matriz de disimilitud entre las muestras, permitiendo elegir entre métricas como Bray-Curtis, Jaccard, Euclidiana, entre otras.
- #link("https://vegandevs.github.io/vegan/reference/stressplot.wcmdscale.html")[#cmd(`cmdscale()`)]: Realiza un análisis de coordenadas principales (PCoA) a partir de la matriz de disimilitud.
```R
library(vegan)

bray_dist <- vegdist(data_otu, method = "bray")
pcoa_res <- cmdscale(bray_dist, eig = TRUE)
```

#tip(title: "Varianza explicada en un PCoA")[
  Al realizar un análisis de coordenadas principales (PCoA), es importante tener en cuenta que los valores propios (eigenvalues) representan la varianza explicada por cada componente. Un eigenvalue alto indica que ese eje captura una mayor cantidad de la varianza total de los datos, lo que permite una mejor interpretación de la estructura de las muestras.
]


