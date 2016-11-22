
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
# GeomSameAsBar <- ggproto("namedoesntmatter", GeomBar)
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

GeomBarMekko <- ggproto("namedoesntmatter", GeomBar)

geom_bar_mekko <- function(mapping = NULL, data = NULL,
  stat = "count", position = "stack", width = NULL,
  ...,
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE) {
  
  # do something with the data here or in GeomSameAsBar?
  # could have an if statement based on the stat (count or identity)
  if(stat == "count") {
    print("stat is count")
  } else if(stat == "identity") {
    print("stat is identity")
  } else {
    stop("stat must be count or identity")
  }
  
  # data2 <- data %>%
  #   mutate(w = 0.25)
  print(nrow(data))
  print(head(data))
  
  layer(data = data,
    mapping = mapping,
      stat = stat,
      geom = GeomBarMekko,
      position = position,
      params = list(width = width)
  )
}


# ggplot(diamonds, aes(x = cut, fill = clarity)) + 
#   geom_bar_mekko(stat = "count", width = 0.5) + 
#   facet_wrap(~ color)

# ggplot(df, aes(x = cut, y = count, fill = clarity)) + 
#   geom_bar_mekko(stat = "identity", width = 0.75)

ggplot(df, aes(x = cut, y = count, fill = clarity)) + 
  geom_bar_mekko(stat = "identity")
