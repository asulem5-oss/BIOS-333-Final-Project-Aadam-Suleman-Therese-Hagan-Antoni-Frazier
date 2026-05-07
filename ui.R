library(shiny)

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3("Interactive Controls"),
      
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
      ),
      
      hr(),
      
      selectInput(
        "x_var",
        "Choose Environmental Variable:",
        choices = c(
          "PM2.5" = "mean_pm25",
          "NO2" = "mean_no2",
          "Temperature" = "mean_temperature",
          "Traffic Risk" = "traffic_risk",
          "Air Quality Perception" = "air_quality"
        )
      ),
      
      selectInput(
        "y_var",
        "Choose Health / Community Variable:",
        choices = c(
          "Asthma" = "asthma",
          "Obesity" = "obesity",
          "Hypertension" = "hypertension",
          "Diabetes" = "diabetes",
          "Trust in Government" = "trust_gov"
        )
      )
    ),
    
    mainPanel(
      
      h3("PM2.5 Exposure vs Selected Health Outcome"),
      plotOutput("healthPlot"),
      
      hr(),
      
      h3("PM2.5 Exposure vs Trust in Government"),
      plotOutput("trustPlot"),
      
      hr(),
      
      h3("NO2 Exposure vs Asthma"),
      plotOutput("airPlot"),
      
      hr(),
      
      h3("Interactive Combined Dashboard"),
      plotOutput("interactivePlot"),
      
      hr(),
      
      h3("Correlation Summary"),
      verbatimTextOutput("statsText"),
      
      hr(),
      
      h3("Preview of Combined Data"),
      tableOutput("dataTable")
    )
  )
)