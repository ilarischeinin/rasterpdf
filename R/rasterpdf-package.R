#' rasterpdf: Plot Raster Graphics in PDFs.
#'
#' rasterpdf is an R package to plot raster graphics in PDF files. This can be
#' useful when one needs multipage documents, but the plots contain so many
#' individual elements that use of vector graphics (with [grDevices::pdf()])
#' results in inconveniently large file sizes. Internally, rasterpdf plots each
#' individual page as a PNG, and then combines them in one PDF file.
#'
#' @section Functions:
#'
#' [raster_pdf()] Opens a raster graphics PDF device.
#'
#' [dev.off()] Closes a graphics device.
#'
#' @docType package
#' @name rasterpdf
NULL
