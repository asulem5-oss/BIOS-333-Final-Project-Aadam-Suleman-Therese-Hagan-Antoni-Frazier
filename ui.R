#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

shinyApp(ui = ui, server = server)

ibrary(shiny)
library(tidyverse)
library(readexcel)


server <- function(input, output) {
  
  cha_file <- list.files(
    pattern = "Chi_Health_Atlas_Data.*\\.csv$",
    full.names = TRUE
  )[1]
  
  cha <- read_csv(cha_file, show_col_types = FALSE) %>%
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
  
  output$scatterPlot <- renderPlot({
    
    ggplot(cha, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point(aes(size = population), alpha = 0.6) +
      geom_smooth(method = "lm", se = TRUE) +
      theme_minimal() +
      labs(
        title = "Chicago Environmental Exposure and Health/Trust Outcomes",
        subtitle = "Connected to Mini Project 1: air quality and environmental burden",
        x = input$xvar,
        y = input$yvar,
        size = "Population"
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
        obesity
      ) %>%
      head(10)
  })
}

