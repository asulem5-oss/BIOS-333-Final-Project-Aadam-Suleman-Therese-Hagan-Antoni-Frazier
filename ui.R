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
        choices = c("Spearman" = "spearman", "Pearson" = "pearson"),
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
      p("This scatterplot shows a clear connection between air pollution and health outcomes across Chicago’s 77 community areas. In general, neighborhoods with higher levels of PM2.5, which are tiny particles released from factories, vehicles, and industrial activity, also tend to have higher rates of asthma and obesity. The pattern is especially noticeable in many South and Southwest Side neighborhoods near industrial corridors, where pollution and chronic health conditions appear together most frequently. A correlation above 0.50 would suggest that poor air quality is strongly linked to these health problems at the community level. However, pollution is only part of the story. Many of the same neighborhoods facing high PM2.5 exposure also have fewer parks, limited access to healthy food, and fewer resources that support healthy lifestyles. Because of this, the relationship between pollution and obesity likely reflects a combination of environmental and socioeconomic challenges working together. Some neighborhoods may also appear as outliers, showing high pollution levels but lower disease rates. This could be related to better healthcare access, higher income levels, or other protective factors. Overall, the visualization highlights how environmental burdens in Chicago often overlap with communities that are already vulnerable, reinforcing long-standing health disparities across the city."),
      
      hr(),
      
      h3("NO2 Exposure vs Asthma"),
      plotOutput("airPlot"),
      p("Nitrogen dioxide, or NO2, is an important marker for traffic-related air pollution. Unlike PM2.5, which can travel longer distances, NO2 is usually more localized, meaning its levels are often highest near major roads, highways, and transportation corridors. Because of this, the NO2 versus asthma scatterplot helps measure how Chicago’s transportation infrastructure may relate to respiratory health outcomes. In this graph, we are looking for whether communities with higher NO2 exposure also tend to have higher asthma prevalence. This relationship is especially important in neighborhoods located near expressways, trucking routes, rail yards, and other high-traffic areas. If the regression line shows a positive trend, it suggests that even small increases in traffic-related pollution may be associated with higher asthma rates. The R-value and p-value help show how strong and reliable this relationship is in the dataset. If the Spearman correlation is stronger than Pearson, that may suggest the relationship is not perfectly linear and that asthma rates may increase more sharply after pollution reaches a certain level. From a public health perspective, this plot shows that the effects of Chicago’s transit system are not evenly distributed. Some communities carry a greater environmental burden because of where roads and industrial transportation routes were built."),
      
      hr(),
      
      h3("Traffic Risk vs Hypertension"),
      plotOutput("trafficHyperPlot"),
      p("The scatterplot comparing Traffic Risk and Hypertension helps show how heavily trafficked environments may be connected to cardiovascular health outcomes across Chicago neighborhoods. Traffic risk reflects more than just the number of vehicles on the road. It also represents how close people live to busy streets, highways, industrial transportation areas, and other high-density transit zones. In this analysis, we are looking to see whether neighborhoods with higher traffic exposure also tend to have higher hypertension prevalence. Unlike PM2.5 or NO2 alone, traffic-related exposure can also include long-term stressors such as noise pollution, overcrowding, reduced walkability, and limited access to green space, all of which may contribute to chronic stress on the body over time. In Chicago, many neighborhoods located near major highways, rail yards, freight corridors, and airport-related transportation zones often experience both elevated traffic activity and higher rates of chronic health conditions. If the graph shows a positive trend between traffic risk and hypertension, it suggests that the built environment may play a role in shaping cardiovascular health outcomes within communities. Although hypertension can also be influenced by age, diet, genetics, and healthcare access, a stronger correlation in this analysis would support the idea that environmental conditions contribute additional risk. Overall, this plot highlights how neighborhood infrastructure and long-term environmental exposure may affect public health differently across Chicago community areas."),
      
      hr(),
      
      h3("Temperature vs PM2.5"),
      plotOutput("tempPlot"),
      p("The scatterplot comparing Temperature and PM2.5 helps provide more environmental context for understanding the pollution exposure patterns shown throughout the dashboard. In many urban environments like Chicago, hotter temperatures are often linked with worse air quality because heat can trap pollutants closer to the ground and contribute to the formation of secondary particulate matter. This is especially noticeable during periods of stagnant air or temperature inversions, where warmer air sits above cooler air and prevents pollutants from dispersing normally. Areas with large amounts of concrete, traffic, and limited green space can experience stronger urban heat island effects, which may further increase pollution concentrations. Looking at this relationship also helps identify periods where residents may face greater environmental risk. If PM2.5 levels increase as temperature rises, it suggests that hotter days may contribute to poorer air conditions across certain Chicago neighborhoods. This is important from a public health perspective because heat waves may increase not only heat-related illness, but also respiratory stress caused by elevated particulate exposure. The regression line and correlation statistics help show whether temperature may be contributing to changes in PM2.5 levels or whether other factors, such as industrial activity and traffic density, may play a larger role. Overall, this graph supports the idea that air pollution in Chicago is dynamic and influenced by both environmental and urban conditions rather than remaining constant over time."),
      
      hr(),
      
      h3("Strongest Observed Environmental-Health Relationship"),
      plotOutput("bestPlot"),
      p("This visualization displays the strongest observed relationship found in the combined environmental-health dataset. Instead of only focusing on one possible comparison, the app tests multiple relationships between environmental variables and health outcomes, including PM2.5, NO2, traffic risk, temperature, asthma, obesity, hypertension, and diabetes. The strongest observed relationship is selected based on the correlation results, especially the p-value and correlation coefficient. This helps identify which environmental factor appears most closely connected to health or pollution patterns in the data. However, this graph should still be interpreted carefully. A statistically significant result does not automatically prove that one variable caused the other. It only means that the relationship is unlikely to be due to random chance within this dataset. If the strongest relationship is between two environmental variables, such as Temperature and NO2, it may help explain pollution behavior, but it may not directly answer the health-disparity question. If the strongest relationship involves asthma, hypertension, obesity, or diabetes, then it provides stronger support for the project’s main environmental-health argument. Overall, this graph helps guide interpretation by showing which patterns in the dataset are strongest, while still allowing the project to discuss limitations, confounding factors, and the difference between correlation and causation."),
      
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