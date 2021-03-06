#' Render the graph as an htmlwidget
#'
#' Using a \code{causact_graph} object, render the graph in the RStudio Viewer.
#' @param graph a graph object of class \code{dgr_graph}.
#' @param shortLabel a logical value.  If set to \code{TRUE}, distribution and formula information is suppressed.  Meant for communication with non-statistical stakeholders.
#' @param wrapWidth a numeric value.  Used to restrict width of nodes.  Default is wrap text after 24 characters.
#' @param width a numeric value.  an optional parameter for specifying the width of the resulting graphic in pixels.
#' @param height a numeric value.  an optional parameter for specifying the height of the resulting graphic in pixels.
#' @param ... arguments that can be passed onto \code{Diagrammer::render_graph()}.
#' @examples
#' # Render an  empty graph
#' dag_create() %>%
#'   dag_render()
#' @importFrom dplyr select rename mutate filter left_join
#' @importFrom dplyr case_when as_tibble as_data_frame
#' @export
dag_render <- function(graph,
                       shortLabel = FALSE,
                       wrapWidth = 24,
                       width = NULL,
                       height = NULL,
                       ...) {
  graph = graph
  sLabel = shortLabel
  ww = wrapWidth

  ## code to give output even if no nodes are added
  if (nrow(graph$nodes_df) == 0) {
    graph = graph %>% dag_node("START MODELLING", label = "use dag_node()")
  }

  dot_code = graph %>%
    dag_diagrammer(shortLabel = sLabel, wrapWidth = ww) %>%
    generate_dot2()

  # Generate a `grViz` object
  grVizObject <-
    grViz2(
      diagram = dot_code,
      width = width,
      height = height)

  display <- grVizObject

  display
}

