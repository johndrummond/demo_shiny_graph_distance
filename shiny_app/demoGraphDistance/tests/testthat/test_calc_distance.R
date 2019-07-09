context("Test functions used for shortest distance calculation")
library(demoGraphDistance)

local_graph <- UPGraphStorage$new()


src1 <- "U1:P0,P1\nU2:P1,P2\n"
src2 <- "U1:P0,P1\nU2:P1,P2\nU3:P2"
src3 <- "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3"
src4 <- "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3\nU4:P4,P5"

test_that("test distance calculations for unknown or duplicate nodes", {
  #unknown nodes or same node
  expect_equal(get_p_distance("U1","U1",local_graph$load_from_string(src1)),-1)
  expect_equal(get_p_distance("U10","U10",local_graph$load_from_string(src1)),-1)
  expect_equal(get_p_distance("U10","U2",local_graph$load_from_string(src1)),0)
  expect_equal(get_p_distance("U10","U20",local_graph$load_from_string(src1)),0)
  expect_equal(get_p_distance("U1","U20",local_graph$load_from_string(src1)),0)
})

test_that("test distance calculations for known dissimilar nodes", {
  expect_equal(get_p_distance("U1","U2",local_graph$load_from_string(src1)),1)
  expect_equal(get_p_distance("U1","U3",local_graph$load_from_string(src2)),2)
  expect_equal(get_p_distance("U1","U3",local_graph$load_from_string(src3)),1)
  expect_equal(get_p_distance("U1","U4",local_graph$load_from_string(src4)),0)
})

