raster_pdf_device_closure <- function() {
  raster_pdf_devices <- list()

  function(which = NULL, device = NULL) {
    if (!is.null(which)) {
      stopifnot(is.numeric(which))
      which <- as.integer(which)
      if (which <= length(raster_pdf_devices)) {
        return(raster_pdf_devices[[which]])
      } else {
        return(NULL)
      }
    } else {
      raster_pdf_devices[[grDevices::dev.cur()]] <<- device
      return(invisible())
    }
  }
}

raster_pdf_device <- raster_pdf_device_closure()
