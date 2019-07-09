
#' This is local storage for a graph with two types of nodes

# type of graph for creating sample graphs
GRAPHTYPES <- c("manyP2U_manyU2P", "manyP2U_fewU2P", "fewP2U_manyU2P", "fewP2U_fewU2P", "chain_of_u_nodes")
UNIT_SEP   <- "\u001F"

UPGraphStorage <- R6::R6Class("UPGraphStorage",
  #lock_objects = FALSE,
  public = list(
    p_nodes_per_u_node = NULL,
    u_nodes_per_p_node = NULL,
    print = function(){
      print(self$p_nodes_per_u_node)
      invisible(self)
    },
    get_p_nodes = function(u_node){
      unlist(stringi::stri_split_fixed(self$p_nodes_per_u_node[[u_node]],"\u001F",omit_empty = TRUE ))
    },
    get_u_nodes = function(p_node){
      unlist(stringi::stri_split_fixed(self$u_nodes_per_p_node[[p_node]],"\u001F",omit_empty = TRUE ))
    },
    has_u_node = function(u_node){self$p_nodes_per_u_node$has_key(u_node)},
    has_p_node = function(p_node){self$u_nodes_per_p_node$has_key(p_node)},
    initialize = function() {
      self$u_nodes_per_p_node <- hashmap::hashmap(character(0),character(0))
      self$p_nodes_per_u_node <- hashmap::hashmap(character(0),character(0))
      invisible(self)
    },
    finalize = function(){
      invisible(self)
    },
    get_as_string = function(){
      if (self$p_nodes_per_u_node$size() > 0) {
        str_c(
          map2(self$p_nodes_per_u_node$keys(),
              self$p_nodes_per_u_node$values(),
              ~str_c(.x,":",str_replace_all(.y,"\u001F", ","))),
          collapse = "\n"
        )
      } else {return("")}
    },
    load_from_string = function(src_data) {
      # u node followed by : followed by comma delimited p nodes
      # parse and handle beginning and trailing commas
      records <- stringi::stri_split_lines(src_data, omit_empty = TRUE)[[1]]
      if (length(records) == 0 ) {
        flog.warn("data loading into graph has no valid records")
        return(self$initialize())
      }
      fields      <- stringr::str_split_fixed(records, ":",2)
      values4keys <- stringr::str_replace_all(fields[,2], ",,",",")
      values4keys <- stringr::str_remove(values4keys, "^,")
      values4keys <- stringr::str_remove(values4keys, ",$")
      values4keys <- stringr::str_split(values4keys, ",")

      # main hash
      self$p_nodes_per_u_node <- hashmap::hashmap(unlist(fields[,1]),
                            unlist(map(values4keys,~str_c(.x,collapse="\u001F"))))

      # create reverse lookup
      UNodesForP <- new.env()
      walk2(fields[,1], values4keys,
            ~{for (p_node in .y) {
                if (nzchar(p_node)) {
                  UNodesForP[[p_node]] <- c(UNodesForP[[p_node]],.x)
                }
              }
            }
      )
      # and create as hashmap::hashmap
      if (length(UNodesForP) > 0 ) {
        self$u_nodes_per_p_node <- hashmap::hashmap(
          names(UNodesForP),
          unlist(map(names(UNodesForP), ~str_c(UNodesForP[[.x]],collapse="\u001F")))
        )
      } else {self$u_nodes_per_p_node <- hashmap::hashmap(character(0),character(0))}

      invisible(self)
    },
    load_from_type = function(graphtype = "chain_of_u_nodes", u_node_count = 50) {
      if(! is.integer(u_node_count) || u_node_count < 3) {flog.error("u_node_count must be an integer > 2")}
      if(! graphtype %in% GRAPHTYPES) {flog.error(paste("graphtype must be one of", GRAPHTYPES))}

      invisible(self)
    }


  )
)
