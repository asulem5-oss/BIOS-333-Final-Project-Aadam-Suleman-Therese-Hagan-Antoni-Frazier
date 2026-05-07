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
      
      p("This dashboard connects Open Air Chicago pollution data with Chicago Health Atlas community health outcomes.")
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
      
      h3("Combined Pollution Burden vs Chronic Disease Burden"),
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