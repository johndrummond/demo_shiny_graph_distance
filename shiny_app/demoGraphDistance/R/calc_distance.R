

get_p_distance <- function(u1_node, u2_node, graph_storage){
  if(! isNonBlankSingleString(u1_node)) {flog.error("u1_node in get_p_distance function is invalid")}
  if(! isNonBlankSingleString(u2_node)) {flog.error("u2_node in get_p_distance function is invalid")}
  if(u1_node == u2_node){return(-1)}

}

expand_and_check_subnetwork <- function(u_frontier, p_frontier, check_u_frontier, graph_storage){


  return(new_u_frontier, new_p_frontier)
}