raster_pdf_device_closure <- function() {
  storage <- list()
  
  function(which = NULL, device = NULL) {
    if (!is.null(which)) {
      stopifnot(is.numeric(which))
      which <- as.integer(which)
      if (which <= length(storage)) {
        return(storage[[which]])
      } else {
        return(NULL)
      }
    } else {
      storage[[grDevices::dev.cur()]] <<- device
      return(invisible())
    }
  }
}

raster_pdf_device <- raster_pdf_device_closure()
