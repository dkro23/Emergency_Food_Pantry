#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

######
### Shiny UI Practice
### Working w/ Pantry data
### https://github.com/atmajitg/bloodbanks/blob/master/ui.R
######

library(shiny)
library(leaflet)

navbarPage("Location of Emergency Food Pantries", id="main",
           tabPanel("Map", leafletOutput("pantry_map", height=1000)),
           tabPanel("Data", DT::dataTableOutput("data")))

