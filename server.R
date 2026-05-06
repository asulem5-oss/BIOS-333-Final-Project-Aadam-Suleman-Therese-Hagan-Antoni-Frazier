server <- function(input, output) {
  
  # INTERACTIVE HEALTH PLOT
  output$healthPlot <- renderPlot({
    
    ggplot(
      cha_clean,
      aes(
        x = env_burden,
        y = .data[[input$health_var]]
      )
    ) +
      
      geom_point(size = 3, alpha = 0.7) +
      
      geom_smooth(method = "lm", se = TRUE) +
      
      theme_minimal() +
      
      labs(
        title = "Environmental Burden vs Health Outcome",
        subtitle = "Chicago community areas",
        x = "Environmental Burden",
        y = input$health_var
      )
  })
  
  
  # TRUST IN GOVERNMENT PLOT
  output$trustPlot <- renderPlot({
    
    ggplot(
      cha_clean,
      aes(
        x = env_burden,
        y = trust_gov
      )
    ) +
      
      geom_point(size = 3, alpha = 0.7) +
      
      geom_smooth(method = "lm", se = TRUE) +
      
      theme_minimal() +
      
      labs(
        title = "Environmental Burden vs Trust in Government",
        subtitle = "Chicago community areas",
        x = "Environmental Burden",
        y = "Trust in Government"
      )
  })
  
  
  # AIR QUALITY VS ASTHMA
  output$airPlot <- renderPlot({
    
    ggplot(
      cha_clean,
      aes(
        x = air_quality,
        y = asthma
      )
    ) +
      
      geom_point(size = 3, alpha = 0.7) +
      
      geom_smooth(method = "lm", se = TRUE) +
      
      theme_minimal() +
      
      labs(
        title = "Air Quality vs Asthma",
        subtitle = "Chicago community areas",
        x = "Air Quality",
        y = "Asthma"
      )
  })
  
}