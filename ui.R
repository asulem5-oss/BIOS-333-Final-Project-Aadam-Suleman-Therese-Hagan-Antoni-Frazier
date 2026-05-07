library(shiny)
library(tidyverse)
library(ggplot2)
library(readr)

cha_file <- list.files(
  pattern = "Chi_Health_Atlas_Data.*\\.csv$",
  full.names = TRUE
)

if (length(cha_file) == 0) {
  stop("CSV file not found. Put Chi_Health_Atlas_Data(1).csv in this project folder.")
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

ui <- fluidPage(
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Project Focus"),
      p("This app explores how environmental conditions connect to health outcomes across Chicago community areas."),
      
      selectInput(
        "health_var",
        "Choose Health Outcome:",
        choices = c(
          "Asthma" = "asthma",
          "Obesity" = "obesity",
          "Hypertension" = "hypertension",
          "Diabetes" = "diabetes"
        ),
        selected = "asthma"
      )
    ),
    
    mainPanel(
      h3("Environmental Burden vs Selected Health Outcome"),
      plotOutput("healthPlot"),
      hr(),
      h3("Environmental Burden vs Trust in Government"),
      plotOutput("trustPlot"),
      hr(),
      h3("Air Quality vs Asthma"),
      plotOutput("airPlot"),
      hr(),
      h3("Preview of Cleaned Data"),
      tableOutput("dataTable")
    )
  )
)

server <- function(input, output, session) {
  
  output$healthPlot <- renderPlot({
    ggplot(cha, aes(x = env_justice, y = .data[[input$health_var]])) +
      geom_point(aes(size = population), alpha = 0.7, color = "steelblue") +
      geom_smooth(method = "lm", se = TRUE, color = "red") +
      theme_minimal()
  })
  
  output$trustPlot <- renderPlot({
    ggplot(cha, aes(x = env_justice, y = trust_gov)) +
      geom_point(color = "darkgreen", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "black") +
      theme_minimal()
  })
  
  output$airPlot <- renderPlot({
    ggplot(cha, aes(x = air_quality, y = asthma)) +
      geom_point(color = "purple", alpha = 0.7, size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "orange") +
      theme_minimal()
  })
  
  output$dataTable <- renderTable({
    cha %>%
      select(community, air_quality, env_justice, traffic_risk, trust_gov, asthma, obesity) %>%
      head(10)
  })
}

shinyApp(ui = ui, server = server)