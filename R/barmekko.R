#' Calculate positions from widths.
#' 
#' @param width A numeric vector of bar widths.
#' @return A numeric vector of bar positions.
positions <- function(width) {
  0.5 * (cumsum(width) + cumsum(c(0, width[-length(width)])))
}

#' Create a bar mekko plot.
#'
#' A smarter bar chart.
#'
#' @param data A data frame.
#' @param x A categorical variable defining the width categories.
#' @param y A numeric variable defining the bar height.
#' @param width A numeric variable defining the bar widths
#' @param values A boolean indicating whether to show value labels in bars
#' @return A bar mekko constructed with ggplot2.
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(
#'   region = c('Northeast', 'Southeast', 'Central', 'West'),
#'   sales = c(1200, 800, 450, 900),
#'   avg_margin = c(3.2, -1.4, 0.1, 2.1)
#'   )
#' barmekko(df, region, avg_margin, sales)
#' barmekko(df, region, avg_margin, sales) + labs(title = 'Margins by Region')
#' library(dplyr)
#' barmekko(arrange(df, -sales), region, avg_margin, sales)
#' barmekko(arrange(df, -avg_margin), region, avg_margin, sales)
barmekko <- function(data, x, y, width, values = FALSE) {
  df <- data
  xlabel <- as.character(substitute(x))
  ylabel <- as.character(substitute(y))
  x <- as.character(eval(substitute(x), df))
  y <- eval(substitute(y), df)
  width <- eval(substitute(width), df)
  pos <- positions(width)
  p <- suppressWarnings(
    ggplot2::ggplot() +
    ggplot2::geom_bar(ggplot2::aes(x = pos, width = width, y = y, fill = x),
      stat = "identity") +
    ggplot2::scale_x_continuous(labels = x, breaks = pos) +
    ggplot2::xlab(xlabel) +
    ggplot2::ylab(ylabel) +
    ggplot2::guides(fill = ggplot2::guide_legend(title = xlabel))
  )
  if(values) {
    p + ggplot2::geom_text(aes(x = pos, y = 0, label = y, vjust = -0.5))
  } else {
    p
  }
}
