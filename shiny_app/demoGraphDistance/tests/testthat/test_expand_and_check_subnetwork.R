context("Test functions used for shortest distance calculation")
library(demoGraphDistance)

local_graph <- UPGraphStorage$new()

# test expand to match
src4 <- "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3\nU4:P4,P5"
src4_res_1 <- expand_and_check_subnetwork(
   hashmap::hashmap(c("U1"),c(TRUE)),
   hashmap::hashmap(character(0),logical(0)),
   hashmap::hashmap(c("U3"),c(TRUE)),
   local_graph$load_from_string(src4)
)

test_that("Expand subnetwork to match", {
  expect_equal(src4_res_1[[1]]$keys() ,"U2")
  expect_equal(all(src4_res_1[[2]]$keys() == c("P0","P1","P3")),TRUE)
  expect_equal(src4_res_1[[3]],TRUE)
  expect_equal(src4_res_1[[4]],TRUE)
})

# test expand without matching
src4 <- "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3\nU4:P4,P5"
src4_res_2 <- expand_and_check_subnetwork(
   hashmap::hashmap(c("U1"),c(TRUE)),
   hashmap::hashmap(character(0),logical(0)),
   hashmap::hashmap(c("U4"),c(TRUE)),
   local_graph$load_from_string(src4)
)

test_that("Expand subnetwork without matching", {
  expect_equal(all(src4_res_2[[1]]$keys() == c("U2","U3")),TRUE)
  expect_equal(all(src4_res_2[[2]]$keys() == c("P0","P1","P3")),TRUE)
  expect_equal(src4_res_2[[3]],TRUE) # expanded
  expect_equal(src4_res_2[[4]],FALSE) # no match
})

# test expand fail on p expansion
src5 <- "U1:P0,P1,P3\nU2:P1\nU3:P3\nU4:P4,P5"
src4_res_2 <- expand_and_check_subnetwork(
   hashmap::hashmap(c("U2","U3"),c(TRUE,TRUE)),
   hashmap::hashmap(c("P1","P3"),c(TRUE,TRUE)),
   hashmap::hashmap(c("U4"),c(TRUE)),
   local_graph$load_from_string(src5)
)

test_that("Expand subnetwork without matching", {
  expect_equal(src4_res_2[[1]]$empty(),TRUE)
  expect_equal(src4_res_2[[1]]$empty(),TRUE)
  expect_equal(src4_res_2[[3]],FALSE) # expanded
  expect_equal(src4_res_2[[4]],FALSE) # no match
})

# test expand fail on u expansion
src4 <- "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3\nU4:P4,P5"
src4_res_2 <- expand_and_check_subnetwork(
   hashmap::hashmap(c("U2","U3"),c(TRUE,TRUE)),
   hashmap::hashmap(c("P1","P3"),c(TRUE,TRUE)),
   hashmap::hashmap(c("U4"),c(TRUE)),
   local_graph$load_from_string(src4)
)

test_that("Expand subnetwork without matching", {
  expect_equal(src4_res_2[[1]]$empty(),TRUE)
  expect_equal(src4_res_2[[2]]$keys() ,"P2")
  expect_equal(src4_res_2[[3]],FALSE) # expanded
  expect_equal(src4_res_2[[4]],FALSE) # matched
})
