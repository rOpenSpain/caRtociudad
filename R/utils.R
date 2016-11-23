##########################################################################
# Luz Frias, 2016-06-03
# Common util functions
##########################################################################

get_cartociudad_user_agent <- function() {
  ua <- paste0("caRtociudad/", packageVersion("caRtociudad"),
               " (https://github.com/cjgb/caRtociudad)")
  user_agent(ua)
}
