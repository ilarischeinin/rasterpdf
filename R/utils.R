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

#' Get the PDF device function
#'
#' Determine which PDF device function to use. If a function is provided with
#' parameter `pdf_function`, use that. If not (i.e. it is `NULL`), default to
#' [grDevices::cairo_pdf()] if available, and [grDevices::pdf()] otherwise.
#'
#' @param pdf_function A PDF device function.
#' @param cairo A boolean whether to default to [grDevices::cairo_pdf()] (as
#'        opposed to [grDevices::pdf()]) if `pdf_function` is `NULL`. This
#'        parameter exists mainly to make it easier to unit test the logic.
#'
#' @noRd
get_pdf_function <- function(pdf_function = NULL,
                             cairo = capabilities("cairo")) {

  if (!is.null(pdf_function)) {
    match.fun(pdf_function)
  } else if (cairo) {
    grDevices::cairo_pdf
  } else {
    grDevices::pdf
  }
}

#' Get a specified or default value for a parameter
#'
#' A utility function to retrieve parameter value in this order: 1) a value
#' specified by the user, 2) a user-specified default value set via setting
#' `options()`, or 3) a global default value defined in code.
#'
#' @param parameter Parameter name.
#' @param value Parameter value, or `NULL` to get the default.
#'
#' @noRd
get_value_or_default <- function(parameter, value = NULL) {
  if (!is.null(value)) {
    return(value)
  }
  defaults <-
    list(
      width = 7,
      height = 7,
      units = "in",
      res = 72L
    )
  parameter <- match.arg(parameter, choices = names(defaults))
  getOption(paste0("rasterpdf.", parameter), default = defaults[[parameter]])
}

#' Determine if a function has a filename paramete
#'
#' While other device functions (including grDevices::cairo_pdf()) generally
#' have a "filename" parameter, grDevices::pdf() has "file". So, this utility
#' function detects if a function has a parameter called "filename".
#' @param pdf_function A (device) function.
#'
#' @noRd
has_filename_parameter <- function(pdf_function) {
  "filename" %in% methods::formalArgs(pdf_function)
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
