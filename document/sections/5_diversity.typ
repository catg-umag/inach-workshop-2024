#import "@preview/gentle-clues:0.9.0": *

#import "../catgconf.typ": github-pill
https://carpentries-lab.github.io/metagenomics-analysis/08-Diversity-tackled-with-R/index.html


 
avgdist --> no todas las muestras tienen la misma cantidad de seqs --> sampling
= Curvas de rarefacción 
Las curvas de rarefacción permiten evaluar la riqueza de especies dentro de una comunidad en función del número de secuencias obtenidas. Nos permiten determinar si el número de secuencias obtenidas fué suficiente para capturar la diversidad de la comunidad.

Para ello, se realizan muestreos aleatorios y se visualiza el número de especies observadas a medida que aumenta el número de secuencias.

Utilizaremos la función `rarecurve` del paquete Vegan para realizar las curvas de rarefacción.
Podemos indicarle a la función que genere una línea vertical en el punto donde se alcanza el mínimo número de secuencias en una muestra. (No se si se entiende)
```R
minReads <- min(rowSums(count_data_t))

rarecurve(count_data_t, step = 20, sample = minReads, col = "#87a3c9", cex = 0.6)
```

= Índices de diversidad alfa
//https://scienceparkstudygroup.github.io/microbiome-lesson/04-alpha-diversity/index.html
Las métricas de diversidad alfa se utilizan para medir la diversidad dentro de una muestra o ecosistema, es decir, qué hay y cuánto hay en términos de especies.

Las métricas mas comunes de diversidad alfa son:
- Riqueza: Número de especies observadas en una muestra.
- Equidad: Que tan equitativo se distribuyen las abundancias de las especies en una muestra.
  - Valores cercanos a uno indican comunidades donde todas las especies tienen abundancias similares, mientras valores cercanos a cero indican comunidades donde una o pocas especies son dominantes.
- Shannon: Mide la diversidad de especies en una muestra, considerando la abundancia de las especies.
  - Valores más altos indican mayor diversidad y equidad en la comunidad, mientras que valores bajos pueden llegar a indicar baja equitatividad o baja riqueza.
- Chao1: Estima la riqueza total (número de especies no observadas en una muestra).
  - Valores significativamente mayores que la riqueza observada sugieren que el muestreo fue insuficiente para detectar todas las especies presentes en la comunidad.
// - Simpson: Mide la probabilidad de que dos individuos seleccionados al azar pertenezcan a la misma especie.

Para esto, utilizaremos el paquete vegan en R. 
Calcularemos la ríqueza, equidad, índice de Shannon y Chao1.
```R
data_richness <- estimateR(data_otu)
data_evenness <- diversity(data_otu) / log(specnumber(data_otu))                
data_shannon <- diversity(data_otu, index = "shannon")                
```
#tip[
  La diversidad alfa habitualmente se calcula sobre los datos sin procesar y sin normalizar. Esto último ya que se busca evaluar la diversidad por muestra y no comparar muestras entre sí.
  // It is important to not use filtered data because many richness estimates are modeled on singletons and doubletons in the occurrence table. So, you need to leave them in the dataset if you want a meaningful estimate.
// Moreover, we usually not using normalized data because we want to assess the diversity on the raw data and we are not comparing samples to each other but only assessing diversity within each sample.
//
]



 

== Test estadisticos

Podemos utilizar diferentes test estádisticos para comprobar si existen diferencias significativas entre los grupos: pruebas no paramétricas como el test de Kruskal-Wallis o el test de Mann-Whitney o pruebas parámetricas como t-test y ANOVA. Antes de utilizar pruebas parámetricas se debe comprobar la normalidad y hococedasticidad de los datos.

= Índices de diversidad beta
// tutorial: https://scienceparkstudygroup.github.io/microbiome-lesson/06-beta-diversity/index.html
La diversidad beta nos permite representar las diferencias  de diversidad entre muestras o ecosistemas, es decir, que tan similares o diferentes son las comunidades microbianas.
// se uiliza para medir la diversidad entre muestras o ecosistemas.

 Estas métricas de distancia varían entre cero y uno. Las más usadas son las siguientes:// Bray-Curtis, Jaccard, Unifrac, entre otros.
- Bray-Curtis: Mide la disimilitud entre muestras. Se basa en la abundancia de los taxones en las muestra. 
- Jaccard: Mide disimilitud. Se basa en la presencia/ausencia de los taxones en las muestras, sin incluir información de la abundancia.
- Unifrac: Mide la distancia filogenética entre comunidades, considerando la presencia/ausencia, abundancias y evolución filogenética.  Unweighted UniFrac considera solo la presencia o ausencia de otus (sin considerar abundancia), Weighted UniFrac considera las abundancias  //Se basa en la presencia/ausencia de las especies en las muestras, incluyendo información de la abundancia.

// BRAY CURTIS EXAMINA LA ABUNDANCIA COMPARTIDA ENTRE GROUPIOS

// https://scienceparkstudygroup.github.io/microbiome-lesson/06-beta-diversity/index.html


Para calcular la diversidad beta necesitamos el archivo de abundancias generado en el paso anterior y un archivo de metadata.
```csv
sample	sex	    Area	latitude	long	    deep
1M	    Male	  48.2	60° 25,0	46° 41.8	 60-80
4H	    Female	48.2	60° 33,1	46° 02.3	120-150
5H	    Female	48.2	60° 30,0	46° 36.4	 30-30
6H	    Female	48.2	60° 30,1	46° 42.7	 30-33
6M	    Male	  48.2	60° 30,1	46° 42.7	 30-33
7H	    Female	48.1	62° 37,0	55° 26.7	 30-29
7M	    Male	  48.1	62° 37,0	55° 26.7	 30-29
```

Para calcular la diversidad beta utilizaremos las matrices de disimilitud de Bray-curtis y Jaccard y las proyectaremos en un espacio bidimensional mediante una PCoA.

Una PCoA ((Principal Coordinate Analysis) es una técnica de ordenación que permite reducir la dimensionalidad de los datos y visualizar la diversidad beta en un espacio de menor dimensión.
//Another commonly-used MDS approach is Principal Coordinates Analysis (PCoA), also known as classical multidimensional scaling. It relies on eigenvalue decomposition in its calculations.
Algunas funciones utiles a utilizar son:
- vegdist:  Permite calcular la matri una matriz de disimilitud entre muestras. Se pueden utilizar diferentes métricas de distancia, como  `Bray-curtis`, `Jacard`, `Euclideana`, entre otras. 
- cmdscale: Realiza un análisis de coordenadas principales (PCoA) a partir de una matriz de disimilitud. 
```R
bray_dist <- vegdist(data_otu, method = "bray")
// pcoa_res <- cmdscale(bray_dist, eig = TRUE)
```

#tip[
Cuando realizamos una analisis de coordenadas principales (PCoA) es importante tener en cuenta que los valores propios (eigenvalues) representan la varianza de cada uno de los componentes. Cada eigenvector consiste en p valores que representan la "contribución" de cada variable al eje de componente principal.
Valores altos indican que el eje captura una mayor cantidad de la varianza total de los datos.
]


HACER ANALISIS ESTADISTICOS

//The eigenvalue represents the variance displayed (“explained” or “extracted”) by the kth axis
//Each eigenvector consists of p values which represent the “contribution” of each variable to the principal component axis

// hacer una lista 
// distancia euclideana vs otras distiancias por que las otras son mejores
// Microbiota data are sparse and specific distances, such as Bray-Curtis, Jaccard or weight/unweight Unifrac distances, better deal with the problem of the presence of many double zeros in data sets.