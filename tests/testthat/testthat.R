library(testthat)
library(dagitty)
library(ggdag)



# https://donskerclass.github.io/EconometricsII/StructuralModels.html
# manually set position of nodes
coords <- list(
  x = c(x1 = 0, x2 = 1, x3 = 2, x4 = 3, x5 = 4, x6 = 5, Attr1 = 1.5, Attr2 = 4),
  y = c(x1 = 0, x2 = 0, x3 = 0, x4 = 0, x5 = 0, x6 = 0, Attr1 = 0.8, Attr2 = 0.8)
)
dag.dcm  <- dagify(
     x1 ~ Attr1 + Attr2,
     x2 ~ Attr1 + Attr2,
     x3 ~ Attr1,
     x4 ~ Attr2 + Attr1,
     x5 ~ Attr2,
     x6 ~ Attr2,
     labels = c(Attr1 = "Multiplication", Attr2 = "Minus"),
     coords = coords
     ) %>%  tidy_dagitty()

# dag.dcm <- node_parents(dag.dcm, "x1")
dag.dcm %>%
   control_for(paste0("x", 1:6)) %>%
   ggdag_adjust(stylized = F, shadow = TRUE, text = T,use_labels = "label") +
   theme_dag(base_size = 14) +
   theme(legend.position = "none", strip.text = element_blank()) +
   # set node aesthetics
   scale_color_manual(values = c("#8F8F8F", "#0072B2"), na.value = "grey80") +
   # set arrow aesthetics
   ggraph::scale_edge_color_manual(values = c("#8F8F8F", "#0072B2"), na.value = "grey80")


dtmrSyntax = "

I1 ~ RU
I2 ~ APP
I3 ~ PI
I4 ~ RU
I5 ~ RU
I6 ~ PI
I7 ~ RU
I8a ~ APP
I8b ~ APP
I8c ~ APP
I9 ~ RU
I10a ~ MC
I10b ~ RU + MC + RU:MC # Interaction effect between RU and MC
I10c ~ RU + MC + RU:MC
I11 ~ RU
I12 ~ RU
I13 ~ PI + MC
I14 ~ RU:MC
I15a ~ PI + MC
I15b ~ PI
I15c ~ PI
I16 ~ RU
I17 ~ PI + RU:PI
I18 ~ RU + PI
I21 ~ RU
I22 ~ RU + PI

# Structural equation model (Bayesian Network)
RU ~ 1 # reference unit
PI ~ RU
APP ~ RU + PI + RU:PI
MC ~ RU + PI + APP + RU:PI + RU:APP + PI:APP + RU:PI:APP
"
