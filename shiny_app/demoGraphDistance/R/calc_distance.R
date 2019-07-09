

#' Calculate distance between two u nodes on a network of u and p nodes
#' More detail in https://github.com/johndrummond/demo_shiny_graph_distance
#'
#' @param u1_node starting node
#' @param u2_node ending node
#' @param graph_storage object containing or wrapping graph data
#'
#' @return integer for the distance -1 if identical, 0 if no path, else 
#' the number of p nodes between U1 and U2 on shortest path
#' @export
#'
#' @examples
#' get_p_distance("U1","U1",local_graph$load_from_string(src1))
get_p_distance <- function(u1_node, u2_node, graph_storage){
  if(! isNonBlankSingleString(u1_node)) {flog.error("u1_node in get_p_distance function is invalid, should be a string")}
  if(! isNonBlankSingleString(u2_node)) {flog.error("u2_node in get_p_distance function is invalid, should be a string")}

  if(u1_node == u2_node){return(-1)} #distance pre defined as -1 if starting nodes the same
  #distance pre defined as 0 if eother starting node not in the network
  if(!(graph_storage$has_u_node(u1_node) && graph_storage$has_u_node(u2_node))){
    return(0)
  }

  #initialise
  u1_frontier <-  hashmap::hashmap(character(0),logical(0))
  p2_frontier <-  hashmap::hashmap(character(0),logical(0))
  p1_frontier <-  hashmap::hashmap(character(0),logical(0))
  u2_frontier <-  hashmap::hashmap(character(0),logical(0))
  expansion_count <- 0
  u1_frontier[[u1_node]] <- TRUE
  u2_frontier[[u2_node]] <- TRUE
  calculation_finished <- FALSE

  while (! calculation_finished) {

    #expand and check on subnetwork starting on U1
    expansion_result <- expand_and_check_subnetwork(u1_frontier, p1_frontier, u2_frontier, graph_storage)
    if (!expansion_result[[3]]) {return(0)} #no shortest path as expansion failed
    expansion_count <- expansion_count + 1
    if (expansion_result[[4]]) {return(expansion_count)} #found shortest path
    u1_frontier <- expansion_result[[1]]
    p1_frontier <- expansion_result[[2]]

    #expand and check on subnetwork starting on U2
    expansion_result <- expand_and_check_subnetwork(u2_frontier, p2_frontier, u1_frontier, graph_storage)
    if (!expansion_result[[3]]) {return(0)} #no shortest path as expansion failed
    expansion_count <- expansion_count + 1
    if (expansion_result[[4]]) {return(expansion_count)} #found shortest path
    u2_frontier <- expansion_result[[1]]
    p2_frontier <- expansion_result[[2]]
  }
}

#' Expand one subnetwork checking if possible and if it now touches the other
#'
#' @param u_frontier subnetwork frontier of u nodes
#' @param p_frontier subnetwork last frontier of p nodes
#' @param check_u_frontier u node frontier of other subnetwork to check against
#' @param graph_storage objets the graph data
#'
#' @return a list containing(
#'    a hashmap with the next_u_frontier,
#'    a hashmap with the next_p_frontier
#'    a boolean TRUE if able to expand (FALSE if not and thus no connecting path
#'    a boolean TRUE if path found FALSE if not and thus further work needed
#' returning immediately if the shortest path found or no new further nodes for a subnetwork
#' @export
#'
#' @examples
#' src4_res <- expand_and_check_subnetwork(
#'    hashmap::hashmap(c("U1"),c(TRUE)),
#'    hashmap::hashmap(character(0),logical(0)),
#'    hashmap::hashmap(c("U3"),c(TRUE)),
#'    local_graph$load_from_string(src4)
#' )
expand_and_check_subnetwork <- function(u_frontier, p_frontier, check_u_frontier, graph_storage){
  next_u_frontier <- hashmap::hashmap(character(0),logical(0))
  next_p_frontier <- hashmap::hashmap(character(0),logical(0))

  # expand from u nodes to new neighbouring p nodes
  for(u_node in u_frontier$keys()) {
    found_nodes <- graph_storage$get_p_nodes(u_node)
    for (p_node in found_nodes) {
      if (! p_frontier$has_key(p_node)){next_p_frontier[[p_node]] <- TRUE}
    }
    # check if failed to expand
  }
  if (next_p_frontier$empty()) {return(list(next_u_frontier,next_p_frontier,FALSE,FALSE))}


  # expand from p nodes to new neighbouring u nodes and check for shortest path
  for(p_node in next_p_frontier$keys()) {
    found_nodes <- graph_storage$get_u_nodes(p_node)
    for (u_node in found_nodes) {
      if (! u_frontier$has_key(u_node)){
        if (check_u_frontier$has_key(u_node)){  #sub networks joined
          return(list(next_u_frontier,next_p_frontier,TRUE,TRUE))
        }
        next_u_frontier[[u_node]] <- TRUE
      }
    }
  }
  # check if failed to expand
  if (next_u_frontier$empty()) {
    return(list(next_u_frontier,next_p_frontier,FALSE,FALSE))
  } else {
    return(list(next_u_frontier,next_p_frontier, TRUE, FALSE))
  }

}
