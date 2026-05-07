library(shiny)
library(tidyverse)
library(ggplot2)
library(readr)
library(stringr)

server <- function(input, output, session) {
  
  cha <- read_csv("Chi_Health_Atlas_Data(1).csv", show_col_types = FALSE) %>%
    filter(Layer == "Community area") %>%
    rename(
      community = Name,
      trust_gov = `CHABXHK_2023-2024`,
      air_quality = `CHASBQJ_2023-2024`,
      obesity = `HCSOB_2023-2024`,
      hypertension = `HCSHYT_2023-2024`,
      diabetes = `HCSDIA_2023-2024`,
      asthma = `HCSATH_2023-2024`,
      traffic_risk = TRF_2020,
      park_metric = PMC_2020,
      population = Population
    )
  
  open_air <- read_csv("open air.csv", show_col_types = FALSE) %>%
    mutate(
      community = str_remove(sensor_name, "\\s+[0-9]+$"),
      pm25 = pm2_5ConcMass24HourMean.value,
      no2 = no2Conc24HourMean.value,
      temperature = temperatureAmbient24HourMean.value
    ) %>%
    filter(!is.na(community))
  
  open_air_summary <- open_air %>%
    group_by(community) %>%
    summarize(
      mean_pm25 = mean(pm25, na.rm = TRUE),
      mean_no2 = mean(no2, na.rm = TRUE),
      mean_temperature = mean(temperature, na.rm = TRUE),
      n_readings = n(),
      .groups = "drop"
    )
  
  combined_data <- cha %>%
    inner_join(open_air_summary, by = "community") %>%
    filter(
      !is.na(mean_pm25),
      !is.na(mean_no2),
      !is.na(asthma),
      !is.na(obesity),
      !is.na(hypertension),
      asthma > 0,
      obesity > 0,
      hypertension > 0,
      mean_pm25 > 0,
      mean_no2 > 0
    ) %>%
    mutate(
      pm25_scaled = scale(mean_pm25)[,1],
      no2_scaled = scale(mean_no2)[,1],
      asthma_scaled = scale(asthma)[,1],
      obesity_scaled = scale(obesity)[,1],
      hypertension_scaled = scale(hypertension)[,1],
      pollution_burden = (pm25_scaled + no2_scaled) / 2,
      chronic_disease_burden = (asthma_scaled + obesity_scaled + hypertension_scaled) / 3
    )
  
  output$healthPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_pm25, y = .data[[input$health_var]])) +
      geom_point(aes(size = population), alpha = 0.7, color = "steelblue") +
      geom_smooth(method = "lm", se = TRUE, color = "red") +
      theme_minimal() +
      labs(
        title = "PM2.5 Exposure vs Selected Health Outcome",
        x = "Average PM2.5",
        y = input$health_var,
        size = "Population"
      )
  })
  
  output$trustPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_pm25, y = trust_gov)) +
      geom_point(color = "darkgreen", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal() +
      labs(
        title = "PM2.5 Exposure vs Trust in Government",
        x = "Average PM2.5",
        y = "Trust in Government"
      )
  })
  
  output$airPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_no2, y = asthma)) +
      geom_point(color = "purple", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "orange") +
      theme_minimal() +
      labs(
        title = "NO2 Exposure vs Asthma",
        x = "Average NO2",
        y = "Asthma Prevalence"
      )
  })
  
  output$interactivePlot <- renderPlot({
    ggplot(combined_data, aes(x = pollution_burden, y = chronic_disease_burden)) +
      geom_point(aes(size = population), color = "red", alpha = 0.7) +
      geom_smooth(method = "lm", se = TRUE, color = "black", linewidth = 1.2) +
      theme_minimal(base_size = 15) +
      labs(
        title = "Combined Pollution Burden vs Chronic Disease Burden",
        subtitle = "PM2.5 + NO2 compared with asthma + obesity + hypertension",
        x = "Combined Pollution Burden",
        y = "Combined Chronic Disease Burden",
        size = "Population"
      )
  })
  
  output$statsText <- renderPrint({
    cor.test(
      combined_data$pollution_burden,
      combined_data$chronic_disease_burden,
      use = "complete.obs"
    )
  })
  
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
        traffic_risk,
        pollution_burden,
        chronic_disease_burden
      ) %>%
      head(10)
  })
}