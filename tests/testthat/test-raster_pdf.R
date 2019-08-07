test_that("raster_pdf works", {
  tmp <- tempfile(fileext = ".pdf")
  raster_pdf(tmp)
  plot(iris)
  dev.off()

  expect_true(file.exists(tmp))
  expect_gt(file.info(tmp)$size, 5 * 1024)

  if (file.exists(tmp)) unlink(tmp)
})
