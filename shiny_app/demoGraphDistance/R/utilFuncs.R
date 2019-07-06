isNonBlankSingleString <- function(x) {
  if (is.character(x) && length(x) == 1 && nzchar(x)>0 ) {
    TRUE
  } else {
    FALSE
  }
}
