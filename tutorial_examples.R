StatChull <- ggproto("StatChull", Stat,
                     compute_group = function(data, scales) {
                       data[chull(data$x, data$y), , drop = FALSE]
                     },
                     
                     required_aes = c("x", "y")
)


GeomPolygonHollow <- ggproto("GeomPolygonHollow", GeomPolygon,
                             default_aes = aes(colour = "black", fill = NA, size = 0.5, linetype = 1, 
                                               alpha = NA)
)

geom_chull <- function(mapping = NULL, data = NULL, 
                       position = "identity", na.rm = FALSE, show.legend = NA, 
                       inherit.aes = TRUE, ...) {
  layer(
    stat = StatChull, geom = GeomPolygonHollow, data = data, mapping = mapping,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_chull()


ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  layer(
    stat = StatChull, geom = GeomPolygonHollow, data = NULL, mapping = NULL,
    position = "identity", show.legend = NA, inherit.aes = TRUE,
    params = list(na.rm = TRUE)
  )
