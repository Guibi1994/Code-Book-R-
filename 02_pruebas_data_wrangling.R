
library(dslabs)
library(tidyverse)

path <- system.file("extdata", package = "dslabs")
list.files(path)
file.copy(file.path(path, "murders.csv"), getwd())
file.show("murders.csv")


read.csv("murders.csv")

url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"
dat <- read_csv(url)
download.file(url, "murders.csv")
tempfile()
tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename)