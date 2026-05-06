#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Controls"),
      
      selectInput(
        inputId = "continent",
        label = "Choose a Continent:",
        choices = c("Africa", "Americas", "Asia", "Europe", "Oceania")
      )
    ),
    
    mainPanel(
      h3("Plot Output"),
      
      plotOutput("lifePlot")
    )
  )
)

server <- function(input, output) {
  
  output$lifePlot <- renderPlot({
    hist(rnorm(100),
         main = paste("Example Plot for", input$continent),
         col = "skyblue",
         border = "white")
  })
}

shinyApp(ui = ui, server = server)
