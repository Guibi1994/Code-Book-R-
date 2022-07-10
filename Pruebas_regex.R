# read in raw murders data from Wikipedia
url <- "https://en.wikipedia.org/w/index.php?title=Gun_violence_in_the_United_States_by_state&direction=prev&oldid=810166167"
murders_raw <- read_html(url) %>% 
  html_nodes("table") %>% 
  html_table() %>%
  .[[1]] %>%
  setNames(c("state", "population", "total", "murder_rate"))

cat("asdas'")



library(stringr)
x <- "2,290,220"
y <- c("[89]123","hola","HOLA[9]0123","as555","hOLa145",
       "adios[]2$","adios999","lllaa","lesdssdf","HOLA_ADIOS","asd3d3","2","a",
       "b","3","[999]1234[990]",
       "009ADIOS","HOOOLA[HOLA]55", "88HOOOLA[hola]789[2]","HOOOLA(hola)",
       "[999][[4556[[55]")

str_extract(y,"\\d")


# revisar más de dos variables
str_view(y,"hola|adios")
str_subset(y, "hola|adios")

# reviasar conjutnos de letras []
str_view(y, "[hola]")
str_subset(y, "[hola]")


# revisat conjutnos de numeros
str_view(y,"[0-9]")
str_subset(y, "[0-9]")



# extrer todas las letras (minuscolas o mayusculas)
str_view(y,"[a-zA-Z]")
str_extract(y, "[a-zA-Z]")

"^" # Marca el inicio de un string
"$" # Marca el final de un string

# Entonces par selecioanr los trings que tegan solo un caracetr numerico
"^\\d$" # Es en donde el primer caractre "^" es un dígito "\\d" y luego acaba "$"


str_view(y, "^\\d$")




# Los {} sirven para denotar cantidades
str_view(y, "\\d{1,10}")


# pr

str_view(y, "\\]\\d|\\d\\[")


