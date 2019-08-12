#' raster_pdf
#'
#' lorem ipsum
#'
#' @param filename filename
#' @param width width
#' @param height height
#' @param units units
#' @param res res
#' @param png_function png_function
#' @param ... ...
#'
#' @export
raster_pdf <- function(filename = "Rplots.pdf",
                       width = 7,
                       height = 7,
                       units = c("in", "cm", "mm", "px"),
                       res = 72L,
                       png_function = grDevices::png,
                       ...) {

  units <- match.arg(units)
  width <- convert_to_inches(width, units = units, res = res)
  height <- convert_to_inches(height, units = units, res = res)

  pngs <- tempfile(pattern = "raster_pdf-", fileext = "-%05i.png")

  device <-
    list(
      filename = filename,
      pngs = pngs,
      width = width,
      height = height
    )

  png_function <- match.fun(png_function)
  png_function(
    filename = pngs,
    width = width,
    height = height,
    units = "in",
    res = res,
    ...
  )

  raster_pdf_device(device = device)
}

#' @rdname raster_pdf
#' @export
agg_pdf <- function(...) {
  if (requireNamespace("ragg", quietly = TRUE)) {
    raster_pdf(..., png_function = ragg::agg_png)
  } else {
    warning(
      "Package \"ragg\" not availabe; falling back to grDevices::png().",
      call. = FALSE
    )
    raster_pdf(...)
  }
}
