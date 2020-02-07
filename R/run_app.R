#' shinyapp "pm10 comparing"
#'
#' The function does not require an input variable. It depends on the input dataset
#'
#' @return Runs the shiny app containing an interactive analysis on the data contained in the input database.
#'
#' @export
comparing_pm10 <- function(){

  shiny::runApp(system.file("pm10", package = "pm10comparing"))

}
