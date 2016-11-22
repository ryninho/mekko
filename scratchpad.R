library(ggplot2)
library(dplyr)
library(grid)

library(tibble)
df <- state.x77 %>% data.frame %>% 
  rownames_to_column("State") %>% select(State, Population, Illiteracy) %>%
  head(5) %>% 
  mutate(Illiteracy = ifelse(State == "Alabama", -Illiteracy, Illiteracy)) %>%
  mutate(Region = ifelse(State %in% c("Alabama", "Arkansas"), "South", "West"))

ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

#' TODO:
#' 1) [DONE] set positions
#' 2) [DONE] use them for widths
#' 3) use them with scale_x_continuous to set the labels
#' 4) make sure the legends are in the right place (same order as y categories)
#' 5) sort from largest to smallest (or make that an option?)
#' 6) suppress warnings

GeomBarMekko <- ggproto("GeomBarMekko", GeomBar,
                        setup_data = function(data, params) {
                          data$width <- data$width / sum(data$width) # TODO: need this?
                          pos <- 0.5 * (cumsum(data$width) + cumsum(c(0, data$width[-length(data$width)])))
                          transform(data,
                                    ymin = pmin(y, 0), ymax = pmax(y, 0),
                                    xmin = pos - width / 2, xmax = pos + width / 2, width = NULL
                          )
                        },
                        draw_panel = function(self, data, panel_scales, coord) {
                          panel_scales$x.range <- c(0,1) # TODO: need this?
                          coords <- coord$transform(data, panel_scales)
                          browser()
                            ggname("geom_rect", rectGrob(
                              coords$xmin, coords$ymax,
                              width = coords$xmax - coords$xmin,
                              height = coords$ymax - coords$ymin,
                              default.units = "native",
                              just = c("left", "top"),
                              gp = gpar(
                                col = coords$colour,
                                fill = alpha(coords$fill, coords$alpha),
                                lwd = coords$size * .pt,
                                lty = coords$linetype,
                                lineend = "butt"
                              )
                            ))
                        }
)


geom_bar_mekko <- function(mapping = NULL, data = NULL,
  stat = "identity", position = "stack", width = NULL,
  ...,
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE) {

  layer(data = data,
    mapping = mapping,
      stat = stat,
      geom = GeomBarMekko,
      position = position,
      params = list(...)
  )
}

# before: with geom_bar
# df %>% ggplot(aes(x = State, y = Illiteracy, fill = Region, width = .75)) +
#   geom_bar(position = "identity", stat = "identity")
# 
# # with geom_bar, can't use variable width effectively
# df %>% ggplot(aes(x = State, y = Illiteracy, fill = Region, width = Population)) +
#   geom_bar(position = "identity", stat = "identity")

# with geom_bar_mekko, side-by-side comparisons scaled for importance stand out
df %>% ggplot(aes(x = State, y = Illiteracy, fill = Region, width = Population)) + 
  geom_bar_mekko(position = "identity")

