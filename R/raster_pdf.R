#' Raster PDF graphics device (with PNG pages)
#'
#' Open a graphics device for raster PDF files. Internally, a PNG device is
#' used for the individual pages, which are then combined into one PDF file.
#'
#' The ability to plot raster graphics in PDF files can be useful when one needs
#' multipage documents, but the plots contain so many individual elements that
#' use of vector graphics (with [grDevices::pdf()]) results in inconveniently
#' large file sizes
#'
#' Internally, the function plots each individual page in a PNG file, which are
#' then combined into one PDF file when [dev.off()] is called. By default, the
#' PNGs are generated with [grDevices::png()], but another device function can
#' also be specified. The PDF is by default generated with
#' [grDevices::cairo_pdf()] if it is available, and
#' [grDevices::pdf()] otherwise. Again, it is possible to specify another PDF
#' device function.
#'
#' `agg_pdf(...)` is shorthand for
#' `raster_pdf(..., png_function = ragg::agg_png)`.
#'
#' @param filename A character string of the output file name.
#' @param width Page width. If `NULL`, use value of
#'        `getOption("rasterpdf.width")` if set, and default to `7` otherwise.
#' @param height Page height. If `NULL`, use value of
#'        `getOption("rasterpdf.height")` if set, and default to `7` otherwise.
#' @param units The units in which `height` and `weight` are given. Can be
#'        `"in"` (inches), `"cm"`, `"mm"`, or `"px"` (pixels). If `NULL`, use
#'        value of `getOption("rasterpdf.units")` if set, and default to "in"
#'      ` otherwise.
#' @param res Resolution in ppi. If `NULL`, use value of
#'        `getOption("rasterpdf.res")` if set, and default to `72L` otherwise.
#' @param png_function A PNG device function. If `NULL`, use [grDevices::png()].
#' @param pdf_function A PDF device function. If `NULL`, use
#'        [grDevices::cairo_pdf()] if it is available, and [grDevices::png()]
#'        otherwise.
#' @param ... Further arguments passed through to the PNG device function
#'        specified in `png_function`.
#'
#' @seealso [grDevices::pdf()], [grDevices::cairo_pdf()],
#'          [grDevices::png()], [ragg::agg_png()]
#'
#' @examples
#' raster_pdf(tempfile(fileext = ".pdf"))
#' plot(iris)
#' dev.off()
#'
#' @export
raster_pdf <- function(filename = "Rplots.pdf",
                       width = NULL,
                       height = NULL,
                       units = NULL,
                       res = NULL,
                       png_function = NULL,
                       pdf_function = NULL,
                       ...) {

  # Default values for the parameters.
  width <- get_value_or_default("width", width)
  height <- get_value_or_default("height", height)
  units <- get_value_or_default("units", units)
  res <- get_value_or_default("res", res)

  # As the PDF device grDevices::pdf() only takes width and height in inches,
  # convert from other units as needed so that we can provide more flexibility.
  units <- match.arg(units, choices = c("in", "cm", "mm", "px"))
  width <- convert_to_inches(width, units = units, res = res)
  height <- convert_to_inches(height, units = units, res = res)

  # Define a name pattern for the intermediate PNG files.
  pngs <- tempfile(pattern = "raster_pdf-", fileext = "-%05i.png")

  # Open a PNG graphics device to plot the individual pages.
  if (is.null(png_function)) {
    png_function <- grDevices::png
  }
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
      height = height,
      pdf_function = pdf_function
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
      "Package \"ragg\" not available; falling back to grDevices::png().",
      call. = FALSE
    )
    raster_pdf(...)
  }
}
