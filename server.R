#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#######
### Shiny Practice
### Working with Pantry Data
### Modeled off: https://github.com/atmajitg/bloodbanks/blob/master/server.R
#######

### Set Directory

#setwd("C:/Users/krosi/OneDrive/Documents/Thrive Work Stuff/Other Projects/Shiny Practice")

### Load Packages

library(shiny)
library(RCurl)
library(dplyr)
library(leaflet)
library(DT)

### Load Data

#pantry_data<-read.csv("pantry_locations.csv")
#head(pantry_data)

### Load Data w/ Github

x<-getURL("https://raw.githubusercontent.com/dkro23/Emergency_Food_Pantry/master/pantry_locations.csv")
pantry_data<-read.csv(text=x)
head(pantry_data)

### Shiny Server

shinyServer(function(input, output) {
  # Import Data and clean it
  
  pantry_data <- data.frame(pantry_data)
  pantry_data$lat <-  as.numeric(as.character(pantry_data$lat))
  pantry_data$lon <-  as.numeric(as.character(pantry_data$lon))
  pantry_data=filter(pantry_data, pantry_data$lat != "NA") # removing NA values
  
  # new column for the popup label
  
  pantry_data <- mutate(pantry_data, cntnt=paste0('<strong>Name: </strong>',Organization,
                                          '<br><strong>Address:</strong> ', Address,
                                          '<br><strong>City:</strong> ', City,
                                          '<br><strong>Zip:</strong> ',Zip,
                                          '<br><strong>Phone:</strong> ',Phone,
                                          '<br><strong>Service Area:</strong> ',Service.Area)) 
  
  # create a color paletter for category type in the data file
  
  #pal <- colorFactor(pal = c("#1b9e77", "#d95f02", "#7570b3"), domain = c("Charity", "Government", "Private"))
  
  # create the leaflet map  
  output$pantry_map <- renderLeaflet({
    leaflet(pantry_data) %>% 
      addCircles(lng = ~lon, lat = ~lat) %>% 
      addTiles() %>%
      addCircleMarkers(data = pantry_data, lat =  ~lat, lng =~lon, 
                       radius = 3, popup = ~as.character(cntnt), 
                       
                       stroke = FALSE, fillOpacity = 0.8)%>%
      
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
  })
  
  #create a data object to display data
  
  output$data <-DT::renderDataTable(datatable(
    pantry_data[,c(1:6)],filter = 'top',
    colnames = c("Organization","Address","City","Zip","Phone","Service Area")
  ))
  
  
})

