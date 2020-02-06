#' shinyapp "pm10 comparing"
#'
#' Descritption
#'
#' @return shiny app
#' @export
#'
#' @examples
#' \dontrun{
#' comparing_pm10()
#' }
comparing_pm10<- function(){

  shiny::runApp(system.file("pm10", package = "pm10"))

}
