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
      median_pm25 = median(pm25, na.rm = TRUE),
      mean_no2 = mean(no2, na.rm = TRUE),
      median_no2 = median(no2, na.rm = TRUE),
      mean_temperature = mean(temperature, na.rm = TRUE),
      n_readings = n(),
      .groups = "drop"
    )
  
  combined_data <- cha %>%
    inner_join(open_air_summary, by = "community") %>%
    filter(
      n_readings >= 10,
      mean_pm25 > 0,
      mean_no2 > 0,
      asthma > 0,
      obesity > 0,
      hypertension > 0,
      diabetes > 0
    ) %>%
    mutate(
      pollution_burden = as.numeric(scale(mean_pm25)) + as.numeric(scale(mean_no2)),
      chronic_disease_burden =
        as.numeric(scale(asthma)) +
        as.numeric(scale(obesity)) +
        as.numeric(scale(hypertension)) +
        as.numeric(scale(diabetes))
    )
  
  correlation_results <- reactive({
    
    pairs <- tribble(
      ~xvar, ~yvar, ~label,
      "mean_pm25", "asthma", "PM2.5 vs Asthma",
      "mean_no2", "asthma", "NO2 vs Asthma",
      "traffic_risk", "asthma", "Traffic Risk vs Asthma",
      "mean_pm25", "hypertension", "PM2.5 vs Hypertension",
      "mean_no2", "hypertension", "NO2 vs Hypertension",
      "traffic_risk", "hypertension", "Traffic Risk vs Hypertension",
      "mean_pm25", "obesity", "PM2.5 vs Obesity",
      "mean_no2", "obesity", "NO2 vs Obesity",
      "mean_temperature", "mean_pm25", "Temperature vs PM2.5",
      "mean_temperature", "mean_no2", "Temperature vs NO2",
      "pollution_burden", "chronic_disease_burden", "Pollution Burden vs Chronic Disease Burden"
    )
    
    pairs %>%
      rowwise() %>%
      mutate(
        test = list(
          cor.test(
            combined_data[[xvar]],
            combined_data[[yvar]],
            method = input$cor_method,
            use = "complete.obs"
          )
        ),
        r_value = unname(test$estimate),
        p_value = test$p.value,
        abs_r = abs(r_value)
      ) %>%
      ungroup() %>%
      arrange(p_value, desc(abs_r)) %>%
      select(label, xvar, yvar, r_value, p_value, abs_r)
  })
  
  best_pair <- reactive({
    correlation_results() %>% slice(1)
  })
  
  output$bestPlot <- renderPlot({
    
    best <- best_pair()
    
    ggplot(
      combined_data,
      aes(
        x = .data[[best$xvar]],
        y = .data[[best$yvar]]
      )
    ) +
      geom_point(aes(size = population), color = "steelblue", alpha = 0.75) +
      geom_smooth(method = "lm", se = TRUE, color = "red", linewidth = 1.2) +
      theme_minimal(base_size = 14) +
      labs(
        title = paste("Strongest Observed Relationship:", best$label),
        subtitle = paste0(
          "r = ", round(best$r_value, 3),
          " | p = ", signif(best$p_value, 4),
          " | method = ", input$cor_method
        ),
        x = best$xvar,
        y = best$yvar,
        size = "Population"
      )
  })
  
  output$bestStats <- renderPrint({
    
    best <- best_pair()
    
    cat("Strongest tested relationship:\n")
    cat(best$label, "\n\n")
    cat("Correlation method:", input$cor_method, "\n")
    cat("r value:", round(best$r_value, 4), "\n")
    cat("p value:", signif(best$p_value, 5), "\n\n")
    
    if (best$p_value < 0.05) {
      cat("Interpretation: This relationship is statistically significant at p < 0.05.\n")
    } else {
      cat("Interpretation: This relationship is not statistically significant at p < 0.05.\n")
      cat("Use this as an exploratory trend, not proof of a significant relationship.\n")
    }
  })
  
  output$corTable <- renderTable({
    correlation_results() %>%
      mutate(
        r_value = round(r_value, 3),
        p_value = signif(p_value, 4)
      ) %>%
      select(
        Relationship = label,
        `r value` = r_value,
        `p value` = p_value
      )
  })
  
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
  
  output$trafficHyperPlot <- renderPlot({
    ggplot(combined_data, aes(x = traffic_risk, y = hypertension)) +
      geom_point(color = "firebrick", size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal() +
      labs(
        title = "Traffic Risk vs Hypertension",
        x = "Traffic Risk",
        y = "Hypertension"
      )
  })
  
  output$tempPlot <- renderPlot({
    ggplot(combined_data, aes(x = mean_temperature, y = mean_pm25)) +
      geom_point(color = "darkorange", size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal() +
      labs(
        title = "Temperature vs PM2.5",
        x = "Average Temperature",
        y = "Average PM2.5"
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
        traffic_risk,
        pollution_burden,
        chronic_disease_burden
      ) %>%
      head(10)
  })
}