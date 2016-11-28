#' Calculate positions from widths
positions <- function(width) {
  0.5 * (cumsum(width) + cumsum(c(0, width[-length(width)])))
}

#' Create a bar mekko plot.
#'
#' A smarter bar chart.
#'
#' @param df A data frame.
#' @param x A categorical variable defining the width categories.
#' @param y A numeric value defining the bar height.
#' @param width A numeric value defining the bar widths
#' @return A bar mekko constructed with ggplot2.
#' @export
#' @examples
#' df <- data.frame(
#'   region = c('Northeast', 'Southeast', 'Central', 'West'),
#'   sales = c(1200, 800, 450, 900),
#'   avg_margin = c(3.2, -1.4, 0.1, 2.1)
#'   )
#' barmekko(df, region, avg_margin, sales)
#' barmekko(df, region, avg_margin, sales) + labs(title = 'Margins by Region')
barmekko <- function(df, x, y, width) {
  xlabel <- substitute(x)
  ylabel <- substitute(y)
  x <- eval(substitute(x), df)
  y <- eval(substitute(y), df)
  width <- eval(substitute(width), df)
  pos <- positions(width)
  suppressWarnings(ggplot2::ggplot() +
    ggplot2::geom_bar(ggplot2::aes(x = pos, width = width, y = y, fill = x),
      stat = "identity") +
    ggplot2::scale_x_continuous(labels = x, breaks = pos) +
    ggplot2::xlab(xlabel) +
    ggplot2::ylab(ylabel) +
    ggplot2::guides(fill = ggplot2::guide_legend(title = xlabel)))
}
