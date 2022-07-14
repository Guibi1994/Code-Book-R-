

pr <- data.frame(
  x = c("ERROR-name = guibor,apellido : camargo;",
        "name = guibor,apellido : camargo;",
        "name = tatiana,apellido : ortiz;",
        "name = reem,apellido : camargo;",
        "hola amigos name","13123", "dasJDFASDF  SDAF",
        "name = camilo,apellido : gonazales;"))

# Patrón con grupos de énfasis
pt <- "^n\\D{0,}\\s=\\s(\\D{0,}),\\D{0,}:\\s(.*);"
str_view(pr$x, pt)


# Adicionar elementos a los grupos (\\i para el "i" grupo)
str_subset(pr$x,pt) %>% 
  str_replace(pt,"\\1.\\2@urosario.edu.co")



# Revisar grupos
str_match(pr$x, pt) %>% .[,c(2,3)] %>% 
  data.frame() %>% 
  filter(!is.na(X1))

# Otra forma más directa de extraer números
pr %>% extract(x,c("Nombre","Apellidos"), regex = pt) %>% 
  filter(!is.na(Nombre))




### Dividir grupos

x = c("ERROR-name = guibor,apellido : camargo;",
      "name = guibor,apellido : camargo;",
      "name = tatiana,apellido : ortiz;",
      "name = reem,apellido : camargo;",
      "hola amigos name","13123", "dasJDFASDF  SDAF",
      "name = camilo,apellido : gonazales;")

pr <- str_split(x,",", simplify = T)
pr[1,]


