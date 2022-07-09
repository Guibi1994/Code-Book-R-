Code Book ver 2.0
================
2022-07-03

# Fundamentos de Web-scraping en R

*Web scraping* o web harvesting hace referencia al conjutno de técnicasl
empleadas para extraer información en la wed que no esta necesariamente
empaquetada en un objeto o archivo consumible de manera directa .

``` r
# libreiras
library(dplyr)
library(rvest) # para web scraping
library(ggplot2)

library(kableExtra)
library(tidyr)
```

## Estructura de un HTML

Los documentos **HTML** (*Hypert Text Markup*) son archivos
estructurados que contienen una semántica regular, y son los que por lo
general podemos observar detrás de las páginas web (la mayoria de
ellas). Si dentro de una págian web damos “click secudnario” y luego
“inspecionar” (o tambien “**Ctrl+u**”), podemos ver con clairdad el
documetno HTMl detras de ella.

<p align="center">
<img src="00_Code_Book_2.0_files/figure-gfm/prueba.png" alt="Preuba" width="540"/>
</p>

HTML como lenguaje de porgramación tiene una sintaxis y una estructura
lógica. Una muestra de esto es que cada uno de los **elementos** de una
documento HTML esta **encapsulado** en un “**nodo**”. Por ejemplo, el
título de un documento HTML esta codificado así:
`<title>"Un gran titulo"</titile>` en donde `<title>` es el nodo del
titulo. Esta estructura de “nodos” nos permite detectar patrones y
elementos puntuales dentro de estos documentos.

<p align="center">
<img src="00_Code_Book_2.0_files/figure-gfm/prueba2.png" alt="estructura_html" width="484"/>
</p>

Algunos elementos con sus tespectivos “***tags***” (nombre del nodo)
comúnes en un documento HTML son:

-   `<!DOCTYPE html>` : Declaración del tipo de docuento (en este caso
    un HTML)

-   `<head>` : Contiene metadata sobre la pagina HTML

-   `<title>` : El titulo de la pagina en cuestion (el que finalmente se
    muestra en el buscador/browser)

-   `<body>` :

Otros tags comunes son `<table>`, `<fig>`, `<table>`, `<table>`, etc…

## Web scraping de tablas

En este ejemplo utilizaremos la página web de [Wilkipedia del PIB
(Prodcucto Interno Bruto) por
paises](https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal) "¡Haz click aqui!"),
para emplear las técnicas básicas de web scrping en **R**.

``` r
# 1. Leemos el link a explorar

h <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)")
class(h)
```

    ## [1] "xml_document" "xml_node"

# Notas sobre data/wrangling

``` r
#  Base inicial
nivel_edu <- data.frame(
  pais = c(sample("Colombia",5,T),sample("Peru",5,T),sample("Venezuela",5,T)),
  materia = c("matematicas","lenguaje", "ingles", "fisica", "quimica"),
  p_2014 = rnorm(15,50,15),
  p_2016 = rnorm(15,55,10),
  p_2018 = rnorm(15,54,13),
  p_2020 = rnorm(15,61,8),
  p_2022 = rnorm(15,67,19))

nivel_edu %>% kable() 
```

