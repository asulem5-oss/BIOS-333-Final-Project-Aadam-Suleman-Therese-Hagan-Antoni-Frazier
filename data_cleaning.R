library(tidyverse)
library(janitor)

cha <- read_csv(
  "~/Downloads/Chi_Health_Atlas_Data(1).csv",
  show_col_types = FALSE
) %>%
  clean_names()

cha_clean <- cha %>%
  filter(layer == "Community area") %>%
  transmute(
    community = name,
    population = population,
    trust_gov = chabxhk_2023_2024,
    env_burden = .[[22]],
    asthma = hcsath_2023_2024,
    obesity = hcsob_2023_2024,
    hypertension = hcshyt_2023_2024,
    diabetes = hcsdia_2023_2024
  ) %>%
  drop_na()

glimpse(cha_clean)
head(cha_clean)
