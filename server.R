library(shiny)
library(tidyverse)
library(ggplot2)
library(readr)

server <- function(input, output, session) {
  
  cha_file <- list.files(
    pattern = "Chi_Health_Atlas_Data.*\\.csv$",
    full.names = TRUE
  )
  
  if (length(cha_file) == 0) {
    stop("Could not find the Chicago Health Atlas CSV file. Make sure it is inside the same project folder as ui.R and server.R.")
  }
  
  cha <- read_csv(cha_file[1], show_col_types = FALSE) %>%
    filter(Layer == "Community area") %>%
    rename(
      community = Name,
      trust_gov = `CHABXHK_2023-2024`,
      env_justice = CHAKNKC_2023,
      air_quality = `CHASBQJ_2023-2024`,
      obesity = `HCSOB_2023-2024`,
      hypertension = `HCSHYT_2023-2024`,
      diabetes = `HCSDIA_2023-2024`,
      asthma = `HCSATH_2023-2024`,
      traffic_risk = TRF_2020,
      park_metric = PMC_2020,
      population = Population
    )
  
  output$healthPlot <- renderPlot({
    ggplot(cha, aes(x = env_justice, y = .data[[input$health_var]])) +
      geom_point(aes(size = population), alpha = 0.7, color = "steelblue") +
      geom_smooth(method = "lm", se = TRUE, color = "red") +
      theme_minimal() +
      labs(
        title = "Environmental Burden vs Health Outcome",
        x = "Environmental Justice Count",
        y = input$health_var,
        size = "Population"
      )
  })
  
  output$trustPlot <- renderPlot({
    ggplot(cha, aes(x = env_justice, y = trust_gov)) +
      geom_point(color = "darkgreen", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal() +
      labs(
        title = "Environmental Burden vs Trust in Government",
        x = "Environmental Justice Count",
        y = "Trust in Government"
      )
  })
  
  output$airPlot <- renderPlot({
    ggplot(cha, aes(x = air_quality, y = asthma)) +
      geom_point(color = "purple", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "orange") +
      theme_minimal() +
      labs(
        title = "Air Quality vs Asthma",
        x = "Air Quality Perception",
        y = "Asthma Prevalence"
      )
  })
  
  output$dataTable <- renderTable({
    cha %>%
      select(
        community,
        air_quality,
        env_justice,
        traffic_risk,
        trust_gov,
        asthma,
        obesity,
        hypertension,
        diabetes
      ) %>%
      head(10)
  })
}