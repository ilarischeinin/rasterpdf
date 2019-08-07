#' raster_pdf
#'
#' lorem ipsum
#'
#' @param filename filename
#' @param width width
#' @param height height
#' @param units units
#' @param res res
#' @param ... ...
#'
#' @export
raster_pdf <- function(filename = "Rplots.pdf",
                       width = 7,
                       height = 7,
                       units = c("in", "cm", "mm", "px"),
                       res = 72L,
                       ...) {

  units <- match.arg(units)

  if (units == "cm") {
    width <- width / 2.54
    height <- height / 2.54
  } else if (units == "mm") {
    width <- width / 25.4
    height <- height / 25.4
  } else if (units == "px") {
    width <- width / res
    height <- height / res
  }

  pngs <- tempfile(pattern = "raster_pdf-", fileext = "-%05i.png")

  device <-
    list(
      filename = filename,
      pngs = pngs,
      width = width,
      height = height
    )

  grDevices::png(
    filename = pngs,
    width = width,
    height = height,
    units = "in",
    res = res,
    ...
  )

  raster_pdf_device(device = device)
}
