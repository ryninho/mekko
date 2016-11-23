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



# example -----------------------------------------------------------------


df <- hec %>% rename(x = Eye, y = Hair, width = Freq)

x_widths <- df %>% group_by(x) %>% 
  summarize(x_width = sum(width)) %>% 
  mutate(
    wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
    wmax = cumsum(x_width),
    wcenter = (wmin + wmax) / 2
  )

df <- df %>% inner_join(x_widths, by = "x")

df1 <- df %>% group_by(x) %>% 
  do(mutate(., 
    ymin = c(0, head(cumsum(width), length(width) - 1)),
    ymax = cumsum(width))) %>%
  ungroup
arrange(df1, x, y)

p = ggplot(df1, aes(xmin=wmin, xmax=wmax, ymin=ymin, ymax=ymax, fill = y))

p = p + geom_rect()
p
# replacing x axis numbers with words
breaks = unique(df1$wcenter)
labels = unique(df1$y)
p = p + scale_x_continuous(breaks = breaks, labels = labels)

p


# function definition -----------------------------------------------------




# actual function call ----------------------------------------------------

# marimekko(hec, Hair, Eye, Freq)
marimekko(hec, Eye, Hair, Freq)
