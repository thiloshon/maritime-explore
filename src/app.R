library(shiny)
library(shiny.semantic)
library(shinyjs)
library(leaflet)
library(plotly)

source("module_dropdown.R")
source("module_navbar.R")

# Access this app at https://shining-thiloshon.shinyapps.io/MaritimeExplorer/

# load datasets
ship_dataset <- as.data.frame(readRDS("data/shiny_data.rds"))
ship_stats <- readRDS("data/additional_vis.rds")

data_store <- reactiveValues(
    nav_option = "Passenger", 
    vessel = character(), 
    texture = character()
    )

# JS Code to change BG color when map texture changes
jsCode <-
    "shinyjs.pageCol = function(params){$('body').css('background', params);}"


ui <- semanticPage(
    
    useShinyjs(),
    extendShinyjs(text = jsCode, functions = c("pageCol")),
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$script(src = "script.js")
    ),
    
    grid(
        grid_template(default = list(
            areas = rbind(c("title", "title"),
                          c("left", "right")),
            cols_width = c("1fr", "1fr"),
            rows_height = c("50px", "1fr")
        )),
        id = "toplevelgrid",
        
        #------ TITLE GRID -----
        title = header(
            title = "Maritime Tracker 0.1",
            description = "Ships Dashboard",
            icon = "ship"
        ),
        
        #------
        left =  grid(
            grid_template(default = list(
                areas = rbind(c("nav", "map")),
                cols_width = c("100px", "1fr"),
                rows_height = c("1fr")
            )),
            id = "rightgrid",
            
            #------ VERTICLE NAV BUTTON GRID ------
            nav = div(uiNavbar("navbutton"), ),
            
            #------ MAP GRID -----
            map = div (segment(
                class = "basic",
                leafletOutput("map"),
                uiDropdown("leafletPanel")
            ))
            #------
        ),
        #------
        right = grid(
            grid_template(default = list(
                areas = rbind(
                    c("totalcard", "sailingcard", "portedcard"),
                    c("infocard", "infocard", "infocard"),
                    c("plot", "plot", "plot")
                ),
                cols_width = c("1fr", "1fr", "1fr"),
                rows_height = c("160px", "0.5fr", "1fr")
            )),
            id = "cardsgrid",
            
            area_styles = list(
                totalcard = "margin: 10px;",
                sailingcard = "margin: 10px;",
                portedcard = "margin: 10px;",
                infocard = "margin: 10px;",
                plot = "margin: 10px;"
            ),
            
            #------ BIG NUMBER CARDS GRID  
            totalcard = card(div(
                class = "content",
                div(class = "header largeBlueText",
                    textOutput("totalVessel")),
                icon("ship"),
                div(class = "description", "TOTAL NUMBER OF VESSELS")
            )),
            
            sailingcard = card(div(
                class = "content",
                div(class = "header largeGreenText",
                    textOutput("totalSailing")),
                icon("paper plane"),
                div(class = "description", "NUMBER OF VESSELS SAILING")
            )),
            
            portedcard = card(div(
                class = "content",
                div(class = "header largeRedText",
                    textOutput("totalPorted")),
                icon("anchor"),
                div(class = "description", "NUMBER OF VESSELS PORTED")
            )),
            
            #------ VESSEL INFORMATION GRID ----
            infocard = div(
                h2(class = "ui header", "Vessel Information:"),
                div(
                    class = "ui card fullwidth",
                    
                    div(
                        class = "content",
                        div(class = "right floated meta", "Vessel Lookup"),
                        img(class = "ui avatar image", src = "images/fishing.png"),
                        textOutput("currentVessel")
                    ),
                    
                    div(
                        cards(class = "three", 
                              card(div(class = "content", div(p(class="ui green ribbon label", "Destination")),
                                       div(class = "description", textOutput("destination")))),
                              
                              card(div(class = "content", div(p(class="ui green ribbon label", "Flag")),
                                       div(class = "description", textOutput("flag")))),
                              
                              card(div(class = "content", div(p(class="ui green ribbon label", "Length")),
                                       div(class = "description", textOutput("length")))),
                              
                              card(div(class = "content", div(p(class="ui green ribbon label", "Last observed date")),
                                       div(class = "description", textOutput("date")))),
                              
                              card(div(class = "content", div(p(class="ui green ribbon label", "Port")),
                                       div(class = "description", textOutput("port")))),
                              
                              card(div(class = "content", div(p(class="ui green ribbon label", "Anchored?")),
                                       div(class = "description", textOutput("anchor")))),
                        )
                    ),
                )
            ),
            
            #---- PORTS BAR PLOT GRID ---
            plot = div(
                h2(class = "ui header", "Breakdown of Ports Usage:"),
                plotlyOutput("statsplot", height = "350px")
            )
        )
    )
)



