#' @title UI for selecting vessel and map texture
#' @description  Absolute panel for used to select vesel and leaflet details from a dropdown
#'
#' @param id shiny id
#'
#' @importFrom shiny NS tagList absolutePanel
#' @importFrom shiny.sementic dropdown_input label
uiDropdown <- function(id) {
  ns <- NS(id)
  
  tagList(
    absolutePanel(
      top = 60,
      right = 20,
      width = 300,
      
      p("Select a Vessel:"),
      dropdown_input(
        ns("vessel"),
        c(),
        default_text = "Vessel",
        value = ""
      ),
      
      p("Select a Map Texture:"),
      dropdown_input(
        ns("mapTexture"),
        choices = c(
          "OpenStreetMap.Mapnik",
          "CartoDB.Positron",
          "Esri.NatGeoWorldMap",
          "Stamen.Terrain"
        ),
        choices_value = c(
          "OpenStreetMap.Mapnik",
          "CartoDB.Positron",
          "Esri.NatGeoWorldMap",
          "Stamen.Terrain"
        ),
        value = "CartoDB.Positron"
      ),
      
      br(),
      label("Note: Blue circle is the end of observation.")
    )
  )
}

#' @title Server for selecting vessel and map texture
#' @description  Absolute panel for used to select vesel and leaflet details from a dropdown
#'
#' @param id shiny id
#' @param ships ships dataset
#' @param datastore reactable data store to return values from user selection
#'
#' @importFrom shiny reactive observeEvent
#' @importFrom shiny.sementic update_dropdown_input
dropdownServer <- function(id, ships, datastore) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 datastore$vessel <- reactive({
                   input$vessel
                 })
                 datastore$texture <- reactive({
                   input$mapTexture
                 })
                 
                 observeEvent(datastore$nav_option, {
                   update_dropdown_input(session, "vessel",
                                         ships[ships$ship_type == datastore$nav_option, "vessel_name"],
                                         ships[ships$ship_type == datastore$nav_option, "SHIP_ID"])
                 })
               })
}
