library(shiny)

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Project Focus"),
      p("This app explores how environmental conditions connect to health outcomes across Chicago community areas."),
      p("Open Air Chicago data represents environmental exposure, while Chicago Health Atlas data represents health and community outcomes."),
      
      hr(),
      
      selectInput(
        inputId = "health_var",
        label = "Choose Health Outcome:",
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
