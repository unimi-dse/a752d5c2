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
