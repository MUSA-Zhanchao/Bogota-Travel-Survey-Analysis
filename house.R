library(tidyverse)
library(nnet)

trips <- readRDS("data/008-24 BBDD Procesamiento Etapas.rds")
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

per_complt <- per %>% 
  left_join(hog,by="ID_Hogar")

dependent_variable<- "P87"
independent_variables <- c("P1", "P2", "P3", "P4", "P42", "P43", "P45", 
                           "P50", "P65_1", "P12", "P14","Localidad", 
                           "Edad", "P10", "P12", "P14", "P82", "P83", "P86")

regressor<- per_complt %>% 
  select(all_of(dependent_variable), all_of(independent_variables))

library(haven)

regressor <- regressor %>%
  mutate(
    across(
      where(is.labelled),    # pick all haven_labelled columns
      ~ zap_labels(.)        # strip off the labels, leaving the underlying numeric
    )
  )

