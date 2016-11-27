library(ggplot2) # TODO: is this the right place for this (pre-packaging)?
library(dplyr)

#' Create a Marimekko plot
#'
#' A smarter stacked bar chart.
#' 
#' @param df A data frame.
#' @param x A categorical variable defining the width categories.
#' @param y A categorical variable defining the (vertical) segment categories.
#' @param width A numeric value to be summed across both categories.
#' @return A Marimekko constructed with ggplot2.
#' @examples 
#' hec <- HairEyeColor %>% data.frame %>% filter(Sex == "Male") %>% select(-Sex)
#' marimekko(hec, Eye, Hair, Freq)
#' # Note: Compare to productplot::prodplot(
#' #   hec, Freq ~ Hair + Eye, mosaic("v")
#' # ) + aes(fill=Hair)
#' marimekko(hec, Hair, Eye, Freq) + labs(title = "Hair and Eye Color")
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

  p <- ggplot(df, aes(xmin=wmin, xmax=wmax, ymin=ymin, ymax=ymax, fill = y))
  
  p <- p + geom_rect()
  
  breaks <- unique(df$wcenter)
  labels <- unique(df$x)
  p <- p + scale_x_continuous(breaks = breaks, labels = labels)
  
  p + xlab(xlabel) + ylab(ylabel) + guides(fill=guide_legend(title=ylabel)) 
}