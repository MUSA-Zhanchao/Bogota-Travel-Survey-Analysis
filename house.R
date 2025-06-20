library(tidyverse)
library(nnet)
library(haven)

trips <- readRDS("data/008-24 BBDD Procesamiento Etapas.rds")
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

per_complt <- per %>%
  left_join(hog,by="ID_Hogar")

dependent_variable<- "P87"
independent_variables <- c("P1", "P3", "P42",
                           "P50", "P12", "P14",
                           "Edad", "P10", "P12","P13","P15", "P14", "P82", "P83")

regressor<- per_complt %>%
  select(all_of(dependent_variable), all_of(independent_variables))


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
         rent_own= P82,
         live_time= P83
         )

regressor<-regressor%>%
  rename(edu_att= P12,
         occupation= P14,
         gender= P10,
         age= Edad
         )

regressor$house <- as.factor(regressor$house)
regressor$house<- relevel(regressor$house, ref = "4") # Relevel to set the reference category
regressor$rent_own<- as.factor(regressor$rent_own) # own =1, rent =2
regressor$rent_own <- relevel(regressor$rent_own, ref = "1") # Relevel to set the reference category
regressor$gender <- as.factor(regressor$gender) #female =1, male=2
regressor$gender <- relevel(regressor$gender, ref = "2") # Relevel to set the reference category


regressor$edu_att <- dplyr::case_when(
  regressor$edu_att %in% c(1, 2, 3) ~ "Primary",
  regressor$edu_att %in% c(4, 5) ~ "LowerSecondary",
  regressor$edu_att %in% c(6, 7) ~ "UpperSecondary",
  regressor$edu_att %in% c(8, 9) ~ "Technological",
  regressor$edu_att %in% c(10, 11, 12, 13) ~ "University",
  regressor$edu_att == 97 ~ "NA",
)
regressor$edu_att <- as.factor(regressor$edu_att)
regressor$edu_att <- relevel(regressor$edu_att, ref = "UpperSecondary") # Relevel to set the reference category

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
regressor$major_trans_2020<-as.factor(regressor$major_trans_2020)
regressor$major_trans_2020<-relevel(regressor$major_trans_2020,ref = "other")

regressor <- regressor %>%
  mutate(
    # 1) if P13 not NA, take P13, otherwise keep original P14
    occupation = if_else(!is.na(P13), as.character(P13), as.character(occupation)),
    # 2) if P15 not NA, paste it to the (possibly updated) P14; else leave as is
    occupation = if_else(
      !is.na(P15),
      paste(occupation, P15, sep = " / "),  # use whatever separator you like
      occupation
    )
  )
regressor$occupation <- str_remove_all(regressor$occupation, "(^NA\\s*/\\s*)|(\\s*/\\s*NA$)")

regressor<-regressor%>%
  mutate(occupation= as.numeric(occupation)) %>%
  select(-P13, -P15)

regressor<-regressor%>%
  mutate(occupation= case_when(
    occupation %in% c(1,2,3,4,5,22) ~ "student",
    occupation %in% c(11,12) ~ "employed",
    occupation %in% c(13,14,15,16) ~ "self-employed",
    occupation %in% c(6,7,8,9,17) ~ "informal",
    occupation == 97 ~ "NA",
    TRUE ~ "Other-unemployed"
  ))
regressor$occupation <- as.factor(regressor$occupation)
regressor$occupation <- relevel(regressor$occupation, ref = "Other-unemployed") # Relevel to set the reference category

regressor<-regressor%>%
  mutate(income= case_when(
    income %in% c(1,2,3) ~ "Low",
    income %in% c(4,5,6) ~ "lower-mid",
    income %in% c(7,8) ~ "Upper-mid",
    income %in% c(9,10,11) ~ "High",
    TRUE ~ "Other"
    ))%>%
  mutate(income = as.factor(income))
regressor$income <- relevel(regressor$income, ref = "Other") # Relevel to set the reference category

regressor<-regressor%>%
  mutate(live_time= case_when(
    live_time %in% c(1,2) ~ "short",
    live_time %in% c(3,4) ~ "medium",
    live_time %in% c(5,6) ~ "long",
    TRUE ~ "NA"
  )) %>%
  mutate(live_time = as.factor(live_time))

regressor$live_time <- relevel(regressor$live_time, ref = "medium") # Relevel to set the reference category

regressor <- regressor %>%
  mutate(
    age = if_else(
      age %in% c(1,2),
      "under_18",
      as.character(age)      # keeps the original age for everyone else
    )
  )%>%
  mutate(age = as.factor(age))



model_house<-multinom(P87~.,data=regressor)
summary(model_house)

z<-summary(model_house)$coefficients/summary(model_house)$standard.errors
p_values<- (1 - pnorm(abs(z), 0, 1)) * 2




library(dplyr)
library(tidyr)
library(tibble)
library(knitr)
library(kableExtra)

# 1. grab the raw summary
s <- summary(model_house)

# 2. extract coefficient & SE matrices
coef_mat <- s$coefficients       # rows = outcome levels, cols = predictors
se_mat   <- s$standard.errors

# 3. compute z‐scores and p‐values
z_mat <- coef_mat / se_mat
p_mat <- 2 * pnorm(-abs(z_mat))

# 4. reshape into a long tibble
df_coef <- as.data.frame(coef_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="Coef")

df_se <- as.data.frame(se_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="SE")

df_zp <- as.data.frame(z_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="z")

df_p <- as.data.frame(p_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="p.value")

# join all pieces
results <- df_coef %>%
  left_join(df_se,  by=c("Outcome","Predictor")) %>%
  left_join(df_zp,  by=c("Outcome","Predictor")) %>%
  left_join(df_p,   by=c("Outcome","Predictor")) %>%
  mutate(
    OR      = exp(Coef),            # exponentiated coefficient
    across(c(Coef, SE, z, OR, p.value),
           ~ round(., 3))           # round everything to 3 decimals
  ) %>%
  select(Outcome, Predictor, OR, Coef, SE, z, p.value)

# 5. render as HTML
html_table <- kable(
  results,
  format     = "html",
  table.attr = 'class="table table-striped"',
  col.names  = c("Outcome", "Predictor", "OR", "Coef", "SE", "z-score", "p-value"),
  caption    = "Multinomial logit: Odds Ratios, Coefs, SEs, z-scores & p-values"
) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width        = FALSE
  )

# print to console / RMarkdown Viewer
html_table

# (optional) save as standalone HTML
save_kable(html_table, "multinom_results.html")
