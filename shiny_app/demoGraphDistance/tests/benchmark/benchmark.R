library(data.table)
library(stringi)
library(stringr)
library(purrr)

library(futile.logger)
library(R6)
library(purrr)
library(hashmap)
library(here)

source(here("R/graph_storage.R"))
source(here("R/calc_distance.R"))
source(here("R/utilFuncs.R"))

local_graph <- UPGraphStorage$new()
system.time(
  local_graph$load_from_chain(10000000)
)
system.time({
  distance <- get_p_distance("U1","U10000",local_graph)
  print(distance)
})
#[1] 9999
#user  system elapsed
#13.73    0.11   13.85
