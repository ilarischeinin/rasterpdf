#' Shut down a graphics device
#'
#' Please see the manual page for [grDevices::dev.off()]. Package `rasterpdf`
#' overrides the function in order to provide functionality of [raster_pdf()],
#' but internally calls [grDevices::dev.off()].
#'
#' @param which An integer that specifies the device number. Default is the
#'        current device.
#'
#' @seealso [grDevices::dev.off()]
#'
#' @examples
#' raster_pdf(tempfile(fileext = ".pdf"))
#' plot(iris)
#' dev.off()
#'
#' @export
dev.off <- function(which = grDevices::dev.cur()) { # nolint
  # Check whether the graphics device in question is a raster PDF device.
  # As raster_pdf_device() is implemented with a closure, it is able to store
  # that state.
  device <- raster_pdf_device(which = which)
  # If it is not, no need to do anything but to call grDevices::dev.off()
  if (is.null(device)) {
    return(grDevices::dev.off(which = which))
  }
  # If it is, reset the device as we will close it.
  raster_pdf_device(device = NULL)

  # Close the intermediate PNG graphics device.
  grDevices::dev.off(which = which)
  # Determine which PDF device function to use.
  pdf_function <- get_pdf_function(device$pdf_function)
  # While other device functions (including grDevices::cairo_pdf()) generally
  # have a "filename" parameter, grDevices::pdf() has "file". So, detect if can
  #  use "filename".
  if (has_filename_parameter(pdf_function)) {
    pdf_function(
      filename = device$filename,
      width = device$width,
      height = device$height,
      onefile = TRUE
    )
  } else {
    pdf_function(
      file = device$filename,
      width = device$width,
      height = device$height,
      onefile = TRUE
    )
  }
  # Even if something goes wrong later in the function call, let's make sure
  # the newly opened graphics device does get closed.
  pdf_device <- grDevices::dev.cur()
  on.exit(grDevices::dev.off(which = pdf_device), add = TRUE)
  # Since the individual PNGs already have margins, let's not add extra ones.
  # Normally there should be an on.exit() call to undo the change to par(),
  # but since we already have an on.exit(dev.off()) above, there is no need.
  graphics::par(mai = c(0, 0, 0, 0))

  # List the individual PNG files that have been produced.
  png_file_regexp <-
    sub(pattern = "%05i", replacement = "[0-9]{5,}", x = device$pngs)
  png_files <-
    list.files(
      path = dirname(png_file_regexp),
      pattern = basename(png_file_regexp),
      full.names = TRUE
    )

  # Read all the intermediate PNG files and write them to the PDF.
  lapply(
    png_files,
    function(png_file) {
      png_plot <- png::readPNG(png_file, native = TRUE)
      graphics::plot.new()
      usr <- graphics::par("usr")
      graphics::rasterImage(
        image = png_plot,
        xleft = usr[1L],
        ybottom = usr[3L],
        xright = usr[2L],
        ytop = usr[4L],
        interpolate = FALSE
      )
    }
  )

  # Remove the intermediate PNG files.
  lapply(png_files, unlink)

  # Close the PDF graphics device. (We do already have an on.exit() call that
  # does this, but it's done here explicitly in order to be able to have the
  # the correct return value.)
  grDevices::dev.off(which = pdf_device)
}
