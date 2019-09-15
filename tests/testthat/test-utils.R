test_that("convert_to_inches works", {
  expect_equal(convert_to_inches(1, units = "in"), 1)
  expect_equal(convert_to_inches(2.54, units = "cm"), 1)
  expect_equal(convert_to_inches(25.4, units = "mm"), 1)
  expect_equal(convert_to_inches(72, units = "px", res = 72), 1)
})

test_that("get_pdf_function works", {
  expect_identical(
    get_pdf_function("cairo_pdf", cairo = TRUE),
    match.fun("cairo_pdf")
  )
  expect_identical(
    get_pdf_function("cairo_pdf", cairo = FALSE),
    match.fun("cairo_pdf")
  )
  expect_identical(
    get_pdf_function("pdf", cairo = TRUE),
    match.fun("pdf")
  )
  expect_identical(
    get_pdf_function("pdf", cairo = FALSE),
    match.fun("pdf")
  )
  expect_identical(
    get_pdf_function(cairo = TRUE),
    match.fun("cairo_pdf")
  )
  expect_identical(
    get_pdf_function(cairo = FALSE),
    match.fun("pdf")
  )
})

test_that("get_value_or_default", {
  expect_equal(
    get_value_or_default("foo", "bar"),
    "bar"
  )
  expect_equal(
    get_value_or_default("width"),
    getOption("rasterpdf.width", default = 7)
  )
  expect_equal(
    get_value_or_default("height"),
    getOption("rasterpdf.height", default = 7)
  )
  expect_equal(
    get_value_or_default("units"),
    getOption("rasterpdf.units", default = "in")
  )
  expect_equal(
    get_value_or_default("res"),
    getOption("rasterpdf.res", default = 72L)
  )
})

test_that("has_filename_parameter works", {
  expect_equal(has_filename_parameter(function(filename) "foobar"), TRUE)
  expect_equal(has_filename_parameter(function(file) "foobar"), FALSE)
})
