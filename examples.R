library(ggplot2)

#' Display square for a given centroid and edge measure.
#'
#'Square geom is displayed on the graph
#'
#' \code{geom_draw_sqr} uses the center of the tile and its size (\code{x},
#' \code{y}, \code{edge}). 
#' 
#' @param mapping Set of aesthetic mappings created
#'  by aes or aes_. If specified and inherit.aes = TRUE
#'  (the default), is combined with the default mapping at
#'  the top level of the plot. You only need to supply
#'  mapping if there isn't a mapping defined for the plot.
#'
#' @param data A data frame. If specified, overrides the default
#'  data frame defined at the top level of the plot.
#'
#' @param stat The statistical transformation to use on
#'  the data for this layer, as a string.
#'
#' @param position Position adjustment, either as a string,
#'  or the result of a call to a position adjustment function.
#'
#' @param na.rm FALSE (the default), removes missing values
#'  with a warning. If TRUE silently removes missing values.
#'
#' @param show.legend Logical. Should this layer be included in
#'  the legends? NA, the default, includes if any aesthetics are
#'  mapped. FALSE never includes, and TRUE always includes.
#'
#' @param inherit.aes If FALSE, overrides the default aesthetics,
#'  rather than combining with them. This is most useful for helper
#'  functions that define both data and aesthetics and shouldn't inherit
#'  behaviour from the default plot specification
#'
#' @param ... Other arguments passed on to layer. There are three types of arguments you can use here.
#'
#' @section Aesthetics:
#' 
#' @examples
#' # Draw squares of varied sizes at aribtary locations
#'  df = data.frame(x = c(10,20,30,40,50),
#'                  y = c(50,40,30,20,10),
#'                  edge = (10,15,20,25,30),
#'                  type = c("A","B","A","A","B"))
#'  ggplot(df,aes(x = x,y = y,edge = edge)) + geom_draw_sqr(aes(fill = type))
#' @export


geom_draw_sqr = function(mapping = NULL, data = NULL, stat = "identity",
                         position = "identity", na.rm = FALSE, show.legend = NA, 
                         inherit.aes = TRUE, ...) {
  layer(
    geom = GeomDrawSquare, mapping = mapping, data = data, stat = stat, 
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#'  @export   


GeomDrawSquare =  ggproto("GeomDrawSquare", Geom,
                          required_aes = c("x","y","edge"),
                          default_aes = aes(
                            colour = "white", fill = "grey20", size = 0.5,
                            linetype = 1, alpha = 1
                          ),
                          draw_key = draw_key_rect,
                          draw_group = function(data,panel_scales,coord)
                          {
                            
                            x = c((data$x -data$edge/2),(data$x+data$edge/2))
                            y = c((data$y -data$edge/2),(data$y+data$edge/2))
                            data2 = data.frame(x = x, y = y)
                            attr = data[1,,drop = F]
                            coords = coord$transform(data2,panel_scales)
                            sd = abs(coords$x[1:nrow(data)] - coords$x[(nrow(data)+1):(nrow(data)*2)])
                            grid::rectGrob(x = (coords$x[1:nrow(data)]+sd/2), 
                                           y = (coords$y[1:nrow(data)]+sd/2),
                                           width = sd,height = sd,  default.units = "native",
                                           gp = grid::gpar(
                                             col = attr$colour,
                                             fill = scales::alpha(attr$fill,attr$alpha),
                                             lwd = attr$size,
                                             lty = attr$linetype
                                           ))
                          })

df = data.frame(x = c(10,20,30,40,50),
                y = c(50,40,30,20,10),
                edge = c(10,15,20,25,30),
                type = c("A","B","A","A","B"))
ggplot(df,aes(x = x,y = y,edge = edge)) + geom_draw_sqr(aes(fill = type))


# https://raw.githubusercontent.com/heike/mosaic/master/hard/R/geomtilenew.R

#' Draw rectangles with wide white borders.
#'
#' \code{geom_tile} uses the center of the tile and its size (\code{x},
#' \code{y}, \code{width}, \code{height}). 
#' 
#' @param mapping Set of aesthetic mappings created
#'  by aes or aes_. If specified and inherit.aes = TRUE
#'  (the default), is combined with the default mapping at
#'  the top level of the plot. You only need to supply
#'  mapping if there isn't a mapping defined for the plot.
#'
#' @param data A data frame. If specified, overrides the default
#'  data frame defined at the top level of the plot.
#'
#' @param stat The statistical transformation to use on
#'  the data for this layer, as a string.
#'
#' @param position Position adjustment, either as a string,
#'  or the result of a call to a position adjustment function.
#'
#' @param na.rm f FALSE (the default), removes missing values
#'  with a warning. If TRUE silently removes missing values.
#'
#' @param show.legend logical. Should this layer be included in
#'  the legends? NA, the default, includes if any aesthetics are
#'  mapped. FALSE never includes, and TRUE always includes.
#'
#' @param inherit.aes If FALSE, overrides the default aesthetics,
#'  rather than combining with them. This is most useful for helper
#'  functions that define both data and aesthetics and shouldn't inherit
#'  behaviour from the default plot specification
#'
#' @param ... other arguments passed on to layer. There are three types of arguments you can use here.
#'
#' @section Aesthetics:
#' 
#' @examples
#' # To draw arbitrary rectangles with wide white borders, use geom_tile_new()
#' df <- data.frame(
#'   x = rep(c(2, 5, 7, 9, 12), 2),
#'   y = rep(c(1, 2), each = 5),
#'   z = factor(rep(1:5, each = 2)),
#'   w = rep(diff(c(0, 4, 6, 8, 10, 14)), 2)
#' )
#' ggplot(df, aes(x, y)) +
#'   geom_tile_new(aes(fill = z))
#' 
#' @export

geom_tile_new <- function(mapping = NULL, data = NULL,
                          stat = "identity", position = "identity",
                          ...,
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomTileNew,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}


#' @export

GeomTileNew <- ggproto("GeomTileNew", GeomRect,
                       required_aes = c("x", "y"),
                       default_aes = aes(fill = "grey20", colour = "ehite", size = 2, linetype = 1, alpha = NA),
                       draw_key = draw_key_polygon,
                       
                       extra_params = c("na.rm", "width", "height"),
                       
                       setup_data = function(data, params) {
                         data$width <- data$width %||% params$width %||% resolution(data$x, FALSE)
                         data$height <- data$height %||% params$height %||% resolution(data$y, FALSE)
                         
                         transform(data,
                                   xmin = x - width / 2,  xmax = x + width / 2,  width = NULL,
                                   ymin = y - height / 2, ymax = y + height / 2, height = NULL
                         )
                       }
)



# EXAMPLE of geom_tile_new ----------------------------------------------------------------------------
"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}
# If you want to draw arbitrary rectangles, use geom_tile() or geom_rect()
df <- data.frame(
  x = rep(c(2, 5, 7, 9, 12), 2),
  y = rep(c(1, 2), each = 5),
  z = factor(rep(1:5, each = 2)),
  w = rep(diff(c(0, 4, 6, 8, 10, 14)), 2)
)
ggplot(df, aes(x, y)) +
  geom_tile_new(aes(fill = z, width = w))

