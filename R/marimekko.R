#' Create a Marimekko plot.
#'
#' A smarter stacked bar chart.
#'
#' @param data A data frame.
#' @param x A categorical variable defining the width categories.
#' @param y A categorical variable defining the (vertical) segment categories.
#' @param width A numeric variable to be summed across both categories.
#' @return A Marimekko constructed with ggplot2.
#' @importFrom dplyr %>%
#' @importFrom dplyr ungroup
#' @export
#' @examples
#' library(ggplot2)
#' hec <- dplyr::filter(data.frame(HairEyeColor), Sex == "Male")
#' marimekko(hec, Eye, Hair, Freq)
#' # Note: Compare to productplots::prodplot(
#' #   hec, Freq ~ Hair + Eye, mosaic("v")
#' # ) + aes(fill=Hair)
#' marimekko(hec, Hair, Eye, Freq) + labs(title = "Hair and Eye Color")
marimekko <- function(data, x, y, width) {
  df <- data
  xlabel <- substitute(x)
  ylabel <- substitute(y)
  df$x <- eval(substitute(x), df) %>% as.character
  df$y <- eval(substitute(y), df)
  df$width <- eval(substitute(width), df)

  x_widths <- df %>% dplyr::group_by(x) %>%
    dplyr::summarize(x_width = sum(width)) %>%
    dplyr::mutate(
      wmin = c(0, head(cumsum(x_width), length(x_width) - 1)),
      wmax = cumsum(x_width),
      wcenter = (wmin + wmax) / 2
    )

  df <- df %>% dplyr::inner_join(x_widths, by = "x")

  df <- df %>% dplyr::group_by(x) %>%
    dplyr::do(dplyr::mutate(.,
      ymin = c(0, head(cumsum(width), length(width) - 1)),
      ymax = cumsum(width),
      ymin = ymin / max(ymax),
      ymax = ymax / max(ymax))) %>%
    ungroup

  p <- ggplot2::ggplot(df, ggplot2::aes(
         xmin = wmin, xmax = wmax, ymin = ymin, ymax = ymax, fill = y
         )
    )

  p <- p + ggplot2::geom_rect(color = "gray33")

  breaks <- unique(df$wcenter)
  labels <- unique(df$x) %>% as.character
  p <- p + ggplot2::scale_x_continuous(breaks = breaks, labels = labels)

  p + ggplot2::xlab(xlabel) + ggplot2::ylab(ylabel) +
    ggplot2::guides(fill = ggplot2::guide_legend(title = ylabel))
}
