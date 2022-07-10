Code Book ver 2.0
================
Guibor Camargo (<guibor.camargo@urosario.edu.co>)\|\|
2022-07-03

# “Regex” manejo básico

“Regex” es una sintáxis universal de textos. Es básicamente una lenguaje
común, en muchos entornos de programación, que se emplea para hacer
consultas dentro de un texto o “string”. En “regex” cada letra, espacio,
simbolo o número es un **caracter independiente** y tiene una manera
difernte de consultarse. El conocimiento básico de esta sintáxis para el
manejo de textos, es uno de los pilares fundamentales de otras técnicas
como “text mining”, “web-scraping” y “sentiment analysis” entre otras.
Lo mostrado aca se base principalmente en las clases de [análisis de
textos del curso edX de harvard en
Data-Science](https://rafalab.github.io/dslibro/procesamiento-de-cadenas.html "Contulte acá el capítulo de manejo de textos de ese curso")

``` r
# Liberria principal
library(stringr)

# Librerias complementarias
library(dplyr) # Manejo de bases de datos
library(tidyr) # Manejo de bases de datos
```

# Fundamentos de Web-scraping en R

*Web scraping* o web harvesting hace referencia al conjutno de técnicasl
empleadas para extraer información en la wed que no esta necesariamente
empaquetada en un objeto o archivo consumible de manera directa .

``` r
# libreira principal
library(rvest) # Para web scraping

# librerias complementarias
library(dplyr) # Manejo de bases de datos
library(tidyr) # Manejo de bases de datos
library(ggplot2) # creaicón de gráficas
```

## Estructura de un HTML (lo que hay que saber)

Los documentos **HTML** (*Hypert Text Markup*) son archivos
estructurados que contienen una semántica regular, y son los que por lo
general podemos observar detrás de las páginas web (la mayoria de
ellas). Si dentro de una págian web damos “click secudnario” y luego
“inspecionar” (o tambien “**Ctrl+u**”), podemos ver con clairdad el
documetno HTML detras de ella.

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

-   `<title>` : El título de la pagina en cuestion (el que finalmente se
    muestra en el buscador/browser)

-   `<body>` :El contiendo de la página en cuestión.

Otros tags comunes son `<p>`(para denominar parrafos), `<table>`(para
denominar tablas), `<img>`(para denominar imágenes), `<map>`(para
denóminar mapas), etc… [En el éste enlace puedes ver una lista de tagas
comúnes en un documento
HTML](https://www.w3schools.com/TAgs/default.asp "Tags de referencia").

## Web scraping de tablas

En este ejemplo utilizaremos la página web de [Wilkipedia del PIB
(Prodcucto Interno Bruto) por
paises](https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal) "¡Haz click aqui!"),
para emplear las técnicas básicas de web scrping en **R**. Los pasos a
seguir asumen que ya instalamos y cargamos la libreria Rvest:
`library(rvest)`

1.  Extraemos la URL (el *link*) de la página en donde se encutra
    nuestra tabla

2.  Con la función `read_html` podemos leer el archivo HTML detrás del
    link. Este será leido como un arichivo tipo XML en forma de *lista*
    de elementos.

    ``` r
    PIB_paises <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)")
    ```

3.  El siguiente paso, consite en utilizar el comando `html_nodes` ( OJO
    “nodes” no “node”) para buscar el nodo que nos interesa. En este
    caso el nodo que nos interesa es `<table>` por que estamos
    extrallendo directamente una tabla del documento HTML. Basicamente
    estamos solicitando filtrar todos los nodos y solo quedarnos con
    aquellos cuyo ***tag*** sea “table”, y estos quedara guardados en
    una *lista.*

    ``` r
    PIB_paises <- PIB_paises %>% html_nodes("table")
    ```

4.  El siguiente paso puede ser un poco engañoso. Una vez extraigamos el
    nodo “table”, realmente estamos extrallendo no uno, sino todos los
    nodos llamados “table” presentes en el documento HTML. En nuestro
    caso, podemos ver cómo una vez extremos el nodo “table” tenemos un
    total de 7 nodos con ese nombre ¿cuál es el número del nodo que nos
    interesa?

    Para saberlo podemos inspeccionar la página (**Ctrl+u**) y buscar
    (**Ctrl+f**) “\<table”, y luego deteminar cuál es el número del nodo
    “table” que da apertura a la tabla que nos interesa extraer. Otra
    forma es con prueba y error, pero es más efectivo de la primera
    manera. En nuestro ejemplo (como se ve a continuación), el nodo \#3
    que encontramos en el documento HTML el que da apertura a la tabla
    que nos interesa extraer.

    <p align="center">

    <img src="00_Code_Book_2.0_files/figure-gfm/prueba3.png" alt="estructura_html" width="484"/>

    </p>

    En nuestro ejemplo (como se en la imágen anterior), el **3*er*
    nodo** que encontramos en el documento HTML, es el que da apertura a
    la tabla que nos interesa extraer.

    :gift: **TIP** :gift:**:** En algunos casos, dentro del código HTML
    las tablas tiene un “id” despues del *tag*: (ejm)
    `<table id="Nombre_tabla">` . En estos casos podemos usar el comando
    `html_nodes("table#Nombre_tabla")` para extraer específicamente la
    tabla que queremos. Sin embargo en este caso (como un muchos) no
    existe esta posilidad por la falta de un indentficador específico de
    la tabla.

5.  Ya sabemos que 3*er* elemento en nuestra lista es el nodo que
    contiene una **tabla** que nos interesa. Lo siguiente es usar el
    comando `html_table()` para especificar que es un nodo “tipo tabla”,
    y extraer 3er nodo posteriormente (podemo utilizar la sintáxis
    básica de R para indicar la consulta del 3er elemento de la lista:
    `[[3]]` o tambien `[3]` ). Podemos tambien de una vez en el mismo
    paso converir el resultado a una “data.frame” y/o a un “tible”.

    ``` r
    PIB_paises <- PIB_paises %>% 
      # Leer la/s tabla/s del documento HTML
      html_table() %>%
      # Acceder el 3er elemento de la lista
      .[[3]] %>% 
      # Cambiar a formato de base de datos
      as.data.frame()

    head(PIB_paises,5)
    ```

        ##   Country/Territory UN Region IMF[1][12] IMF[1][12] United Nations[13]
        ## 1 Country/Territory UN Region   Estimate       Year           Estimate
        ## 2             World         - 93,863,851       2021         87,461,674
        ## 3     United States  Americas 25,346,805       2022         20,893,746
        ## 4             China      Asia 19,911,593  [n 2]2022         14,722,801
        ## 5             Japan      Asia  4,912,147       2022          5,057,759
        ##   United Nations[13] World Bank[14][15] World Bank[14][15]
        ## 1               Year           Estimate               Year
        ## 2               2020         84,705,567               2020
        ## 3               2020         20,936,600               2020
        ## 4          [n 3]2020         14,722,731               2020
        ## 5               2020          4,975,415               2020

6.  :recycle: **RESUMEN:** Ya los pasos siguientes son realizar los
    arreglos correspondientes que se tengan que hacer para cada paso
    puntual. Pero ya extraimos la información. Incluso podemos hacer
    todo en una sola línea de código

    ``` r
    PIB_paises <- 
      # 1. Leer HTML desde la URL
      read_html("https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)") %>% 
      # 2. Extrer nodos llamados "table"
      html_nodes("table") %>% 
      # 3. Convertir a formato tabla
      html_table() %>% 
      # 4. Extaer el elemnto de interes
      .[[3]] %>% 
      # 5. Transformar a una base de datos
      as.data.frame() %>% 


      # - - - - - - - - - - - -
      # Pasos EXTRA: Limpiar un poco la base (cada caso es particular)
      janitor::row_to_names(row_number = 1) %>% 
      rename(Pais = 1,Region = 2, PIB_FMI=3,p_FMI=4,PIB_ONU=5,p_ONU=6,PIB_BM = 7,
             p_BM = 8) %>% 
      mutate(across(PIB_FMI:p_BM,~gsub(",","",.))) %>% as_tibble()

    PIB_paises
    ```

        ## # A tibble: 217 x 8
        ##    Pais           Region   PIB_FMI  p_FMI     PIB_ONU  p_ONU     PIB_BM   p_BM 
        ##    <chr>          <chr>    <chr>    <chr>     <chr>    <chr>     <chr>    <chr>
        ##  1 World          -        93863851 2021      87461674 2020      84705567 2020 
        ##  2 United States  Americas 25346805 2022      20893746 2020      20936600 2020 
        ##  3 China          Asia     19911593 [n 2]2022 14722801 [n 3]2020 14722731 2020 
        ##  4 Japan          Asia     4912147  2022      5057759  2020      4975415  2020 
        ##  5 Germany        Europe   4256540  2022      3846414  2020      3806060  2020 
        ##  6 India          Asia     3534743  2022      2664749  2020      2622984  2020 
        ##  7 United Kingdom Europe   3376003  2022      2764198  2020      2707744  2020 
        ##  8 France         Europe   2936702  2022      2630318  2020      2603004  2020 
        ##  9 Canada         Americas 2221218  2022      1644037  2020      1643408  2020 
        ## 10 Italy          Europe   2058330  2022      1888709  2020      1886445  2020 
        ## # ... with 207 more rows

## Web scrapping de paginas

## Web scrapping de múltiples páginas (páginas anidadas)

## Web scrapping en páginas con consultas

### Cuando hay un “captcha”

## Web scraping en entórnos de

# Notas sobre data/wrangling

``` r
#  Base inicial
nivel_edu <- data.frame(
  region = "America latina",
  pais = c(sample("Colombia",5,T),sample("Peru",5,T),sample("Venezuela",5,T)),
  materia = c("matematicas","lenguaje", "ingles", "fisica", "quimica"),
  p_2014 = rnorm(15,50,15),
  p_2016 = rnorm(15,55,10),
  p_2018 = rnorm(15,54,13),
  p_2020 = rnorm(15,61,8),
  p_2022 = rnorm(15,67,19)) %>% 
  as_tibble()

nivel_edu
```

    ## # A tibble: 15 x 8
    ##    region         pais      materia     p_2014 p_2016 p_2018 p_2020 p_2022
    ##    <chr>          <chr>     <chr>        <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
    ##  1 America latina Colombia  matematicas   54.1   55.7   21.2   53.2   45.9
    ##  2 America latina Colombia  lenguaje      43.3   61.7   85.7   62.4   45.8
    ##  3 America latina Colombia  ingles        59.6   48.5   44.4   59.4   39.7
    ##  4 America latina Colombia  fisica        40.8   69.7   64.1   66.2   44.0
    ##  5 America latina Colombia  quimica       59.8   60.5   58.0   60.6   80.1
    ##  6 America latina Peru      matematicas   59.8   58.4   34.7   76.1   74.9
    ##  7 America latina Peru      lenguaje      53.8   57.2   68.8   39.8   65.5
    ##  8 America latina Peru      ingles        58.6   52.2   37.0   54.5   97.3
    ##  9 America latina Peru      fisica        60.8   58.1   43.1   63.1   80.7
    ## 10 America latina Peru      quimica       56.5   53.3   54.9   56.1   54.1
    ## 11 America latina Venezuela matematicas   31.3   57.0   33.9   71.0   38.6
    ## 12 America latina Venezuela lenguaje      84.0   42.1   31.0   55.3   64.8
    ## 13 America latina Venezuela ingles        42.3   53.8   45.2   44.0   34.7
    ## 14 America latina Venezuela fisica        49.4   67.6   51.5   57.4   71.1
    ## 15 America latina Venezuela quimica       59.0   41.7   50.5   57.3   44.2

``` r
# pivot_longer() cumple la misma función de "melt()"
nivel_edu <- nivel_edu %>% 
  pivot_longer(starts_with("p_"), "periodo",values_to = "notas")
nivel_edu
```

    ## # A tibble: 75 x 5
    ##    region         pais     materia     periodo notas
    ##    <chr>          <chr>    <chr>       <chr>   <dbl>
    ##  1 America latina Colombia matematicas p_2014   54.1
    ##  2 America latina Colombia matematicas p_2016   55.7
    ##  3 America latina Colombia matematicas p_2018   21.2
    ##  4 America latina Colombia matematicas p_2020   53.2
    ##  5 America latina Colombia matematicas p_2022   45.9
    ##  6 America latina Colombia lenguaje    p_2014   43.3
    ##  7 America latina Colombia lenguaje    p_2016   61.7
    ##  8 America latina Colombia lenguaje    p_2018   85.7
    ##  9 America latina Colombia lenguaje    p_2020   62.4
    ## 10 America latina Colombia lenguaje    p_2022   45.8
    ## # ... with 65 more rows

``` r
# pivot_wider() cumple la misma función que "dcast()"
nivel_edu %>%
  pivot_wider(names_from = materia, values_from = notas)
```

    ## # A tibble: 15 x 8
    ##    region         pais      periodo matematicas lenguaje ingles fisica quimica
    ##    <chr>          <chr>     <chr>         <dbl>    <dbl>  <dbl>  <dbl>   <dbl>
    ##  1 America latina Colombia  p_2014         54.1     43.3   59.6   40.8    59.8
    ##  2 America latina Colombia  p_2016         55.7     61.7   48.5   69.7    60.5
    ##  3 America latina Colombia  p_2018         21.2     85.7   44.4   64.1    58.0
    ##  4 America latina Colombia  p_2020         53.2     62.4   59.4   66.2    60.6
    ##  5 America latina Colombia  p_2022         45.9     45.8   39.7   44.0    80.1
    ##  6 America latina Peru      p_2014         59.8     53.8   58.6   60.8    56.5
    ##  7 America latina Peru      p_2016         58.4     57.2   52.2   58.1    53.3
    ##  8 America latina Peru      p_2018         34.7     68.8   37.0   43.1    54.9
    ##  9 America latina Peru      p_2020         76.1     39.8   54.5   63.1    56.1
    ## 10 America latina Peru      p_2022         74.9     65.5   97.3   80.7    54.1
    ## 11 America latina Venezuela p_2014         31.3     84.0   42.3   49.4    59.0
    ## 12 America latina Venezuela p_2016         57.0     42.1   53.8   67.6    41.7
    ## 13 America latina Venezuela p_2018         33.9     31.0   45.2   51.5    50.5
    ## 14 America latina Venezuela p_2020         71.0     55.3   44.0   57.4    57.3
    ## 15 America latina Venezuela p_2022         38.6     64.8   34.7   71.1    44.2
