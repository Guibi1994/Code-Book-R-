Code Book ver 2.0
================
Guibor Camargo (<guibor.camargo@urosario.edu.co>)\|\|
2022-07-03

# Introducción

Este guía es para aprender nociones básicas e intermedias de análisis de
datos **R**. La intención es guíar al lector de manera consitente y
resumida por alguas de las principales técnias en ciencia de datos y
econometría en **R**. De esta manera, no se asume nada (o casi nada)
sobre el lector: es decir, es una guía tanto para principiantes como
para usuarios con conocimientos previos en programación y/o
estadísticas.

#### Contenidos:

-   [“Regex” manejo
    básico](https://github.com/Guibi1994/Code-Book-R-/blob/main/00_Code_Book_2.0.md#regex-manejo-b%C3%A1sico)

-   [Fundamentos de Web-scraping en
    R](https://github.com/Guibi1994/Code-Book-R-/blob/main/00_Code_Book_2.0.md#fundamentos-de-web-scraping-en-r)

    -   [Estructura de un HTML (lo que hay que
        saber)](https://github.com/Guibi1994/Code-Book-R-/blob/main/00_Code_Book_2.0.md#estructura-de-un-html-lo-que-hay-que-saber)

    -   [Web scraping de
        tablas](https://github.com/Guibi1994/Code-Book-R-/blob/main/00_Code_Book_2.0.md#web-scraping-de-tablas)

    -   Web scraping de páginas

    -   Web scrapping de múltiples páginas (páginas anidadas)

    -   Web scrapping en páginas de consultas

    -   Cuando hay un “captcha”

    -   Web scraping en entórnos de JavaCript

-   [Notas sobre Data
    wrangling](https://github.com/Guibi1994/Code-Book-R-/blob/main/00_Code_Book_2.0.md#notas-sobre-datawrangling)

# Regex y text mining

## ¿Qué es regex?

``` r
# Liberrias principales
library(stringr)
library(tidytext)

# Librerias complementarias
library(dplyr) # Manejo de bases de datos
library(tidyr) # Manejo de bases de datos
```

“Regex” (contracción del término *expresion regular* en inglés) es una
sintáxis universal de textos. Es básicamente una lenguaje común, en casi
cualquier entorno de programación, que se emplea para hacer consultas
dentro de un texto o “string”: es decir **para identificar patrones en
una cadena de texto o *string***. En “regex” cada letra, espacio,
simbolo o número es un **caracter independiente** y tiene una manera
difernte de consultarse. El conocimiento básico de esta sintáxis para el
manejo de textos, es uno de los pilares fundamentales de otras técnicas
como “text mining”, “web-scraping” y “sentiment analysis” entre otras.

Lo mostrado aca se base principalmente en las clases de [análisis de
textos del curso edX de la Universidad de Harvard en Data
Science](https://rafalab.github.io/dslibro/procesamiento-de-cadenas.html "Contulte acá el capítulo de manejo de textos de ese curso").
Sin embargo tambien hay muchos recursos sobre este tema en internet:

-   [Cheat sheet para la libreria
    StringR](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)

-   [Cheat sheet
    regex](https://cheatography.com/davechild/cheat-sheets/regular-expressions/)
    (ejemplo 1)

-   [Cheat sheet regex](https://www.rexegg.com/regex-quickstart.html)
    (ejemplo 2)

-   etc (…)

Anque en esta guía no profundizaremos sobre el tema de regex, en la
siguiente tabla se mostraran algunos comnados que son muy útiles y
comunes a gran parte de las operaciones que se comunmente podemos hacer
con regex en **R**. Finalmente, es importante tener en cuenta que todos
los caracteres especiales en regex en **R** (`?`, `%`, `(`, `[`, `@`,
etc) es necesario escribirlos con el prefijo “`\\`” (`\\?`, `\\%`,
`\\(`, `\\[`, `\\@`, etc) , para que no se confundan con funciones
dentro de regex.

|                 Funcion                 | Descripción                                                                                           |
|:---------------------------------------:|-------------------------------------------------------------------------------------------------------|
|                 `(.*)`                  | Todo                                                                                                  |
|                 `[^]*`                  | Todo exepto. Ejemplo: `[^.]*` siginifica todo exepto el simbolo punto (“.”)                           |
|                `^` o `$`                | Al **principio** o al **final** de un string                                                          |
|     `[a-z]` o `[A-Z]` o `[a-zA-Z]`      | Cualquier caracter alfabético en minusculas, en mayusculas o sin importar si es mayuscula o minuscula |
| `[:lower:]` o `[:upper:]` o `[:alpha:]` | Cualquier caracter alfabético en minusculas, en mayusculas o sin importar si es mayuscula o minuscula |
|                `[a-z ]`                 | Cualquier caracter alfabético en minusculas y/o cualquier espacio                                     |
|      `[:digit:]` o `\\d` o `[0-9]`      | Cualquier caracter numérico                                                                           |
|                   `?`                   | Identificar 0 a 1 vez (“*puede estar o no*”)                                                          |
|                   `+`                   | Identificar 1 o más veces (“*Está al menos una vez*”)                                                 |
|                   `*`                   | Identificar 0 o más veces (“*puede no estar o estar muchas veces*”)                                   |
|        `{2}` o `{2,}` o `{2,4}`         | Identificar 2 veces, 2 o más veces, o de 2 a 4 veces                                                  |
|                 `(  )`                  | Definir grupos de extracción                                                                          |

## La libreria “stringr”

La libreria “`stringr`” esta diseñada para facilitar el análisis de
textos a partir de expresiones regulares -“regex”. Posee un gran número
de funciones muy utiles y vale la pena darle una revisada más profunda
realizando algunos ejercicis por cuanta propia. Sin embargo, veremos acá
un par de funciones muy útiles de esta libreria, que son usadas
frecuentemente en una análisis típico. Trabajaremos en este ejemplo con
el siguiente conjutno de *strings*:

``` r
ejemplo <- c("123", " 123", "abc", " def", "abc123")
ejemplo
```

    ## [1] "123"    " 123"   "abc"    " def"   "abc123"

-   `str_view()` : Es uno de los comándos más utiles de esta libreria,
    ya que nos permite previzualizar el resultado de nuestra aplicar
    nuestra expresión regular a un o varios textos.

    ``` r
    str_view(ejemplo, "^\\d{0,}")
    ```

-   sad

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
library(ggplot2) # Creaicón de gráficas
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

## Web scraping de páginas

## Web scrapping de múltiples páginas (páginas anidadas)

## Web scrapping en páginas de consultas

### Cuando hay un “captcha”

## Web scraping en entórnos de JavaCript

# Notas sobre Data wrangling

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
    ##  1 America latina Colombia  matematicas  43.6    59.4   48.3   46.5   43.7
    ##  2 America latina Colombia  lenguaje     64.2    64.7   48.6   59.0   48.4
    ##  3 America latina Colombia  ingles       56.1    52.9   71.8   79.3   72.9
    ##  4 America latina Colombia  fisica       37.9    58.2   70.1   47.9   53.8
    ##  5 America latina Colombia  quimica      25.1    64.1   62.2   62.2   45.8
    ##  6 America latina Peru      matematicas  60.5    51.4   58.8   60.5   57.4
    ##  7 America latina Peru      lenguaje     62.8    68.5   50.4   51.0   62.8
    ##  8 America latina Peru      ingles       62.3    74.0   39.4   70.0   47.0
    ##  9 America latina Peru      fisica        7.66   48.0   52.9   69.9   45.5
    ## 10 America latina Peru      quimica      73.3    38.1   56.7   54.0   57.0
    ## 11 America latina Venezuela matematicas  24.1    70.3   81.5   63.2   66.5
    ## 12 America latina Venezuela lenguaje     30.5    42.8   69.0   63.7  110. 
    ## 13 America latina Venezuela ingles       27.3    49.1   69.2   67.5  118. 
    ## 14 America latina Venezuela fisica       69.8    50.8   57.0   53.9   46.0
    ## 15 America latina Venezuela quimica      56.6    76.6   41.5   70.4   71.1

``` r
# pivot_longer() cumple la misma función de "melt()"
nivel_edu <- nivel_edu %>% 
  pivot_longer(starts_with("p_"), "periodo",values_to = "notas")
nivel_edu
```

    ## # A tibble: 75 x 5
    ##    region         pais     materia     periodo notas
    ##    <chr>          <chr>    <chr>       <chr>   <dbl>
    ##  1 America latina Colombia matematicas p_2014   43.6
    ##  2 America latina Colombia matematicas p_2016   59.4
    ##  3 America latina Colombia matematicas p_2018   48.3
    ##  4 America latina Colombia matematicas p_2020   46.5
    ##  5 America latina Colombia matematicas p_2022   43.7
    ##  6 America latina Colombia lenguaje    p_2014   64.2
    ##  7 America latina Colombia lenguaje    p_2016   64.7
    ##  8 America latina Colombia lenguaje    p_2018   48.6
    ##  9 America latina Colombia lenguaje    p_2020   59.0
    ## 10 America latina Colombia lenguaje    p_2022   48.4
    ## # ... with 65 more rows

``` r
# pivot_wider() cumple la misma función que "dcast()"
nivel_edu %>%
  pivot_wider(names_from = materia, values_from = notas)
```

    ## # A tibble: 15 x 8
    ##    region         pais      periodo matematicas lenguaje ingles fisica quimica
    ##    <chr>          <chr>     <chr>         <dbl>    <dbl>  <dbl>  <dbl>   <dbl>
    ##  1 America latina Colombia  p_2014         43.6     64.2   56.1  37.9     25.1
    ##  2 America latina Colombia  p_2016         59.4     64.7   52.9  58.2     64.1
    ##  3 America latina Colombia  p_2018         48.3     48.6   71.8  70.1     62.2
    ##  4 America latina Colombia  p_2020         46.5     59.0   79.3  47.9     62.2
    ##  5 America latina Colombia  p_2022         43.7     48.4   72.9  53.8     45.8
    ##  6 America latina Peru      p_2014         60.5     62.8   62.3   7.66    73.3
    ##  7 America latina Peru      p_2016         51.4     68.5   74.0  48.0     38.1
    ##  8 America latina Peru      p_2018         58.8     50.4   39.4  52.9     56.7
    ##  9 America latina Peru      p_2020         60.5     51.0   70.0  69.9     54.0
    ## 10 America latina Peru      p_2022         57.4     62.8   47.0  45.5     57.0
    ## 11 America latina Venezuela p_2014         24.1     30.5   27.3  69.8     56.6
    ## 12 America latina Venezuela p_2016         70.3     42.8   49.1  50.8     76.6
    ## 13 America latina Venezuela p_2018         81.5     69.0   69.2  57.0     41.5
    ## 14 America latina Venezuela p_2020         63.2     63.7   67.5  53.9     70.4
    ## 15 America latina Venezuela p_2022         66.5    110.   118.   46.0     71.1
