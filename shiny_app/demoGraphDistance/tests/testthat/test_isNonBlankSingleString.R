context("Util functions blank string")
library(demoGraphDistance)

test_that("isNonBlankSingleString false for Non character values", {
  expect_equal(isNonBlankSingleString(NA), FALSE)
  expect_equal(isNonBlankSingleString(NULL), FALSE)
  expect_equal(isNonBlankSingleString(1), FALSE)
  expect_equal(isNonBlankSingleString(""), FALSE)
  expect_equal(isNonBlankSingleString(list("ab")), FALSE)

})

test_that("isNonBlankSingleString false for character arrays length > 1", {
  expect_equal(isNonBlankSingleString(c("","a")), FALSE)
  expect_equal(isNonBlankSingleString(c("ab","a")), FALSE)
})

test_that("isNonBlankSingleString true for single strings", {
  expect_equal(isNonBlankSingleString("a"), TRUE)
  expect_equal(isNonBlankSingleString("ab"), TRUE)
  expect_equal(isNonBlankSingleString("ab v"), TRUE)
  expect_equal(isNonBlankSingleString("ab \nv"), TRUE)
})