# load up the packages the ui will require
library(shiny)

# the navbar is the top bar with the pages of our app
navbarPage(id = "nav", title = "Global Life Expectancy vs. GDP per Capita", 
    
    # the first page is the main page, where data is to be uploaded and the plot is to be rendered
    tabPanel(value = "analysis", title = "Analysis",
 
      fluidPage(
            
            # the main page is broken up into a sidebar panel and main panel
            sidebarLayout(
                
                # the sidebar panel houses all of our widgets which control the resultant plot
                sidebarPanel(

                    # upload an .rds data file
                    fileInput("file1", "Upload Data:",
                              multiple = FALSE,
                              accept = c(".rds")),
                    
                    # dropdown menu with the continents
                    uiOutput("continentDropdown"),
                    
                    # slider to control gdpPercap variable
                    uiOutput("gdpSlider"),
                    
                    # checkbox to choose whether to log-transform the gdpPercap variable
                    uiOutput("logCheckbox"),
                    
                    # slider to control the population range that will be represented in the plot
                    uiOutput("popSlider"),
                    
                    # slider to select the year
                    uiOutput("yearSlider")
                ),
                
                # the main panel houses the plot generated based on the states of the widgets in the sidebar
                mainPanel(

                    # the plot is the only item in the main panel
                    plotlyOutput("mainPlot", width = "80%", height = "600px")
                
                )
            )
        )
    ),
    
    # the second page of the navbar is an about page that describes the app
    tabPanel(value = "about", title = "About",

      fluidPage(
      
            # the about page is generated from a markdown file within the app's directory
            includeMarkdown("about.md")
        )
    )
)