<table>
<thead>
<tr>
<th style="text-align:left;">
pais
</th>
<th style="text-align:left;">
materia
</th>
<th style="text-align:right;">
p_2014
</th>
<th style="text-align:right;">
p_2016
</th>
<th style="text-align:right;">
p_2018
</th>
<th style="text-align:right;">
p_2020
</th>
<th style="text-align:right;">
p_2022
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:right;">
50.52657
</td>
<td style="text-align:right;">
51.19101
</td>
<td style="text-align:right;">
66.91124
</td>
<td style="text-align:right;">
67.04729
</td>
<td style="text-align:right;">
45.83746
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
lenguaje
</td>
<td style="text-align:right;">
57.62763
</td>
<td style="text-align:right;">
45.46454
</td>
<td style="text-align:right;">
76.43998
</td>
<td style="text-align:right;">
66.54502
</td>
<td style="text-align:right;">
65.45837
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
ingles
</td>
<td style="text-align:right;">
67.77405
</td>
<td style="text-align:right;">
60.39700
</td>
<td style="text-align:right;">
46.94242
</td>
<td style="text-align:right;">
63.47547
</td>
<td style="text-align:right;">
46.24602
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
fisica
</td>
<td style="text-align:right;">
51.89604
</td>
<td style="text-align:right;">
55.10342
</td>
<td style="text-align:right;">
30.89100
</td>
<td style="text-align:right;">
69.69008
</td>
<td style="text-align:right;">
104.10113
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
quimica
</td>
<td style="text-align:right;">
37.49152
</td>
<td style="text-align:right;">
58.47756
</td>
<td style="text-align:right;">
33.67003
</td>
<td style="text-align:right;">
70.35040
</td>
<td style="text-align:right;">
29.47391
</td>
</tr>
<tr>
<td style="text-align:left;">
Peru
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:right;">
47.16014
</td>
<td style="text-align:right;">
39.28072
</td>
<td style="text-align:right;">
33.70080
</td>
<td style="text-align:right;">
61.73620
</td>
<td style="text-align:right;">
89.63085
</td>
</tr>
<tr>
<td style="text-align:left;">
Peru
</td>
<td style="text-align:left;">
lenguaje
</td>
<td style="text-align:right;">
59.27392
</td>
<td style="text-align:right;">
47.38434
</td>
<td style="text-align:right;">
62.77158
</td>
<td style="text-align:right;">
53.74179
</td>
<td style="text-align:right;">
47.67555
</td>
</tr>
<tr>
<td style="text-align:left;">
Peru
</td>
<td style="text-align:left;">
ingles
</td>
<td style="text-align:right;">
62.42557
</td>
<td style="text-align:right;">
42.00124
</td>
<td style="text-align:right;">
54.44331
</td>
<td style="text-align:right;">
59.77507
</td>
<td style="text-align:right;">
67.88324
</td>
</tr>
<tr>
<td style="text-align:left;">
Peru
</td>
<td style="text-align:left;">
fisica
</td>
<td style="text-align:right;">
56.38901
</td>
<td style="text-align:right;">
53.80465
</td>
<td style="text-align:right;">
52.26922
</td>
<td style="text-align:right;">
48.56980
</td>
<td style="text-align:right;">
49.15695
</td>
</tr>
<tr>
<td style="text-align:left;">
Peru
</td>
<td style="text-align:left;">
quimica
</td>
<td style="text-align:right;">
53.32260
</td>
<td style="text-align:right;">
42.17516
</td>
<td style="text-align:right;">
38.32847
</td>
<td style="text-align:right;">
49.32692
</td>
<td style="text-align:right;">
97.47849
</td>
</tr>
<tr>
<td style="text-align:left;">
Venezuela
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:right;">
52.71443
</td>
<td style="text-align:right;">
74.62635
</td>
<td style="text-align:right;">
44.54666
</td>
<td style="text-align:right;">
64.38862
</td>
<td style="text-align:right;">
26.41973
</td>
</tr>
<tr>
<td style="text-align:left;">
Venezuela
</td>
<td style="text-align:left;">
lenguaje
</td>
<td style="text-align:right;">
40.29978
</td>
<td style="text-align:right;">
66.01256
</td>
<td style="text-align:right;">
26.16780
</td>
<td style="text-align:right;">
59.00542
</td>
<td style="text-align:right;">
25.65606
</td>
</tr>
<tr>
<td style="text-align:left;">
Venezuela
</td>
<td style="text-align:left;">
ingles
</td>
<td style="text-align:right;">
49.58254
</td>
<td style="text-align:right;">
49.62016
</td>
<td style="text-align:right;">
53.65942
</td>
<td style="text-align:right;">
59.65265
</td>
<td style="text-align:right;">
37.40039
</td>
</tr>
<tr>
<td style="text-align:left;">
Venezuela
</td>
<td style="text-align:left;">
fisica
</td>
<td style="text-align:right;">
49.91776
</td>
<td style="text-align:right;">
47.35345
</td>
<td style="text-align:right;">
56.54918
</td>
<td style="text-align:right;">
45.48047
</td>
<td style="text-align:right;">
49.94319
</td>
</tr>
<tr>
<td style="text-align:left;">
Venezuela
</td>
<td style="text-align:left;">
quimica
</td>
<td style="text-align:right;">
12.86133
</td>
<td style="text-align:right;">
55.28388
</td>
<td style="text-align:right;">
60.19107
</td>
<td style="text-align:right;">
51.25876
</td>
<td style="text-align:right;">
65.54343
</td>
</tr>
</tbody>
</table>

``` r
nivel_edu %>%  pivot_longer(starts_with("p_"), "periodo",values_to = "notas") %>% 
  head %>% kable()
```

<table>
<thead>
<tr>
<th style="text-align:left;">
pais
</th>
<th style="text-align:left;">
materia
</th>
<th style="text-align:left;">
periodo
</th>
<th style="text-align:right;">
notas
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:left;">
p_2014
</td>
<td style="text-align:right;">
50.52657
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:left;">
p_2016
</td>
<td style="text-align:right;">
51.19101
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:left;">
p_2018
</td>
<td style="text-align:right;">
66.91124
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:left;">
p_2020
</td>
<td style="text-align:right;">
67.04729
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
matematicas
</td>
<td style="text-align:left;">
p_2022
</td>
<td style="text-align:right;">
45.83746
</td>
</tr>
<tr>
<td style="text-align:left;">
Colombia
</td>
<td style="text-align:left;">
lenguaje
</td>
<td style="text-align:left;">
p_2014
</td>
<td style="text-align:right;">
57.62763
</td>
</tr>
</tbody>
</table>

#### gather()

-   key = “nombre” de las variable ID

-   value = “nombre” de la variable de valor

-   …/ c(…) = selección de las variables ID
