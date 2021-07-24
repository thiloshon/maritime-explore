
# Instead of dropdown a collection of buttons to increase aesthetics.
uiNavbar <- function(id) {
  ns <- NS(id)
  tagList(
    action_button(
      ns("passenger"),
      "Passenger",
      tags$img(src = "images/passenger.png"),
      class = "bordersolid"
    ),
    
    action_button(
      ns("pleasure"),
      "Pleasure",
      tags$img(src = "images/pleasure.png")
    ),
    
    action_button(
      ns("cargo"),
      "Cargo",
      tags$img(src = "images/cargo.png")),
    
    action_button(
      ns("fishing"),
      "Fishing",
      tags$img(src = "images/fishing.png")
    ),
    
    action_button(
      ns("navigation"),
      "Navigation",
      tags$img(src = "images/navigation.png")
    ),
    
    action_button(
      ns("tanker"),
      "Tanker",
      tags$img(src = "images/tanker.png")),
    
    action_button(
      ns("tug"),
      "Tug",
      tags$img(src = "images/tug.png")),
    
    action_button(
      ns("highspecial"),
      "High Special",
      tags$img(src = "images/highspecial.png")
    ),
    
    action_button(
      ns("unspecified"),
      "Unspecified",
      tags$img(src = "images/unspecified.png")
    )
  )
}


navbarServer <- function(id, datastore) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 observeEvent(input$passenger, {
                   remove_css_class(ns, 'passenger', 'Passenger', datastore)
                 })
                 
                 observeEvent(input$pleasure, {
                   remove_css_class(ns, 'pleasure', 'Pleasure', datastore)
                 })
                 
                 observeEvent(input$cargo, {
                   remove_css_class(ns, 'cargo', 'Cargo', datastore)
                 })
                 
                 observeEvent(input$fishing, {
                   remove_css_class(ns, 'fishing', 'Fishing', datastore)
                 })
                 
                 observeEvent(input$navigation, {
                   remove_css_class(ns, 'navigation', 'Navigation', datastore)
                 })
                 
                 observeEvent(input$tanker, {
                   remove_css_class(ns, 'tanker', 'Tanker', datastore)
                 })
                 
                 observeEvent(input$tug, {
                   remove_css_class(ns, 'tug', 'Tug', datastore)
                 })
                 
                 observeEvent(input$highspecial, {
                   remove_css_class(ns, 'highspecial', 'High Special', datastore)
                 })
                 
                 observeEvent(input$unspecified, {
                   remove_css_class(ns, 'unspecified', 'Unspecified', datastore)
                 })
                 
               })
}

remove_css_class <- function(ns, identifier, navoption, datastore){
  shinyjs::runjs(code = paste('$("#', ns("passenger"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("pleasure"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("cargo"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("fishing"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("navigation"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("tanker"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("tug"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("highspecial"), '").removeClass("bordersolid");', sep = ""))
  shinyjs::runjs(code = paste('$("#', ns("unspecified"), '").removeClass("bordersolid");', sep = ""))
  
  shinyjs::runjs(code = paste('$("#', ns(identifier), '").addClass("bordersolid");', sep = ""))
  datastore$nav_option <- navoption
}