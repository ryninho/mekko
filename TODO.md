# TODO

Bugs
* suppress warning re: stacking in barmekko (or just replace geom_bar)
# why doesn't this line work with the .md file created by keep_md option (shows text, doesn't run code):
    date: "`r Sys.Date()`"

Immediate
* add labels and set default (have/don't?)
* add smart sorting (width or y or data source order- never alpha)

Soon
# add smart color options e.g. red-green neg-pos (or color can be an additional variable)
# add highlight option e.g. highlight a specific x value or highlight by mininimum or maximum width or y value
* replace geom_bar with geom_rect so that it works in plotly (include rangeslider example from
https://cpsievert.github.io/plotly_book/extending-ggplotly.html)
* separate data preparation from rendering to improve testability
* update vignette with new options above once completed
* write tests and include wider array of examples
* get package listed on CRAN

Ideas
* replace do() with something from purrr()

#### Coming back to this project
* open one of the R/*.R files and make edits to functions; test by running the vignette .Rmd file
* can use devtools::load_all() to re-load the package after changes
* Can update README by running the vignette rmarkdown file with output github_document
and then copying that as the README. Need to update references to the .png files
