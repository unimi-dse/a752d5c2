#' shinyapp "pm10 comparing"
#'
#' Descritption
#'
#' @return shiny app
#' @export
#'
comparing_pm10 <- function(){

  shiny::runApp(system.file("pm10", package = "pm10comparing"))

}