server <- function(input, output, session) {
    
    # get the selected ship type from nav bar
    navbarServer("navbutton", data_store)
    
    # get the selected vessel from dropdown
    dropdownServer("leafletPanel", ship_dataset, data_store)
    
    # use the map texture and vessel details got from dropdown to populate map
    output$map <- renderLeaflet({
        if (data_store$vessel() == "" ||
            is.null(data_store$vessel())) {
            return()
        }
        
        filtered_data <-
            ship_dataset[ship_dataset$SHIP_ID == data_store$vessel(),]
        
        toast(
            paste(
                filtered_data$SHIPNAME,
                "sailed at most",
                ceiling(filtered_data$distance),
                "meters between observations."
            ),
            title = "Longest Observation Trivia!",
            duration = 5,
        )
        
        # trigger BG color change 
        if (data_store$texture() == "OpenStreetMap.Mapnik") {
            js$pageCol("#aad3df")
        } else if (data_store$texture() == "CartoDB.Positron") {
            js$pageCol("#d4dadc")
        } else if (data_store$texture() == "Esri.NatGeoWorldMap") {
            js$pageCol("#80b7e0")
        } else if (data_store$texture() == "Stamen.Terrain") {
            js$pageCol("#99b3cc")
        }
        
        leaflet(filtered_data, options = leafletOptions(zoomControl = FALSE)) %>%
            addProviderTiles(data_store$texture()) %>%
            clearShapes() %>%
            addCircles( ~ LON, ~ LAT, color = "blue", radius = 100, opacity = 0.8, fillOpacity = 1) %>%
            addCircles( ~ lon_prev, ~ lat_prev, color = "red", radius = 50, opacity = 0.8, fillOpacity = 1)  %>%
            setView(lng = filtered_data$LON,
                    lat = filtered_data$LAT,
                    zoom = 12)
    })
    
    # trio statistic boxes
    output$totalVessel <-
        renderText({
            sum(ship_stats$most_recent$ship_type == data_store$nav_option)
        })
    
    output$totalSailing <-
        renderText({
            sum(ship_stats$most_recent[ship_stats$most_recent$ship_type == data_store$nav_option, ]$is_parked == 0)
        })
    
    output$totalPorted <-
        renderText({
            sum(ship_stats$most_recent[ship_stats$most_recent$ship_type == data_store$nav_option, ]$is_parked)
        })
    
    # information for vessel section
    observeEvent(data_store$vessel(), {
        
        filtered_data <-
            ship_dataset[ship_dataset$SHIP_ID == data_store$vessel(), ]
        
        output$currentVessel <- renderText(filtered_data$SHIPNAME)
        output$flag <- renderText(filtered_data$FLAG)
        output$length <- renderText(paste0(filtered_data$LENGTH, " meters"))
        output$port <- renderText(filtered_data$port)
        output$anchor <- renderText(ifelse(filtered_data$is_parked == 1, "Yes", "No"))
        output$date <- renderText(as.character(filtered_data$DATETIME))
        output$destination <- renderText(filtered_data$DESTINATION)
    })
    
    # plot
    output$statsplot <- renderPlotly({
        dat <-
            ship_stats$port_usage[ship_stats$port_usage$ship_type == data_store$nav_option, ]
        dat %>% plot_ly(
            x = ~ port,
            y = ~ n,
            color = ~ FLAG,
            colors = "Set1"
        )  %>%
            layout(
                barmode = "stack",
                xaxis = list(title = ''),
                yaxis = list(title = 'Number of Ships')
            )
    })
}

shinyApp(ui, server)
