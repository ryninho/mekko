#' Create a marimekko plot.
#'
#' A 100\% stacked bar chart with variable widths.
#'
#' @param data A data frame.
#' @param x A categorical variable defining the width categories.
#' @param fill A categorical variable defining the stacked segments.
#' @param width A numeric variable defining the bar widths.
#' @param values A boolean indicating whether to show percent labels in bars.
#' @return A marimekko constructed with ggplot2.
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(
#'   region = rep(c('East', 'West'), each = 2),
#'   result = rep(c('Good', 'Bad'), 2),
#'   share = c(60, 40, 80, 20),
#'   sales = c(300, 300, 200, 200)
#' )
#' marimekko(df, region, result, sales)
marimekko <- function(data, x, fill, width, values = FALSE) {
  df <- data
  xlabel <- as.character(substitute(x))
  filllabel <- as.character(substitute(fill))
  xval <- as.character(eval(substitute(x), df))
  fillval <- as.character(eval(substitute(fill), df))
  widthval <- eval(substitute(width), df)

  x_levels <- unique(xval)
  width_map <- tapply(widthval, xval, function(z) z[1])
  widths <- as.numeric(width_map[x_levels])
  pos <- positions(widths)

  tbl <- as.data.frame(table(x = xval, fill = fillval), stringsAsFactors = FALSE)
  tbl$prop <- tbl$Freq / ave(tbl$Freq, tbl$x, FUN = sum)
  tbl$width <- width_map[tbl$x]
  tbl$pos <- pos[match(tbl$x, x_levels)]
  tbl$label_y <- ave(tbl$prop, tbl$x, FUN = function(z) cumsum(z) - z/2)

  p <- suppressWarnings(
    ggplot2::ggplot(tbl) +
      ggplot2::geom_bar(
        ggplot2::aes(x = pos, y = prop, width = width, fill = fill),
        stat = "identity"
      ) +
      ggplot2::scale_x_continuous(labels = x_levels, breaks = pos) +
      ggplot2::xlab(xlabel) +
      ggplot2::ylab("Proportion") +
      ggplot2::guides(fill = ggplot2::guide_legend(title = filllabel))
  )
  if (values) {
    labs <- round(tbl$prop * 100, 1)
    p + ggplot2::geom_text(
      ggplot2::aes(x = pos, y = label_y, label = labs), size = 3
    )
  } else {
    p
  }
}
