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
```

## Estructura de un HTML

Los documentos **HTML** (*Hypert Text Markup*) son archivos
estructurados que contienen una semántica regular, y son los que por lo
general podemos observar detrás de las páginas web (la mayoria de
ellas). Si dentro de una págian web damos “click secudnario” y luego
“inspecionar” (o tambien “**Ctrl+u**”), podemos ver con clairdad el
documetno HTMl detras de ella.

Cómo lenguaje de porgramación tiene una sintaxis y una estructura
lógica: es decir, tiene unos patrones que pueden ser aprovechados a la
hora de extrear información. Un ejemplo de esto es que cada componete de
una documento HTML, estan **encapsulados** en etos “**nodos**”. Un
ejemplo de esto son los títulos en un documento HTML:
`<title>"Un gran titulo"</titile>` . Precisamente esta estructura de
nodos nos permite detectar patrones y elementos putnuales dentro de
estos documentos.

Algunos elementos comúnes en un documento HTML son:

-   

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

``` r
cars %>% ggplot(aes(speed, dist))+
  geom_point()
```

![](00_Code_Book_2.0_files/figure-gfm/primer_paso-1.png)<!-- -->
