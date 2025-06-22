# Bogota Travel Survey Analysis: Multinomial Regression
Zhanchao Yang

## Introduction & Research Questions

Bogotá, long served by an extensive bus network yet plagued by chronic congestion and air pollution, is on the cusp of a major transit transformation. The city’s first metro lines—Line 1, which will link the northwest suburbs with the city center, and Line 2, running through the northern corridor—promise not only faster, more reliable journeys but also substantial environmental and socio-economic benefits. However, the success of this infrastructure depends as much on engineering and finance as on public buy-in: how citizens perceive its effectiveness, its impact on air quality and noise, and its broader effects on livelihoods and equity.

This study examines these perceptions across various segments of Bogotá’s population. In particular, it asks:

1. How do demographic and socio-economic characteristics (e.g., age, income, education, and residential location) shape perceived operational effectiveness of the new metro lines?
2. Which population groups anticipate the most significant environmental benefits—or drawbacks—from the metro, and what factors underlie these expectations?
3. How do perceptions of the metro’s socio-economic impacts (such as changes in employment opportunities, property values, and social inclusion) vary among distinct community profiles?

By illuminating the perceptions held by various communities, we aim to inform both policy adjustments and communication strategies that will maximize public support and ensure that Bogotá’s metro delivers on its promise of cleaner, more equitable urban mobility. 

## Method

### Multinomial Regression
Multinomial regression is an extension of binary logistic regression for modeling a categorical outcome with more than two nominal (i.e., unordered) categories. Rather than predicting a single probability (as in binary logistic), it predicts a set of probabilities—one for each possible category of the dependent variable—such that they sum to 1.

