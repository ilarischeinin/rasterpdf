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
dev.off <- function(which = grDevices::dev.cur()) {
  device <- raster_pdf_device(which = which)
  if (is.null(device)) {
    return(grDevices::dev.off(which = which))
  }
  raster_pdf_device(device = NULL)

  grDevices::dev.off(which = which)
  grDevices::pdf(
    file = device$filename,
    width = device$width,
    height = device$height
  )
  old_par <- graphics::par(mai = c(0, 0, 0, 0))

  png_file_regexp <-
    sub(pattern = "%05i", replacement = "[0-9]{5,}", x = device$pngs)

  png_files <-
    list.files(
      path = dirname(png_file_regexp),
      pattern = basename(png_file_regexp),
      full.names = TRUE
    )

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

  graphics::par(old_par)

  lapply(png_files, unlink)

  grDevices::dev.off(which = grDevices::dev.cur())
}
