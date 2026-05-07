library(shiny)

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Controls"),
      p("This app tests multiple environmental-health relationships and shows the strongest observed correlation."),
      
      selectInput(
        "cor_method",
        "Choose Correlation Method:",
        choices = c(
          "Spearman" = "spearman",
          "Pearson" = "pearson"
        ),
        selected = "spearman"
      ),
      
      hr(),
      
      selectInput(
        "health_var",
        "Choose Health Outcome for PM2.5 Plot:",
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
      
      h3("Strongest Observed Environmental-Health Relationship"),
      plotOutput("bestPlot"),
      
      hr(),
      
      h3("Strongest Correlation Test Result"),
      verbatimTextOutput("bestStats"),
      
      hr(),
      
      h3("All Tested Correlations"),
      tableOutput("corTable"),
      
      hr(),
      
      h3("PM2.5 Exposure vs Selected Health Outcome"),
      plotOutput("healthPlot"),
      
      hr(),
      
      h3("NO2 Exposure vs Asthma"),
      plotOutput("airPlot"),
      
      hr(),
      
      h3("Traffic Risk vs Hypertension"),
      plotOutput("trafficHyperPlot"),
      
      hr(),
      
      h3("Temperature vs PM2.5"),
      plotOutput("tempPlot"),
      
      hr(),
      
      h3("Preview of Combined Data"),
      tableOutput("dataTable")
    )
  )
)