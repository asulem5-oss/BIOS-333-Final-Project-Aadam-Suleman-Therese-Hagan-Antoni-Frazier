library(shiny)
library(tidyverse)
library(ggplot2)
library(readr)
library(stringr)

server <- function(input, output, session) {
  
  # Load Health Atlas
  cha <- read_csv("Chi_Health_Atlas_Data(1).csv", show_col_types = FALSE) %>%
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
  
  # Load Open Air
  open_air <- read_csv("open air.csv", show_col_types = FALSE) %>%
    mutate(
      community = str_remove(sensor_name, "\\s+[0-9]+$"),
      pm25 = pm2_5ConcMass24HourMean.value,
      no2 = no2Conc24HourMean.value,
      temperature = temperatureAmbient24HourMean.value
    ) %>%
    filter(!is.na(community))
  
  # Summarize Open Air by community area
  open_air_summary <- open_air %>%
    group_by(community) %>%
    summarize(
      mean_pm25 = mean(pm25, na.rm = TRUE),
      mean_no2 = mean(no2, na.rm = TRUE),
      mean_temperature = mean(temperature, na.rm = TRUE),
      n_readings = n(),
      .groups = "drop"
    )
  
  # Combine datasets
  combined_data <- cha %>%
    inner_join(open_air_summary, by = "community")
  
  # Plot 1: PM2.5 vs selected health outcome
  output$healthPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_pm25, y = .data[[input$health_var]])) +
      geom_point(aes(size = population), alpha = 0.7, color = "steelblue") +
      geom_smooth(method = "lm", se = TRUE, color = "red") +
      theme_minimal() +
      labs(
        title = "PM2.5 Exposure vs Selected Health Outcome",
        subtitle = "Open Air Chicago joined with Chicago Health Atlas by community area",
        x = "Average PM2.5 Concentration",
        y = input$health_var,
        size = "Population"
      )
  })
  
  # Plot 2: PM2.5 vs trust in government
  output$trustPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_pm25, y = trust_gov)) +
      geom_point(color = "darkgreen", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal() +
      labs(
        title = "PM2.5 Exposure vs Trust in Government",
        subtitle = "Higher pollution exposure compared with civic trust",
        x = "Average PM2.5 Concentration",
        y = "Trust in Government"
      )
  })
  
  # Plot 3: NO2 vs asthma
  output$airPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_no2, y = asthma)) +
      geom_point(color = "purple", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "orange") +
      theme_minimal() +
      labs(
        title = "NO2 Exposure vs Asthma",
        subtitle = "Traffic-related pollution compared with asthma prevalence",
        x = "Average NO2 Concentration",
        y = "Asthma Prevalence"
      )
  })
  
  # Table
  output$dataTable <- renderTable({
    combined_data %>%
      select(
        community,
        mean_pm25,
        mean_no2,
        mean_temperature,
        asthma,
        obesity,
        hypertension,
        diabetes,
        trust_gov,
        traffic_risk
      ) %>%
      head(10)
  })
}