convert_to_inches <- function(x, units, res) {
  if (units == "in") {
    x
  } else if (units == "cm") {
    x / 2.54
  } else if (units == "mm") {
    x / 25.4
  } else if (units == "px") {
    x / res
  } else {
    NA_real_
  }
}

raster_pdf_device_closure <- function() {
  # covr doesn't seem to detect the next two lines should in reality be covered
  # by the unit tests. Maybe it's confused by the use of a closure?
  # nocov start
  raster_pdf_devices <- list()

  function(which = NULL, device = NULL) {
    # nocov end
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
