test_that("regular pdf works", {
  vector_tmp <- tempfile(pattern = "vector_pdf-", fileext = ".pdf")
  pdf(vector_tmp)
  plot(iris)
  dev.off()

  expect_true(file.exists(vector_tmp))
  expect_gt(file.info(vector_tmp)$size, 5 * 1024)

  if (file.exists(vector_tmp)) unlink(vector_tmp)
})

test_that("raster_pdf works", {
  raster_tmp <- tempfile(pattern = "raster_pdf-", fileext = ".pdf")
  raster_pdf(raster_tmp)
  plot(iris)
  dev.off()

  expect_true(file.exists(raster_tmp))
  expect_gt(file.info(raster_tmp)$size, 5 * 1024)

  if (file.exists(raster_tmp)) unlink(raster_tmp)
})

test_that("ragg_pdf works", {
  agg_tmp <- tempfile(pattern = "raster_pdf-", fileext = ".pdf")
  if (requireNamespace("ragg", quietly = TRUE)) {
    agg_pdf(agg_tmp)
  } else {
    expect_warning(agg_pdf(agg_tmp), "not available")
  }
  plot(iris)
  dev.off()

  expect_true(file.exists(agg_tmp))
  expect_gt(file.info(agg_tmp)$size, 5 * 1024)

  if (file.exists(agg_tmp)) unlink(agg_tmp)
})
