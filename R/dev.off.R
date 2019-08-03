#' dev.off
#'
#' lorem ipsum
#'
#' @param which which
#'
#' @export
dev.off <- function(which = grDevices::dev.cur()) {
  device <- raster_pdf_device(which = which)
  if(is.null(device)) {
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
    function(.page) {
      png_plot <- png::readPNG(.page)
      graphics::plot.new()
      graphics::rasterImage(png_plot, 0, 0, 1, 1)
    }
  )

  graphics::par(old_par)

  lapply(png_files, unlink)

  grDevices::dev.off(which = grDevices::dev.cur())
}
