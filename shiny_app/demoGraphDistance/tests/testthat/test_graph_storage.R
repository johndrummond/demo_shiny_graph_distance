context("Test R6 class used for sample local storage of a graph")
library(demoGraphDistance)


local_graph <- UPGraphStorage$new()
local_graph$initialize()

src1 <- "U1:P0,P1\nU2:P1,P2\n"
src2 <- "\nU1:P0,P1\nU2:P1,P2,"
src3 <- "U1,:P0,P1,P:2\nU2:,P1,P2,"
src4 <-  "U1"
src5 <-  ""
src6 <-  "\n\n"
src7 <- "U1\nU2:P1,P2\n"



test_that("loading and returning different string types works", {
  expect_equal(local_graph$load_from_string(src1)$get_as_string(), "U2:P1,P2\nU1:P0,P1")
  expect_equal(local_graph$load_from_string(src2)$get_as_string(), "U2:P1,P2\nU1:P0,P1")
  expect_equal(local_graph$load_from_string(src3)$get_as_string(), "U2:P1,P2\nU1,:P0,P1,P:2")
  expect_equal(local_graph$load_from_string(src4)$get_as_string(), "U1:")
  expect_equal(local_graph$load_from_string(src5)$get_as_string(), "")
  expect_equal(local_graph$load_from_string(src6)$get_as_string(), "")
  expect_equal(local_graph$load_from_string(src7)$get_as_string(), "U2:P1,P2\nU1:")
})

test_that("getting linked u and p nodes works", {
  expect_equal(all(local_graph$load_from_string(src2)$get_p_nodes("U2") == c("P1","P2")), TRUE)
  expect_equal(all(local_graph$load_from_string(src2)$get_p_nodes("U1") == c("P0","P1")), TRUE)
  expect_equal(all(local_graph$load_from_string(src2)$get_u_nodes("P1") == c("U1","U2")), TRUE)
  expect_equal(local_graph$load_from_string(src2)$get_u_nodes("P0"), "U1")
  expect_equal(is.na(local_graph$load_from_string(src2)$get_u_nodes("P10")),TRUE)
  expect_equal(is.na(local_graph$load_from_string(src2)$get_p_nodes("U10")),TRUE)
})


test_that("checking existance of U and P nodes", {
  expect_equal(local_graph$load_from_string(src2)$has_u_node("P10"),FALSE)
  expect_equal(local_graph$load_from_string(src2)$has_p_node("U10"),FALSE)
  expect_equal(local_graph$load_from_string(src2)$has_u_node("U1"),TRUE)
  expect_equal(local_graph$load_from_string(src2)$has_p_node("P1"),TRUE)
})
test_that("loading a chain of nodes works", {
  expect_equal(local_graph$load_from_chain(3)$get_as_string(),"U2:P2,P1\nU3:P3,P2\nU1:P1,P0")
})
