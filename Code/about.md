### What is this thing?

This app is a basic demonstration of the [Shiny package](https://shiny.rstudio.com/) for [R Studio](https://rstudio.com/).

It allows a user to generate different plots comparing selected countries' mean life expectancy to their respective economic strength (measured as GDP per capita) from 1952 to 2007.

### Usage

More generalized Shiny apps can handle a diverse set of input files, but as a simplified example, this app is designed to interact specifically with data from R's [gapminder package](https://cran.r-project.org/web/packages/gapminder/index.html) which has been stored in a .rds file.

<span style="background-color:#fff5ed">Click <font color = "red"><a href = "https://blog.joeknittel.com/assets/data.rds">here</a></font> to download the required data file.</span>`

With the .rds data file in hand, you can proceed to use the app by first navigating to the *Analysis* page in the navigation bar at the top.

Once on the *Analysis* page, you'll be tasked with uploading a data file. To do so, just click the **Browse...** button and find the .rds file you just downloaded on your hard drive. This will load several widgets in the sidebar and an interactive plot in the main panel.

By adjusting the state of the various widgets found in the left sidebar, you can hone into specific regions, economy sizes, populations, and years to gain better insight into the relationship between the independent and dependent variables.

### Code

All code used to generate this app can be found [here](https://www.github.com/JoeKnittel/Shiny-Demo).

### Blog

A blog post describing the creation process of this app can be found [here](https://blog.joeknittel.com/2021/02/21/Creating-an-App-With-R-Shiny.html).

### Author

Copyright &#169; 2021 [Joe Knittel](https://joeknittel.com)
