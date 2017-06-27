#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application 
ui <- fluidPage(
   
   # Application title
   titlePanel("Oregon State Assembly Legislative District Lookup"),
   
   # Sidebar with text input
   sidebarLayout(
      sidebarPanel(
         textInput("zip", "Enter Zip Here"),
         p("Lookup uses 5 digit zip codes")
      ),
      
      # Show a HTML table
      mainPanel(
         dataTableOutput("district"),
         p("Open Source, Open License, Open Use")
      )
   )
)

# Define server logic 
server <- function(input, output) {
   
  library(dplyr)
  library(tidyr)
  
  file <- readLines(url("https://www2.census.gov/geo/relfiles/cdsld13/41/zc_lu_41.txt"))
  file <- file[-c(1,2)]
  
  file2 <- readLines(url("https://www2.census.gov/geo/relfiles/cdsld13/41/zc_ll_41.txt"))
  file2 <- file2[-c(1,2)]
  
  df <-  strsplit(file, split = '\\s+')[-(1:2)]
  
  df <- as.data.frame(do.call("rbind", df), stringsAsFactors = FALSE)
  colnames(df) <- c("ZIP", "Senate Districts")
  
  df2 <-  strsplit(file2, split = '\\s+')[-(1:2)]
  
  df2 <- as.data.frame(do.call("rbind", df2), stringsAsFactors = FALSE)
  colnames(df2) <- c("ZIP", "House Districts")
  
  df <- left_join(df,df2, by = ("ZIP" = "ZIP"))
  
  output$district <- renderDataTable({
    req(input$zip)
    df %>%
      filter(ZIP %in% input$zip)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

