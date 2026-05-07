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
  
  # Load Open Air data
  open_air <- read_csv("open air.csv", show_col_types = FALSE) %>%
    mutate(
      community = str_remove(sensor_name, "\\s+[0-9]+$"),
      pm25 = pm2_5ConcMass24HourMean.value,
      no2 = no2Conc24HourMean.value,
      temperature = temperatureAmbient24HourMean.value
    ) %>%
    filter(!is.na(community))
  
  # Summarize Open Air by community
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
  # Environmental justice is kept in the data table,
  # but removed from the main plots because the values are mostly/all zero.
  combined_data <- cha %>%
    inner_join(open_air_summary, by = "community")
  
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
    ggplot(combined_data, aes(x = .data[[input$x_var]], y = .data[[input$y_var]])) +
      geom_point(color = "purple", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "orange") +
      theme_minimal() +
      labs(
        title = paste(input$x_var, "vs", input$y_var),
        x = input$x_var,
        y = input$y_var
      )
  })
  
  output$statsText <- renderPrint({
    cor.test(
      combined_data[[input$x_var]],
      combined_data[[input$y_var]],
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
        air_quality,
        env_justice,
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