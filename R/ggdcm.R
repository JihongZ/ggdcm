#' Quickly plot a DCM in ggplot2
#'
#' `ggdcm()` is a wrapper to quickly plot DAGs.
#'
#' @param .tdy_dag input graph, an object of class `tidy_dagitty` or
#'   `dagitty`
#' @param ... additional arguments passed to `tidy_dagitty()`
#' @param int.vars variables names for indicators
#' @param lat.vars variables names for latent class or attributes
#' @param use_labels a string. Variable to use for `geom_dag_repel_label()`.
#'   Default is `NULL`.
#' @import tidyverse
#' @return a `ggplot`
#' @export
#'
#' @examples
#'
#' library(tidyverse)
#' dag.dcm  <- dagify(
#'   x1 ~ Attr1 + Attr2,
#'   x2 ~ Attr1,
#'   x3 ~ Attr1 + Attr2,
#'   x4 ~ Attr2 + Attr1,
#'   x5 ~ Attr2,
#'   x6 ~ Attr2 + Attr1,
#'   x7 ~ Attr2,
#'   labels = c(Attr1 = "Multiplication", Attr2 = "Minus")
#' )
#'
#' ggdcm(.tdy_dag = dag.dcm, use_labels = "label", int.vars = paste0("x", 1:7))
#' ggdcm(.tdy_dag = dag.dcm, use_labels = "label")
#' ggdcm(.tdy_dag = dag.dcm, int.vars = paste0("x", 1:6), lat.vars = paste0("Attr", 1:2), use_labels = "label")
#'
#'
#'

ggdcm <- function(.tdy_dag, int.vars = NULL, lat.vars = NULL,
                  use_labels = FALSE,...) {

  if (is.null(int.vars)) {
    int.vars = tidy_dagitty(.tdy_dag) %>% as_tibble() %>% filter(is.na(direction)) %>% pull(name) %>% unique()
    message("Indicator Variables' Names Automate Generated!")
  }

  if (is.null(lat.vars)){
    lat.vars = tidy_dagitty(.tdy_dag) %>% as_tibble() %>% filter(direction == "->") %>% pull(name) %>% unique()
    message("Latent Variables' Names Automate Generated!")
  }
  # initialize the coordinates
  int.vars.x = 1:length(int.vars)
  lat.vars.x = seq(from = 1.2, to = length(int.vars)-1, length.out = length(lat.vars))
  names(int.vars.x) = int.vars
  names(lat.vars.x) = lat.vars
  int.vars.y = rep(0, length(int.vars))
  lat.vars.y = rep(1, length(lat.vars))
  names(int.vars.y) = int.vars
  names(lat.vars.y) = lat.vars

  # create coordinates for indicators and latent
  coords <- list(
    x = c(int.vars.x, lat.vars.x),
    y = c(int.vars.y, lat.vars.y)
  )


  coordinates(.tdy_dag) <- coords2list(coords2df(coords))

  .tdy_dag %>%
    control_for(int.vars) %>%
    ggdag_adjust(stylized = F, shadow = TRUE, text = T) +
    theme_dag(base_size = 14) +
    theme(legend.position = "none", strip.text = element_blank()) +
    # set node aesthetics
    scale_color_manual(values = c("#8F8F8F", "#0072B2"), na.value = "grey80") +
    # set arrow aesthetics
    ggraph::scale_edge_color_manual(values = c("#8F8F8F", "#0072B2"), na.value = "grey80")

}


