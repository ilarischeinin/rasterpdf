#' Convert to inches
#'
#' Converts from other units (cm, mm, or px) to inches.
#'
#' @param x The value to convert.
#' @inheritParams raster_pdf
#'
#' @noRd
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

#' Get or set an active raster pdf graphics device
#'
#' This function is defined with a closure so that it remembers its state
#' across function calls. When a raster pdf graphics device is opened with
#' [raster_pdf()], this function is called with the `device` parameter, which
#' contains the pieces of information that need to be stored: the filename,
#' width, and height of the resulting PDF, and the file name pattern of the
#' intermediate PNG files.
#' 
#' @param device A named list with components `filename`, `width`, `height`,
#'        and `pngs`.
#' @inheritParams dev.off
#'
#' @noRd
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
