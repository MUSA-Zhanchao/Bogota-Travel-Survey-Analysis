library(tidyverse)

trips <- readRDS("data/008-24 BBDD Procesamiento Etapas.rds")
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

per_complt <- per %>% 
  left_join(hog,by="ID_Hogar")

trips_complt<-trips %>% 
  left_join(hog,by="ID_Hogar")
per_complt_87<-per_complt%>%
  select(P87)

summary_p87<- per_complt_87 %>%
  group_by(P87) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_90<-per_complt%>%
  select(P90)
summary_p90<- per_complt_90 %>%
  group_by(P90) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_91<-per_complt%>%
  select(P91)
summary_p91<- per_complt_91 %>%
  group_by(P91) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_92<-per_complt%>%
  select(P92)
summary_p92<- per_complt_92 %>%
  group_by(P92) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_95<-per_complt%>%
  select(P95)
summary_p95<- per_complt_95 %>%
  group_by(P95) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_96<-per_complt%>%
  select(P96)
summary_p96<- per_complt_96 %>%
  group_by(P96) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_98<-per_complt%>%
  select(P98)
summary_p98<- per_complt_98 %>%
  group_by(P98) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_100<-per_complt%>%
  select(P100)
summary_p100<- per_complt_100 %>%
  group_by(P100) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

per_complt_101<-per_complt%>%
  select(P101)
summary_p101<- per_complt_101 %>%
  group_by(P101) %>%
  summarise(n = n()) %>%
  mutate(pct = n / sum(n) * 100)

colors <- c("1" = "green", "2" = "white", "3" = "red")

ggplot(summary_p100, aes(x = P100, y = n, fill = P100)) +
  geom_bar(stat = "identity", color = "black") +
  scale_fill_manual(values = colors) +
  labs(
    title = "P100 - Espacio público",
    x = "Respuesta",
    y = "Porcentaje (%)"
  ) +
  theme_minimal()
