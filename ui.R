library(shiny)

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Project Focus"),
      p("This app explores whether environmental burden is related to health outcomes across Chicago community areas."),
      p("Mini Project 1 connects to environmental exposure. Mini Project 2 connects to Chicago Health Atlas health outcomes.")
    ),
    
    mainPanel(
      
      h3("Environmental Burden vs Health Outcomes"),
      
      selectInput(
        "health_var",
        "Choose Health Outcome:",
        choices = c(
          "Asthma" = "asthma",
          "Obesity" = "obesity",
          "Hypertension" = "hypertension",
          "Diabetes" = "diabetes"
        )
      ),
      
      plotOutput("healthPlot"),
      
      hr(),
      
      h3("Environmental Burden vs Trust in Government"),
      
      plotOutput("trustPlot"),
      
      hr(),
      
      h3("Air Quality vs Asthma"),
      
      plotOutput("airPlot")
    )
  )
)