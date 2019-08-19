#' Raster PDF graphics device (with PNG pages)
#'
#' Open a graphics device for raster PDF files. Internally, a PNG device is
#' used for the individual pages, which are then combined into one PDF file.
#'
#' The ability to plot raster graphics inside PDF files is useful when one needs
#' multipage documents, but the plots contain so many individual elements that
#' use of vector graphics (as grDevices::pdf() does) results in inconveniently
#' large file sizes. Internally, rasterpdf plots each individual page as a PNG,
#' and then combines them in one PDF file.
#'
#' `agg_pdf(...)` is shorthand for
#' `raster_pdf(..., png_function = ragg::agg_png)`.
#'
#' @param filename A character string of the output file name.
#' @param width Page width.
#' @param height Page height.
#' @param units The units in which `height` and `weight` are given. Can be
#'         `in` (inches, the default), `cm`, `mm`, or `px` (pixels).
#' @param res The resolution in ppi.
#' @param png_function A PNG device function. Default is [grDevices::png()].
#' @param ... Further arguments passed through to the PNG device function
#' specified in `png_function`.
#'
#' @seealso [grDevices::pdf()], [grDevices::png()], [ragg::agg_png()]
#'
#' @examples
#' raster_pdf(tempfile(fileext = ".pdf"))
#' plot(iris)
#' dev.off()
#'
#' @export
raster_pdf <- function(filename = "Rplots.pdf",
                       width = 7,
                       height = 7,
                       units = c("in", "cm", "mm", "px"),
                       res = 72L,
                       png_function = grDevices::png,
                       ...) {

  # As the PDF device grDevices::pdf() only takes width and height in inches,
  # convert from other units as needed so that we can provide more flexibility.
  units <- match.arg(units)
  width <- convert_to_inches(width, units = units, res = res)
  height <- convert_to_inches(height, units = units, res = res)

  # Define a name pattern for the intermediate PNG files.
  pngs <- tempfile(pattern = "raster_pdf-", fileext = "-%05i.png")

  # Open a PNG graphics device to plot the individual pages.
  png_function <- match.fun(png_function)
  png_function(
    filename = pngs,
    width = width,
    height = height,
    units = "in",
    res = res,
    ...
  )

  # Collect the pieces of information that need to be stored for a future call
  # to grDevices::pdf(), once the user calls dev.off(). As raster_pdf_device()
  # is implemented with a closure, it is able to store them.
  device <-
    list(
      filename = filename,
      pngs = pngs,
      width = width,
      height = height
    )
  raster_pdf_device(device = device)
}

#' @rdname raster_pdf
#' @export
agg_pdf <- function(...) {
  if (requireNamespace("ragg", quietly = TRUE)) {
    raster_pdf(..., png_function = ragg::agg_png)
  } else {
    # This branch is not reached by unit tests, so we'll ignore it from code
    # coverage calculations.
    # nocov start
    warning(
      "Package \"ragg\" not availabe; falling back to grDevices::png().",
      call. = FALSE
    )
    raster_pdf(...)
    # nocov end
  }
}
