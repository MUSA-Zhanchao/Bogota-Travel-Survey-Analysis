library(dplyr)
library(tidyr)
library(tibble)
library(knitr)
library(kableExtra)

# 1. grab raw summary
s       <- summary(model_house)
coef_mat<- s$coefficients
se_mat  <- s$standard.errors

# 2. compute z-scores & p-values
z_mat <- coef_mat / se_mat
p_mat <- 2 * pnorm(-abs(z_mat))

# 3. pivot to long form
df_coef <- as.data.frame(coef_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="Coef")
df_se   <- as.data.frame(se_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="SE")
df_z    <- as.data.frame(z_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="z")
df_p    <- as.data.frame(p_mat) %>%
  rownames_to_column("Outcome") %>%
  pivot_longer(-Outcome, names_to="Predictor", values_to="p.value")

# 4. join and format, adding stars
results <- df_coef %>%
  left_join(df_se, by=c("Outcome","Predictor")) %>%
  left_join(df_z,  by=c("Outcome","Predictor")) %>%
  left_join(df_p,  by=c("Outcome","Predictor")) %>%
  mutate(
    OR      = exp(Coef),
    across(c(Coef, SE, z, OR, p.value), ~ round(., 3)),
    stars   = case_when(
      p.value < 0.001 ~ "***",
      p.value < 0.01  ~ "**",
      p.value < 0.05  ~ "*",
      TRUE            ~ ""
    ),
    OR       = paste0(OR, stars)
  ) %>%
  select(Outcome, Predictor, OR, Coef, SE, z, p.value)

# 5. render as styled HTML
html<-kable(
  results,
  format     = "html",
  table.attr = 'class="table table-striped"',
  col.names  = c("Outcome", "Predictor", "OR", "Coef", "SE", "z-score", "p-value"),
  caption    = "Multinomial logit: Odds Ratios (with significance), Coefs, SEs, z-scores & p-values"
) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width        = FALSE
  )
# 6. save to file
save_kable(html, file = "model_house_results_with_star.html")
