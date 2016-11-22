# note: can try "position = "fill"" once barmekko works to extend

library(ggplot2)
library(dplyr)

# Original example --------------------------------------------------------
# 
# ggMMplot(diamonds$cut, diamonds$clarity)
# 
# 
# # Negative values ---------------------------------------------------------
# 
# # positive and negative values
# pos_neg <- mtcars
# pos_neg$negator <- rep(c(1, -1), nrow(mtcars) / 2)
# pos_neg$y <- pos_neg$disp * pos_neg$negator
# 
# avg_price <- diamonds %>% group_by(cut, color) %>% summarise(price = mean(price)) %>% ungroup() %>% mutate(price_rel = price - mean(price))
# ggplot(avg_price) + geom_bar(stat = "identity", (aes(x = cut, y = price, fill = color)))
# ggplot(avg_price) + geom_bar(stat = "identity", aes(x = cut, y = price_rel, fill = color))
# ggplotly()
# 
# 
# # Sample data -------------------------------------------------------------
# 
# df <- diamonds %>% group_by(cut, clarity) %>% summarize(count = n())
# 
# p <- ggplot(df, aes(x = cut, y = count, fill = clarity))
# p + geom_bar(stat = "identity")
# 
# ggplot(diamonds, aes(x = cut)) + geom_bar(stat = "count", aes(fill = clarity)) + facet_wrap(~ color)
# 
# # Working example ---------------------------------------------------------
# 
# GeomSameAsBar <- ggproto("GeomSameAsBar", GeomBar)
# 
# geom_same_as_bar <- function(stat = "count", width = NULL) {
#   layer(geom = GeomSameAsBar, stat = stat, data = NULL, position = "stack",
#         params = list(width = width)) 
# }
# 
# p + geom_same_as_bar()
# p + layer(geom = GeomSameAsBar, stat = "identity", data = NULL, position = "stack")
# 
# ggplot(diamonds, aes(x = cut, fill = clarity)) + 
#   geom_same_as_bar(stat = "count") + 
#   facet_wrap(~ color)
# 
# # Scratchpad --------------------------------------------------------------
# p + geom_bar(stat = "identity")

"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}

library(tibble)
df <- state.x77 %>% data.frame %>% 
  rownames_to_column("State") %>% select(State, Population, Illiteracy) %>%
  head(5) %>% 
  mutate(Illiteracy = ifelse(State == "Alabama", -Illiteracy, Illiteracy)) %>%
  mutate(Region = ifelse(State %in% c("Alabama", "Arkansas"), "South", "West"))

df %>% ggplot(aes(x = State, y = Illiteracy, fill = Region)) + geom_bar(stat = "identity")

GeomBarMekko <- ggproto("GeomBarMekko", GeomBar,
                        junk = function() {},
                        setup_data = function(data, params) {
                          # data$width <- data$width %||%
                          #   params$width %||% (resolution(data$x, FALSE) * 0.9)
                          browser()
                          # how to make this an if statement??
                          category_totals <- data %>% group_by(x) %>% 
                            summarize(x_count = n(), x_sum = sum(y))
                          
                          data <- data %>% inner_join(category_totals, by = "x") %>%
                            mutate(x_pct = x_sum / sum(x))
                          
                          w <- data$x_pct
                          # positions for labels and to center bars
                          # pos <- 0.5 * (cumsum(w) + cumsum(c(0, w[-length(w)])))
                          data$width <- w
                          
                          transform(data,
                                    ymin = pmin(y, 0), ymax = pmax(y, 0),
                                    xmin = x - width / 2, xmax = x + width / 2, width = NULL
                          )
                        }
)

geom_bar_mekko <- function(mapping = NULL, data = NULL,
                           stat = "count", position = "stack", width = NULL,
                           ...,
                           na.rm = FALSE, show.legend = NA, inherit.aes = TRUE) {
  
  # do something with the data here or in GeomSameAsBar?
  # could have an if statement based on the stat (count or identity)
  
  # if(stat == "count") {
  #   print("stat is count")
  # } else if(stat == "identity") {
  #   print("stat is identity")
  # } else {
  #   stop("stat must be count or identity")
  # }
  # browser()
  
  layer(data = data,
        mapping = mapping,
        stat = stat,
        geom = GeomBarMekko,
        position = position,
        params = list(width = width)
  )
}

# does stat have to be identity then? (if this is meant for numeric comparisons, not sums)
df %>% ggplot(aes(x = State, y = Illiteracy, fill = Region)) + geom_bar_mekko(width = Population)