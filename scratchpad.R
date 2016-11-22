
# Original example --------------------------------------------------------

ggMMplot(diamonds$cut, diamonds$clarity)


# Negative values ---------------------------------------------------------

# positive and negative values
pos_neg <- mtcars
pos_neg$negator <- rep(c(1, -1), nrow(mtcars) / 2)
pos_neg$y <- pos_neg$disp * pos_neg$negator

avg_price <- diamonds %>% group_by(cut, color) %>% summarise(price = mean(price)) %>% ungroup() %>% mutate(price_rel = price - mean(price))
ggplot(avg_price) + geom_bar(stat = "identity", (aes(x = cut, y = price, fill = color)))
ggplot(avg_price) + geom_bar(stat = "identity", aes(x = cut, y = price_rel, fill = color))
ggplotly()


# Sample data -------------------------------------------------------------

df <- diamonds %>% group_by(cut, clarity) %>% summarize(count = n())

p <- ggplot(df, aes(x = cut, y = count, fill = clarity))
p + geom_bar(stat = "identity")

ggplot(diamonds, aes(x = cut)) + geom_bar(stat = "count", aes(fill = clarity)) + facet_wrap(~ color)

# Working example ---------------------------------------------------------

GeomSameAsBar <- ggproto("namedoesntmatter", GeomBar)

geom_same_as_bar <- function(stat = "identity", width = NULL) {
  layer(geom = GeomSameAsBar, stat = stat, data = NULL, position = "stack") 
}

p + geom_same_as_bar()
p + layer(geom = GeomSameAsBar, stat = "identity", data = NULL, position = "stack")

ggplot(diamonds, aes(x = cut, fill = clarity)) + 
  geom_same_as_bar(stat = "count") + 
  facet_wrap(~ color)

# Scratchpad --------------------------------------------------------------
p + geom_bar(stat = "identity")

GeomSameAsBar <- ggproto("namedoesntmatter", GeomBar)

geom_same_as_bar <- function(stat = "identity", width = NULL) {
  layer(geom = GeomSameAsBar, stat = stat, data = NULL, position = "stack",
        params = list(width = width)) 
}

# works
ggplot(diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(stat = "count", width = 0.5) + 
  facet_wrap(~ color)

# also work
ggplot(diamonds, aes(x = cut, fill = clarity)) + 
  geom_same_as_bar(stat = "count", width = 0.5) + 
  facet_wrap(~ color)

