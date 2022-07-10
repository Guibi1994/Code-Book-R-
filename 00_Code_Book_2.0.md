Code Book ver 2.0
================
Guibor Camargo (<guibor.camargo@urosario.edu.co>)\|\|
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
    nodo “table”, realmente estamos extrallendo no uno sino todos los
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
    ##  1 America latina Colombia  matematicas   51.6   61.9  59.9    56.5   75.7
    ##  2 America latina Colombia  lenguaje      39.4   47.9  66.0    62.0   63.7
    ##  3 America latina Colombia  ingles        58.6   57.3  53.3    70.9   81.6
    ##  4 America latina Colombia  fisica        32.6   73.3  46.3    69.5   82.0
    ##  5 America latina Colombia  quimica       54.1   48.9  52.7    54.1   77.5
    ##  6 America latina Peru      matematicas   78.7   60.0  49.6    67.7   66.1
    ##  7 America latina Peru      lenguaje      49.4   67.3  48.0    61.6   30.6
    ##  8 America latina Peru      ingles        24.5   74.9  74.9    65.9   62.3
    ##  9 America latina Peru      fisica        56.6   39.9  35.5    58.4   61.1
    ## 10 America latina Peru      quimica       62.4   56.6  56.4    63.0   50.8
    ## 11 America latina Venezuela matematicas   70.7   55.5  53.5    52.7   67.9
    ## 12 America latina Venezuela lenguaje      59.0   57.8   3.13   53.5   66.0
    ## 13 America latina Venezuela ingles        43.9   54.8  64.6    60.2   48.5
    ## 14 America latina Venezuela fisica        28.6   57.3  62.4    63.1   57.9
    ## 15 America latina Venezuela quimica       67.3   61.2  57.5    69.8   61.5

``` r
# pivot_longer() cumple la misma función de "melt()"
nivel_edu <- nivel_edu %>% 
  pivot_longer(starts_with("p_"), "periodo",values_to = "notas")
nivel_edu
```

    ## # A tibble: 75 x 5
    ##    region         pais     materia     periodo notas
    ##    <chr>          <chr>    <chr>       <chr>   <dbl>
    ##  1 America latina Colombia matematicas p_2014   51.6
    ##  2 America latina Colombia matematicas p_2016   61.9
    ##  3 America latina Colombia matematicas p_2018   59.9
    ##  4 America latina Colombia matematicas p_2020   56.5
    ##  5 America latina Colombia matematicas p_2022   75.7
    ##  6 America latina Colombia lenguaje    p_2014   39.4
    ##  7 America latina Colombia lenguaje    p_2016   47.9
    ##  8 America latina Colombia lenguaje    p_2018   66.0
    ##  9 America latina Colombia lenguaje    p_2020   62.0
    ## 10 America latina Colombia lenguaje    p_2022   63.7
    ## # ... with 65 more rows

``` r
# pivot_wider() cumple la misma función que "dcast()"
nivel_edu %>%
  pivot_wider(names_from = materia, values_from = notas)
```

    ## # A tibble: 15 x 8
    ##    region         pais      periodo matematicas lenguaje ingles fisica quimica
    ##    <chr>          <chr>     <chr>         <dbl>    <dbl>  <dbl>  <dbl>   <dbl>
    ##  1 America latina Colombia  p_2014         51.6    39.4    58.6   32.6    54.1
    ##  2 America latina Colombia  p_2016         61.9    47.9    57.3   73.3    48.9
    ##  3 America latina Colombia  p_2018         59.9    66.0    53.3   46.3    52.7
    ##  4 America latina Colombia  p_2020         56.5    62.0    70.9   69.5    54.1
    ##  5 America latina Colombia  p_2022         75.7    63.7    81.6   82.0    77.5
    ##  6 America latina Peru      p_2014         78.7    49.4    24.5   56.6    62.4
    ##  7 America latina Peru      p_2016         60.0    67.3    74.9   39.9    56.6
    ##  8 America latina Peru      p_2018         49.6    48.0    74.9   35.5    56.4
    ##  9 America latina Peru      p_2020         67.7    61.6    65.9   58.4    63.0
    ## 10 America latina Peru      p_2022         66.1    30.6    62.3   61.1    50.8
    ## 11 America latina Venezuela p_2014         70.7    59.0    43.9   28.6    67.3
    ## 12 America latina Venezuela p_2016         55.5    57.8    54.8   57.3    61.2
    ## 13 America latina Venezuela p_2018         53.5     3.13   64.6   62.4    57.5
    ## 14 America latina Venezuela p_2020         52.7    53.5    60.2   63.1    69.8
    ## 15 America latina Venezuela p_2022         67.9    66.0    48.5   57.9    61.5
