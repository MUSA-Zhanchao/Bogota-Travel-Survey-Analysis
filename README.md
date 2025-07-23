# Bogotá Travel Survey Analysis: Multinomial Regression
[![Software License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Zhanchao Yang

Summer 2025

## Introduction & Research Questions

Bogotá, long served by an extensive bus network yet plagued by chronic congestion and air pollution, is on the cusp of a major transit transformation. The city’s first metro lines—Line 1, which will link the northwest suburbs with the city center, and Line 2, running through the northern corridor—promise not only faster, more reliable journeys but also substantial environmental and socio-economic benefits. However, the success of this infrastructure depends as much on engineering and finance as on public buy-in: how citizens perceive its effectiveness, its impact on air quality and noise, and its broader effects on livelihoods and equity.

This study examines these perceptions across various segments of Bogotá’s population. In particular, it asks:

1. How do demographic and socio-economic characteristics (e.g., age, income, education, and residential location) shape perceived operational effectiveness of the new metro lines?
2. Which population groups anticipate the most significant environmental benefits—or drawbacks—from the metro, and what factors underlie these expectations?
3. How do perceptions of the metro’s socio-economic impacts (such as changes in employment opportunities, property values, and social inclusion) vary among distinct community profiles?

By illuminating the perceptions held by various communities, we aim to inform both policy adjustments and communication strategies that will maximize public support and ensure that Bogotá’s metro delivers on its promise of cleaner, more equitable urban mobility.

## Method

### What is Multinomial Regression?

Multinomial regression is a statistical technique used to model the relationship between a categorical dependent variable with more than two levels and one or more independent variables. It is an extension of binary logistic regression, designed for categorical outcomes with more than two unordered categories. Rather than predicting a single probability as in logistic regression, multinomial regression predicts a set of probabilities—one for each possible category of the dependent variable. The coefficients (**β**) represent the change in log-odds of choosing a specific category over the baseline for a one-unit increase in a predictor variable, while holding all other variables constant. This method is particularly useful for analyzing survey data, such as the Bogotá Travel Survey.
Since P87-P101 consists of three categorical responses, “increase”, “not expected to see change”, and “expected to decrease”. The multinomial regression is suitable for determining the relationship between individuals' expectations and specific socio-economic predictors. The category of “not expected to see change” is used as the dependent variable baseline category.

## Formula

$$
\log\!\biggl(\frac{P(Y = j_1)}{P(Y = \mathrm{base})}\biggr)
= \beta_{j0} + \beta_{j1}X_1 + \beta_{j2}X_2 + \cdots + \beta_{jp}X_p
$$

where:

- $j_1$ is the category of the dependent variable (e.g., “increase”, “decrease”)
- $Y$ is the categorical outcome variable
- $X_1, X_2, \ldots, X_p$ are the independent variables (predictors)
- $\beta_{j0}$ is the intercept for category $j$
- $\beta_{j1}, \beta_{j2}, \ldots, \beta_{jp}$ are the coefficients for the predictors in category $j$

In addition to that, for the second category:

$$
\log\!\biggl(\frac{P(Y = j_2)}{P(Y = \mathrm{base})}\biggr)
= \beta_{j0} + \beta_{j1}X_1 + \beta_{j2}X_2 + \cdots + \beta_{jp}X_p
$$

where:

- $j_2$ is the second category (e.g., “decrease”) and “base” is the reference (e.g., “not change”)


---

In short notation for all $j=1,\dots,J$:

$$
\log\frac{P(Y = j \mid X)}{P(Y = 0 \mid X)}
= \beta_{0j} + \beta_j^{T}X
$$

and in probability form:

$$
P(Y = j \mid X)
= \frac{\exp\bigl(\beta_{0j} + \beta_j^{T}X\bigr)}
       {1 + \displaystyle\sum_{k=1}^J \exp\bigl(\beta_{0k} + \beta_k^{T}X\bigr)},
\quad j = 1, \dots, J
$$

with the baseline probability

$$
P(Y = 0 \mid X)
= \frac{1}
       {1 + \displaystyle\sum_{k=1}^J \exp\bigl(\beta_{0k} + \beta_k^{T}X\bigr)}.
$$


## Key Assumptions
There are three key assumptions for multinomial regression:

- **Independence of Irrelevant Alternatives (IIA)**: the odds between any two outcome categories do not depend on other alternatives. For example, the odds of people choosing to see increase or are influenced by options like “not change” and “decrease” present.
- **Independent observations**: We assume each individual person in our cases responded to the survey directly without being influenced by others who took the survey.
- **No perfect multicollinearity** among predictors

## Sample Interpretation

- The log-odds of responding “increase” (or “decrease”) vs “not change” are beta coefficient higher for categories one compared to reference categories.
- **Exponentiating (odd ratio)**: category one has `exp (β) - 1` percentage higher odds of choosing “increase” over not change compared to reference categories.

## Potential Predictors

All the predictors were treated as factors and regrouped to eliminate small sample categories. The specific variable, regrouping process, and reference category are listed below.

- Housing type (`P1`): 1- House, 2- Apartment, 3- Room in tenement, 4- other type of housing; *Other type of housing (4) was used as reference category.*
- Rent and Own (`P82`): 1 - Own, 2 - Rent; *Own was used as the reference category.*
- Gender (`P10`): 1 – female, 2 – male; *Female was used as the reference category.*
- Educational attainment (`P12`) with **recategorization**: Primary – primary school or lower, LowerSecondary -Junior high school complete, UpperSecondary – Senior high school complete (10th and 11th grades), Technological – technician/technological complete, University- University degree or higher; *Reference category: Upper secondary (high school complete)*
- Major Transportation mode before COVID-19 (`P42`) with **recategorization**: Public transit - including all buses (public), informal (private bus), taxi, driving, motorcycle, bike, walking, and others; *Reference category: other*
- Occupation (`P13`) with **recategorization**: student – include preschool, employed, self-employed, informal, NA, Others; *Reference category: other-employed*
- Income (`P50`) with **recategorization**: low- under 1,160, lower-mid – 1,161-2,500, upper-mid – 2,501 – 4,900, high – over 4,901; other (not answer); *Reference category: other*
- Live time (`P83`) with **recategorization**: short – less than or equal to 5 years, medium - More than 5 or less than or equal to 15 years, long – More than 15 years. *Reference category: medium *
- Age (`Edad`) with **recategorization**: under 18 years, 3,4,5,6,7 (without further recategorize) .*Reference category: 3*

## Inclusive and Exclusive Criteria

Since the primary purpose of the model is to identify different characteristics of people who have different expectations about the impact of the Bogotá Metro, we will use the following criteria to determine which predictors to include in the model (**exploratory analysis rather than make prediction**):

**Inclusive Criteria**:

- P-values indicate the specific category is statistics significant

**Exclusive Criteria**:

- P-values indicate the specific category is not statistics significant (greater than 0.05)
- The sample size of the specific category is less than 30, which is too small to draw any conclusion.
- A coefficient this large often indicates near–perfect separation: in your data, whenever `X = k`, you almost never (or never) observe the baseline outcome. **It almost always signals (quasi-)perfect separation or very sparse data, so you’ll want to inspect your frequency tables and perhaps apply a regularization or category‐collapsing strategy.**
- **Meaningless categories**: such as **NA**, etc.

# Results

Since all **housing type** (P1) are statistically significant, we will not include it in the model, since all housing type shows signals of (quasi-)perfect separation, indicate that the housing type is not a good predictor for the dependent variable.( maybe because there is no significant difference between people in different household answer the survey differently or sample size is too small.)

For detailed results and analysis, refer to the sections above and the accompanying Markdown files in the repository.

# Limitation

The multinomial regression has three major limitations.
**1. Overgeneralization of respondents’ views.** The analysis treats the head‑of‑household’s opinions as if they represent every household member (and the full survey sample), undermining the validity of any inferences.
**2. Insufficient observations per category.** Maximum‑likelihood estimation in multinomial models generally requires at least 50 cases in each outcome category and for each additional predictors; our sample falls well short of that benchmark.
**3. Skewed outcome distribution.** Many of the perceiption questions has skewed outcome distributions, which most of the survey respondents answers to the same answer, leading to less covariant between dependent variable. For example, in the property‑value question, 70% of respondents reported “increased,” while only 10% reported “decreased.” Such imbalance can produce unstable coefficient estimates and make it difficult to achieve statistical significance.
Overall, these issues mean the results are best viewed as preliminary, exploratory findings—not as definitive, scientifically robust conclusions.
