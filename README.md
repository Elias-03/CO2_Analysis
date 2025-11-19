---
title: "Carbon Emissions Analysis"
author: "Elias"
date: "2025-11-09"
output: html_document
---

# Introduction

This project examines global CO₂ emissions to understand how factors such as population and temperature changes contribute to emission patterns. The dataset contains annual observations of multiple countries and includes CO₂ emissions, temperature trends, and population figures.

The following data analysis methods were applied:

- **Descriptive Statistics and Exploration**
- **Regression Analysis**
- **K-Nearest Neighbors (KNN)**
- **ANOVA**
- **Clustering**
- **Association Rule Mining**

# Loading Required Libraries

```{r}
library(tidyverse)
library(dplyr)
library(ggplot2)
library(caret)
library(cluster)
library(factoextra)
library(arules)
```

# Loading the Dataset

```{r}
data <- read.csv("carbon_emissions.csv")
head(data)
summary(data)
str(data)
colSums(is.na(data))
```

# Handling Missing Values

```{r}
data$temperature_change_from_co2[is.na(data$temperature_change_from_co2)] <- 
  median(data$temperature_change_from_co2, na.rm = TRUE)
colSums(is.na(data))
```

# Exploratory Data Analysis

```{r}
ggplot(data, aes(x = population, y = co2)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  ggtitle("CO2 vs Population")
```

```{r}
ggplot(data, aes(x = temperature_change_from_co2, y = co2)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  ggtitle("CO2 vs Temperature Change")
```

# Regression Analysis

```{r}
model <- lm(co2 ~ population + temperature_change_from_co2, data = data)
summary(model)
```

# K-Nearest Neighbors (KNN)

```{r}
data$CO2_Level <- ifelse(data$co2 > median(data$co2), "High", "Low")

set.seed(123)
trainIndex <- createDataPartition(data$CO2_Level, p = 0.8, list = FALSE)
train <- data[trainIndex, ]
test <- data[-trainIndex, ]

model_knn <- train(
  CO2_Level ~ population + temperature_change_from_co2,
  data = train,
  method = "knn",
  tuneLength = 5
)
model_knn
```

# ANOVA

```{r}
anova_result <- aov(co2 ~ factor(year), data = data)
summary(anova_result)
```

# Clustering

```{r}
scaled <- scale(data[, c("co2", "population", "temperature_change_from_co2")])

set.seed(123)
clusters <- kmeans(scaled, centers = 3)

fviz_cluster(clusters, data = scaled)
```

# Association Rules

```{r}
rules_data <- data %>%
  mutate(
    Pop_Level = ifelse(population > median(population), "High_Pop", "Low_Pop"),
    Em_Level = ifelse(co2 > median(co2), "High_Em", "Low_Em")
  ) %>%
  select(Pop_Level, Em_Level)

transactions <- as(rules_data, "transactions")

rules <- apriori(transactions, parameter = list(supp = 0.2, conf = 0.7))

inspect(rules)
```

# Conclusion

This analysis demonstrates:

- Population and temperature changes influence CO₂ emissions.
- Regression quantifies the strength of these relationships.
- KNN effectively classifies countries based on emission levels.
- ANOVA shows emission differences across years.
- Clustering reveals natural data groupings.
- Association rules identify frequent emission patterns.

Multiple analysis methods confirm consistent insights into global emission behaviors.
