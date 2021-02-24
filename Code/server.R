# define server logic to render ui elements and the resultant plot
shinyServer(function(input, output) {

    # function to access inputted data, if present
    getFile <- reactive({
        
        # only proceed once a data file is uploaded
        req(input$file1)
        
        # attempt to load the data into a data frame
        tryCatch(
            df <- readRDS(input$file1$datapath),
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
        )
        
        # return the data as a data frame
        df
    })
        
    # function to reduce data to just that which is defined by widget states
    getData <- reactive({
        
        # only proceed once a data file is uploaded and the dropdown widget is loaded
        req(input$file1)
        req(input$continent)
        
        # attempt to load the data into a data frame
        tryCatch(
            df <- readRDS(input$file1$datapath),
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
        )
        
        # filter the data based on continent dropdown and year slider
        if(input$continent != "All"){
            df = df %>% filter(continent == input$continent)
        }
        
        df = df %>% filter(year == input$year)

        # return the filtered data frame  
        df
    })
    
    # dropdown menu to select the limit the data to a specific continent   
    output$continentDropdown <- renderUI({
        df <- getFile()
        selectInput("continent", "Choose Continent:", choices = c("All", levels(unique(df$continent))))
    })
    
    # slider to adjust the range of GDP per capita values, based on other widget selections
    output$gdpSlider <- renderUI({
        df <- getData() 

        values = round(df$gdpPercap)
        if(input$logGDP == TRUE){
            values = round(log10(values),4)
        }
        sliderInput("gdpRange", "Select GDP per Capita Range:", min = min(values), max = max(values), value = c(min(values),max(values)))
    })

    # slider to adjust the range of population values, based on other widget selections
    output$popSlider <- renderUI({
        df <- getData() 
        values = round(df$pop)
        sliderInput("popRange", "Select Population Range:", min = min(values), max = max(values), value = c(min(values),max(values)))
    })
    
    # slider to select the year from which data will be selected for plotting
    output$yearSlider <- renderUI({
        req(input$file1)
        sliderInput("year", "Select Year:", min = 1952, max = 2007, step = 5, value = 1952, sep = "", animate = TRUE)
    })
    
        
    # checkbox to choose whether to log-transform gdp per capita
    output$logCheckbox <- renderUI({
        req(input$file1)
        checkboxInput("logGDP", "Log-transform GDP per Capita?", value = FALSE)
    })
    
    # render the plotly plot that will be displayed in the main panel on the analysis page
    output$mainPlot <- renderPlotly({
        
        # make sure some data was uploaded, then generate a data frame from it
        req(input$file1)
        df <- getData()

        # be sure that the gdp slider element is rendered before proceeding
        validate(
            need(input$gdpRange != "", "Loading...")
        )
        
        # perform some alterations to the data frame based on widget states before plotting the data  
        log = ""
        if(input$logGDP == TRUE) {
          log = "log-"
          df$gdpPercap = log10(df$gdpPercap)
        }
        df = df %>% filter(between(gdpPercap, input$gdpRange[1], input$gdpRange[2]))
        df = df %>% filter(between(pop, input$popRange[1], input$popRange[2])) 
        
        # just a sanity check to make sure there's data to be plotted
        if(nrow(df) == 0) {plot(1,1, pch = 19, col = "red")}
        
        # if there's some data to plot, plot it
        else{
          
          # generate a plotly scatter plot from the data
          p = plot_ly(df, x = ~gdpPercap, y = ~lifeExp, type = 'scatter', mode = 'markers', size = ~pop, color = ~continent,
                      sizes = c(10, 50),
                      marker = list(opacity = 0.5, sizemode = 'diameter'),
                      hoverinfo = 'text',
                      fill = ~'',
                      text = ~paste("Country: ", country, "<br>", log, "GDP per Capita: ", round(gdpPercap,3), "<br>Life Expectancy: ", lifeExp, sep = ""))
          
          # adjust the format of the plot
          fig = p %>% layout(title = paste("Life Expectancy vs. ", log, "GDP per Capita in ", input$year, sep = ""),
                                xaxis = list(title = paste(log, "GDP per Capita", sep = ""), showgrid = FALSE, zeroline = FALSE),
                                yaxis = list(title = "Life Expectancy", range = c(25, 85), showgrid = FALSE, zeroline = FALSE),
                                showlegend = TRUE)

          # return the formatted plotly plot
          fig
        }
    })
    
})
