library(testthat)
library(dplyr)
test_that("conus_weather joins with census.data", {
  expect_equal(nrow(anti_join(census.data, conus_weather, by = "fips")), 0)
  expect_equal(nrow(anti_join(census.data, conus_weather, by = "location")), 0)
})
