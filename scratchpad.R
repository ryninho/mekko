library(ggplot2) # TODO: is this the right place for this?
library(dplyr)

hec <- HairEyeColor %>% data.frame %>% filter(Sex == "Male") %>% select(-Sex)

# standard example
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair)) + 
  geom_bar(stat = "identity", position = "fill")

# ... can use width, but...
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, 
  width = c(.1, .1, .1, .1, .6, .6, .6, .6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill")

# ... only with a few categories and nothing too large!
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, 
  width = c(.1, .1, .1, .1, 6, 6, 6, 6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill")

# ... and fails if trying to place the labels since axis is discrete
ggplot(hec, aes(x = Eye, y = Freq, fill = Hair, 
  width = c(.1, .1, .1, .1, 6, 6, 6, 6, 1, 1, 1, 1, .5, .5, .5, .5))) + 
  geom_bar(stat = "identity", position = "fill") + 
  scale_x_continuous(breaks = c(.1, 6.1, 7.1, 7.6), 
                     labels = c("Brown", "Blue", "Hazel", "Green"))



# example -----------------------------------------------------------------


df <- hec %>% rename(x = Eye, y = Hair, width = Freq)

xlabel <- substitute(x)
ylabel <- substitute(y)

x_widths <- df %>% group_by(x) %>% 
  summarize(x_width = sum(width)) %>% 
  mutate(
    wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
    wmax = cumsum(x_width),
    wcenter = (wmin + wmax) / 2
  )

df <- df %>% inner_join(x_widths, by = "x")

df <- df %>% group_by(x) %>% 
  do(mutate(., 
    ymin = c(0, head(cumsum(width), length(width) - 1)),
    ymax = cumsum(width),
    ymin = ymin / max(ymax),
    ymax = ymax / max(ymax))) %>%
  ungroup
arrange(df, x, y)

p <- ggplot(df, aes(xmin=wmin, xmax=wmax, ymin=ymin, ymax=ymax, fill = y))

p <- p + geom_rect()

breaks <- unique(df$wcenter)
labels <- unique(df$y)
p <- p + scale_x_continuous(breaks = breaks, labels = labels)

p + xlab(xlabel) + ylab(ylabel) + guides(fill=guide_legend(title=xlabel))


# function definition -----------------------------------------------------

marimekko <- function(df, x, y, width) {
  xlabel <- substitute(x)
  ylabel <- substitute(y)
  df$x <- eval(substitute(x), df)
  df$y <- eval(substitute(y), df)
  df$width <- eval(substitute(width), df)
  
  x_widths <- df %>% group_by(x) %>% 
    summarize(x_width = sum(width)) %>% 
    mutate(
      wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
      wmax = cumsum(x_width),
      wcenter = (wmin + wmax) / 2
    )
  
  df <- df %>% inner_join(x_widths, by = "x")
  
  df <- df %>% group_by(x) %>% 
    do(mutate(., 
              ymin = c(0, head(cumsum(width), length(width) - 1)),
              ymax = cumsum(width),
              ymin = ymin / max(ymax),
              ymax = ymax / max(ymax))) %>%
    ungroup
  arrange(df, x, y)
  
  p <- ggplot(df, aes(xmin=wmin, xmax=wmax, ymin=ymin, ymax=ymax, fill = y))
  
  p <- p + geom_rect()
  
  breaks <- unique(df$wcenter)
  labels <- unique(df$y)
  p <- p + scale_x_continuous(breaks = breaks, labels = labels)
  
  p + xlab(xlabel) + ylab(ylabel) + guides(fill=guide_legend(title=xlabel)) 
}


# actual function call ----------------------------------------------------

marimekko(hec, Eye, Hair, Freq)
