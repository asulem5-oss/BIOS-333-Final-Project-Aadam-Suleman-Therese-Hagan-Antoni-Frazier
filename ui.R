library(shiny)

ui <- fluidPage(
  
  titlePanel("BIOS 333 Final Project: Chicago Environment and Health"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Controls"),
      p("This dashboard connects Open Air Chicago pollution data with Chicago Health Atlas community health outcomes."),
      
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
      
      h3("Main Research Question"),
      p("To what extent do localized traffic and industrial pollution burdens predict the geographic disparity of chronic disease prevalence across Chicago’s 77 community areas?"),
      
      hr(),
      
      h3("PM2.5 Exposure vs Selected Health Outcome"),
      plotOutput("healthPlot"),
      p("This scatterplot shows the relationship between PM2.5 exposure and chronic health outcomes across Chicago community areas. In general, neighborhoods with higher levels of particulate pollution may also show higher asthma or obesity prevalence. Many of these neighborhoods are located near industrial corridors and high-traffic zones, suggesting that environmental burdens and chronic disease patterns often overlap across vulnerable communities."),
      
      hr(),
      
      h3("NO2 Exposure vs Asthma"),
      plotOutput("airPlot"),
      p("Nitrogen dioxide, or NO2, is closely connected to traffic-related air pollution. Unlike PM2.5, NO2 is more localized around major roads, highways, and transportation corridors. This graph helps show whether communities exposed to heavier traffic activity also experience higher asthma prevalence, especially near major expressways and transit hubs."),
      
      hr(),
      
      h3("Traffic Risk vs Hypertension"),
      plotOutput("trafficHyperPlot"),
      p("This graph explores the relationship between traffic exposure and hypertension prevalence across Chicago neighborhoods. Traffic risk represents more than just vehicle density. It can also reflect long-term environmental stressors such as noise pollution, overcrowding, reduced walkability, and living near highways or freight corridors. These conditions may place extra stress on cardiovascular health over time."),
      
      hr(),
      
      h3("Temperature vs PM2.5"),
      plotOutput("tempPlot"),
      p("The Temperature versus PM2.5 graph provides environmental context for understanding pollution patterns across Chicago. Higher temperatures can contribute to stagnant air conditions and may increase particulate pollution during certain weather patterns. This helps show that air pollution is not static, but changes with environmental and seasonal conditions."),
      
      hr(),
      
      h3("Strongest Observed Environmental-Health Relationship"),
      plotOutput("bestPlot"),
      p("This visualization displays the strongest observed correlation identified in the combined environmental-health dataset. The graph compares the relationship with the lowest p-value and strongest correlation coefficient among the tested variables. This helps identify which environmental factor has the strongest association with health outcomes in this dataset."),
      
      hr(),
      
      h3("Strongest Correlation Test Result"),
      verbatimTextOutput("bestStats"),
      
      hr(),
      
      h3("All Tested Correlations"),
      tableOutput("corTable"),
      
      hr(),
      
      h3("Preview of Combined Data"),
      tableOutput("dataTable")
    )
  )
)