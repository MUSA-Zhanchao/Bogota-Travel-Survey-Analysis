library(tidyverse)
library(nnet)

trips <- readRDS("data/008-24 BBDD Procesamiento Etapas.rds")
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

per_complt <- per %>% 
  left_join(hog,by="ID_Hogar")

dependent_variable<- "P87"
independent_variables <- c("P1", "P3", "P42", 
                           "P50", "P65_1", "P12", "P14", 
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
regressor$P87 <- as.factor(regressor$P87)
regressor$P87<-relevel(regressor$P87, ref = "2") # Relevel to set the reference category

regressor<-regressor%>%
  rename(house=P1,
         pop_num=P3,
         major_trans_2020=P42,
         income= P50,
         travel= P65_1,
         rent_own= P82,
         live_time= P83,
         rent_cost= P86
         )

regressor<-regressor%>%
  rename(edu_att= P12,
         occupation= P14,
         gender= P10,
         age= Edad,
         )

regressor$house <- as.factor(regressor$house)
regressor$income<- as.factor(regressor$income)
regressor$travel<- as.factor(regressor$travel)
regressor$rent_own<- as.factor(regressor$rent_own)
regressor$occupation <- as.factor(regressor$occupation)
regressor$gender <- as.factor(regressor$gender)
regressor$live_time <- as.factor(regressor$live_time)
regressor$rent_cost <- as.factor(regressor$rent_cost)
regressor$age <- as.factor(regressor$age)

regressor$edu_att <- dplyr::case_when(
  regressor$edu_att %in% c(1, 2, 3) ~ "Primary",
  regressor$edu_att %in% c(4, 5) ~ "LowerSecondary",
  regressor$edu_att %in% c(6, 7) ~ "UpperSecondary",
  regressor$edu_att %in% c(8, 9) ~ "Technological",
  regressor$edu_att %in% c(10, 11, 12, 13) ~ "University",
  regressor$edu_att == 97 ~ "None",
)
regressor<-regressor %>%
  mutate(major_trans_2020= case_when(
    major_trans_2020 %in% c(1,2,3,4,5,6,10,16) ~ "public_tansit",
    major_trans_2020 %in% c(7,8,9) ~ "informal",
    major_trans_2020 %in% c(11,12) ~ "taxi",
    major_trans_2020 %in% c(22,23) ~ "personal_veh",
    major_trans_2020 %in% c(24,25) ~"motorcyle",
    major_trans_2020 %in% c(25,27,28,17) ~ "bicycle",
    major_trans_2020==34 ~ "walking",
    TRUE ~ "other"
))


model_house<-multinom(P87~.,data=regressor)
summary(model_house)

z<-summary(model_house)$coefficients/summary(model_house)$standard.errors
p_values<- (1 - pnorm(abs(z), 0, 1)) * 2
