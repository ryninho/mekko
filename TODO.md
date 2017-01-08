# TODO
* replace geom_bar with geom_rect so that it works in plotly
* add smart sorting (width or y or data source order- never alpha)
* replace do() with something from purrr()
* suppress warning re: stacking in barmekko
# add smart color options e.g. red-green neg-pos (or color can be an additional variable?)
# add highlight option e.g. highlight a specific x value or highlight by mininimum or maximum width or y value
* separate data preparation from rendering to improve testability
* try on wider array of examples
* update vignette with new options above
# why doesn't this line work with the .md file created by keep_md option (shows text, doesn't run code):
    date: "`r Sys.Date()`"
* list package on CRAN

#### Coming back to this project
* Can update README by running the vignette rmarkdown file with output github_document
and then copying that as the README
