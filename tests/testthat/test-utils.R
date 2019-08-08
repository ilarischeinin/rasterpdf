test_that("convert_to_inches works", {
  expect_equal(convert_to_inches(1, units = "in"), 1)
  expect_equal(convert_to_inches(2.54, units = "cm"), 1)
  expect_equal(convert_to_inches(25.4, units = "mm"), 1)
  expect_equal(convert_to_inches(72, units = "px", res = 72), 1)
})
