library(shiny)
library(dplyr)
library(ggplot2)

#function that creates dataframes to be used in the shiny app, starting from existing csv files.
createDF<- function(pm_city){
  city <- substr(pm_city, 6, nchar(pm_city))
  db<- read.csv(paste0(pm_city,".csv"))
  date_city <- as.Date(db$utc, format("%d/%m/%y"))
  date <- c(date_city)
  value <- c(db$value)
  city <- c(city)
  df <- data.frame(date, value, city)
  return(df)
}

#application of the function on the csv files
dfrome <- createDF("pm10_Rome")
dfberlin <- createDF("pm10_Berlin")
dfporto <- createDF("pm10_Porto")
dfparis <- createDF("pm10_Paris")

#combination of dataframes
stack_data <-rbind(dfrome, dfberlin, dfparis, dfporto)
stack_databis <- rbind(dfrome, dfberlin, dfparis, dfporto)

#user interface
ui<- fluidPage(
  titlePanel(h2("Pm10 Concentration Comparing", align="center")),
  sidebarLayout(
    sidebarPanel(
      
      #the user can choose two country, using two select input tools.
      selectInput(inputId= "dataset",
                  label= "Choose a city: ",
                  choices = c("Rome", "Berlin", "Paris", "Porto"),
                  selected = "Rome"),
      
      selectInput(inputId= "datasetbis",
                  label= "Choose another city: ",
                  choices = c("Rome", "Berlin", "Paris", "Porto"),
                  selected = "Berlin")),
    
    #creation of the tabs
    mainPanel(
      tabsetPanel(id = "tab",
                  tabPanel("Plot", plotOutput("ts_plot")),
                  tabPanel("Summary", 
                           helpText("First city selected:"), verbatimTextOutput("summary"), 
                           helpText("Second city selected:"),verbatimTextOutput("summarybis")),
                  tabPanel("T-test", 
                           helpText("This test is used to determin whether the means of 
                                     the two groups are equal to each other:"), 
                           verbatimTextOutput("test"),
                           helpText("If the p-value is larger than 0.05, the null hypothesis is accepted")),
                  tabPanel("BoxPlot", fluidRow(
                    column(5, plotOutput("boxplot_main")), 
                    column(5, plotOutput("boxplot_comparing"))
                          ))
                  ))
    )
  )

#server of the application
server<- shinyServer(
  
  function(input, output){
    
    datasetInput <- reactive({
      stack_data %>% filter(city == input$dataset)
    })
    
    datasetInputbis <- reactive({
      stack_databis %>% filter(city == input$datasetbis)
    })
    
    #Summary information of the pm10 concentration for the first country
    output$summary <- renderPrint({
      dataset <-datasetInput()
      summary(dataset$value)
      
    })
    
    #Summary information of the pm10 concentration for the second country
    output$summarybis <- renderPrint({
      datasetbis <-datasetInputbis()
      summary(datasetbis$value)
      
    })
    
    #t-test output applied on the two cities selected
    output$test <- renderPrint({
      dataset <- datasetInput()
      datasetbis <- datasetInputbis()
      First_city <- dataset$value
      Second_city <- datasetbis$value
      t.test(First_city, Second_city, alternative = "two.sided", conf.level = 0.95)
      
    })
    
    #time series graph output with the two series in the same graph
    output$ts_plot <- renderPlot({
      
      dataset <- datasetInput()
      datasetbis <- datasetInputbis()
      
      ggplot() +
        
        geom_line(aes(x=date, y=value, colour=input$dataset), dataset)+
        geom_line(aes(x=date, y=value, colour=input$datasetbis), datasetbis)+ 
        scale_color_discrete(name = "Legenda:")+
        geom_hline(colour="red", aes(yintercept=50)) +
        
        labs(title="PM10 Concentration", 
             subtitle="Analysis from 27 October to 31 December", 
             x = "Date", y="pm10 (µg/m^3)") +
        theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))+
        theme(plot.title = element_text(face = "bold"))
      
      
    })
    
   #boxplot for the first city selected 
    output$boxplot_main <- renderPlot({
      dataset <- datasetInput()
      
      ggplot(dataset, aes(,y=value)) + geom_boxplot() +  scale_y_continuous(limits = c(0, 70))+ 
        labs(title= input$dataset)+ 
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
      
    })
    
    #boxplot for the second city selected     
    output$boxplot_comparing <- renderPlot({
      datasetbis <- datasetInputbis()
      
      ggplot(datasetbis, aes(,y=value)) + geom_boxplot() + scale_y_continuous(limits = c(0, 70))+
        labs(title= input$datasetbis)+ 
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
      
    })
  })

shinyApp(ui=ui, server=server)




