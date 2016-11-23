library(ggplot2) # TODO: is this the right place for this?
library(dplyr)

hec <- HairEyeColor %>% data.frame %>% filter(Sex == "Male") %>% select(-Sex)

# standard example
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair)) + 
  geom_bar(stat = "identity", position = "fill")

# ... can use width, but...
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, width = c(.1, .1, .1, .1, .6, .6, .6, .6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill")

# ... only with a few categories and nothing too large!
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, width = c(.1, .1, .1, .1, 6, 6, 6, 6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill")

# ... and fails if trying to place the labels since axis is discrete
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, width = c(.1, .1, .1, .1, 6, 6, 6, 6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill") + scale_x_continuous(breaks = c(.1, 6.1, 7.1, 7.6), labels = c("Brown", "Blue", "Hazel", "Green"))



df <- hec %>% rename(x = Eye, y = Hair, width = Freq) # just for function development

df <- df %>% split(df$y) %>% lapply(
  mutate, 
  ymin = c(0, head(cumsum(width), length(width) - 1)),
  ymax = cumsum(width),
  ycenter = (ymin + ymax) / 2
) %>% 
  bind_rows

x_widths <- df %>% group_by(x) %>% 
  summarize(x_width = sum(width)) %>% 
  mutate(
    wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
    wmax = cumsum(x_width),
    wcenter = (wmin + wmax) / 2
  )

df <- df %>% inner_join(x_widths, by = "x")

df <- df %>% arrange(x, y, width)

# geom_tile- need to rename x, y axes
ggplot(df, aes(x = wcenter, y = ycenter, width = x_width, height = width, fill = y)) + geom_tile()

# alt: geom_rect- no x, y axes, need to rename legend title
ggplot(df, aes(xmin = wmin, xmax = wmax, ymin = ymin, ymax = ymax, fill = y)) + geom_rect()

y_heights
df %>% mutate(
  wmin = c(0, head(cumsum(width), length(width) - 1)),
  wmax = cumsum(width)
)

  
  df$xmin = df$xmin / max(df$xmax)
  dfmax = df$xmax / max(df$xmax)
  
  p = ggplot(df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax))
  
  p = p + geom_rect(aes_string(fill=secondary_dim_name))
  
  # replacing x axis numbers with words
  breaks = unique(rowMeans(toy[,c('xmin','xmax')]))
  labels = as.character(unique(toy[[dim_name]]))
  p = p + scale_x_continuous(breaks = breaks, labels = labels)
  
  p

# marimekko(hec, Hair, Eye, Freq)
marimekko(hec, Eye, Hair, Freq)


# do-over -----------------------------------------------------------------


df <- hec %>% rename(x = Eye, y = Hair, width = Freq) # just for function development

x_widths <- df %>% group_by(x) %>% 
  summarize(x_width = sum(width)) %>% 
  mutate(
    wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
    wmax = cumsum(x_width),
    wcenter = (wmin + wmax) / 2
  )

df <- df %>% inner_join(x_widths, by = "x")

# df <- df %>% arrange(x, y, width) # necessary?

df1 <- df %>% group_by(x) %>% 
  do(mutate(., 
    ymin = c(0, head(cumsum(width), length(width) - 1)),
    ymax = cumsum(width))) %>%
  ungroup
arrange(df1, x, y)

p <- ggplot(df1, aes(ymin = ymin, ymax = ymax,
                      xmin = wmin, xmax = wmax, fill = y))
p
p1 <- p + geom_rect()
p1

# Let’s try that again... -------------------------------------------------

df <- data.frame(segment = c("A", "B", "C", "D"), 
                 segpct = c(40, 30, 20, 10), 
                 Alpha = c(60, 40, 30, 25), Beta = c(25, 30, 30, 25),
                 Gamma = c(10, 20, 20, 25), Delta = c(5, 10, 20, 25))

df

df$xmax <- cumsum(df$segpct)
df$xmin <- df$xmax - df$segpct
df$segpct <- NULL

dfm <- reshape2::melt(df, id = c("segment", "xmin", "xmax"))

dfm1 <- dfm %>% group_by(segment) %>% 
  do(mutate(., 
    ymax = cumsum(value),
    ymin = ymax - value))


dfm1$xtext <- with(dfm1, xmin + (xmax - xmin)/2)
dfm1$ytext <- with(dfm1, ymin + (ymax - ymin)/2)

p <- ggplot(dfm1, aes(ymin = ymin, ymax = ymax,
                      xmin = xmin, xmax = xmax, fill = variable))
p
p1 <- p + geom_rect(colour = I("grey"))
p1
