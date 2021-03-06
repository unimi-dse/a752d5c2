server<- shinyServer(

  function(input, output){

    #dataframe creation   pm10comparing::pm10

    concentration_level <- pm10comparing::pm10
    date_city <- as.Date(concentration_level$utc, format("%d/%m/%y"))
    date <- c(date_city)
    value <- c(concentration_level$value)
    city <- c(as.character(concentration_level$city))
    df <- data.frame(date, value, city)

    stack_data <- df
    stack_databis <- df

    datasetInput <- reactive({
      dplyr::filter(stack_data, stack_data$city == input$dataset)
    })

    datasetInputbis <- reactive({
       dplyr::filter(stack_databis,stack_databis$city == input$datasetbis)
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

      ggplot2::ggplot() +

        ggplot2::geom_line(ggplot2::aes(x=date, y=value, colour=input$dataset), dataset)+
        ggplot2::geom_line(ggplot2::aes(x=date, y=value, colour=input$datasetbis), datasetbis)+
        ggplot2::scale_color_discrete(name = "Legenda:")+
        ggplot2::geom_hline(colour="red", ggplot2::aes(yintercept=50)) +

        ggplot2::labs(title="PM10 Concentration",
             subtitle="Analysis from 27 October to 31 December",
             x = "Date", y="pm10 (µg/m^3)") +
        ggplot2::theme(plot.margin = ggplot2::margin(0.5, 0.5, 0.5, 0.5, "cm"))+
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"))


    })

    #boxplot for the first city selected
    output$boxplot_main <- renderPlot({
      dataset <- datasetInput()

      ggplot2::ggplot(dataset, ggplot2::aes(,y=value)) + ggplot2::geom_boxplot() +  ggplot2::scale_y_continuous(limits = c(0, 70))+
        ggplot2::labs(title= input$dataset)+
        ggplot2::theme(axis.title.x=ggplot2::element_blank(), axis.text.x=ggplot2::element_blank(), axis.ticks.x=ggplot2::element_blank())

    })

    #boxplot for the second city selected
    output$boxplot_comparing <- renderPlot({
      datasetbis <- datasetInputbis()

      ggplot2::ggplot(datasetbis, ggplot2::aes(,y=value)) + ggplot2::geom_boxplot() + ggplot2::scale_y_continuous(limits = c(0, 70))+
        ggplot2::labs(title= input$datasetbis)+
        ggplot2::theme(axis.title.x=ggplot2::element_blank(), axis.text.x=ggplot2::element_blank(), axis.ticks.x=ggplot2::element_blank())

    })

    #Augmented Dickey-Fuller (ADF): Unit Root Test, first city
      output$adf <- renderPrint({
      dataset <-datasetInput()
      First_city <- dataset$value
      tseries::adf.test(First_city)
      })

    #Augmented Dickey-Fuller (ADF): Unit Root Test, second city
        output$adfbis <- renderPrint({
        datasetbis <-datasetInputbis()
        Second_city <- datasetbis$value
        tseries::adf.test(Second_city)
      })

  })





