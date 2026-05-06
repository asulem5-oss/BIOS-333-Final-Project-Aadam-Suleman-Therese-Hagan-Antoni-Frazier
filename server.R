library(shiny)
library(tidyverse)
library(janitor)

cha <- read_csv(
  "~/Downloads/Chi_Health_Atlas_Data(1).csv",
  show_col_types = FALSE
) %>%
  clean_names()

pick_col <- function(data, options) {
  found <- options[options %in% names(data)]
  if (length(found) == 0) {
    stop(paste("None of these columns were found:", paste(options, collapse = ", ")))
  }
  found[1]
}

trust_col <- pick_col(cha, c("chabhxk_2023_2024", "chabxhk_2023_2024"))
env_col <- pick_col(cha, c("chaknkc_2023", "chanknc_2023", "chaknc_2023"))

cha_clean <- cha %>%
  filter(layer == "Community area") %>%
  transmute(
    community = name,
    population = population,
    trust_gov = .data[[trust_col]],
    env_burden = .data[[env_col]],
    air_quality = chasbqj_2023_2024,
    asthma = hcsath_2023_2024,
    obesity = hcsob_2023_2024,
    hypertension = hcshyt_2023_2024,
    diabetes = hcsdia_2023_2024
  ) %>%
  drop_na()

server <- function(input, output) {
  
  output$healthPlot <- renderPlot({
    ggplot(
      cha_clean,
      aes(
        x = env_burden,
        y = .data[[input$health_var]]
      )
    ) +
      geom_point(size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", se = TRUE) +
      theme_minimal() +
      labs(
        title = "Environmental Burden vs Health Outcome",
        subtitle = "Chicago community areas",
        x = "Environmental Burden",
        y = input$health_var
      )
  })
  
  output$trustPlot <- renderPlot({
    ggplot(
      cha_clean,
      aes(x = env_burden, y = trust_gov)
    ) +
      geom_point(size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", se = TRUE) +
      theme_minimal() +
      labs(
        title = "Environmental Burden vs Trust in Government",
        subtitle = "Chicago community areas",
        x = "Environmental Burden",
        y = "Trust in Government"
      )
  })
}