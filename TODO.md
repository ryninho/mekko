# TODO

Branch idea: Only barmekko
* Drop marimekko function
* Drop marimekko from vignette
* Write R-package-friendly documentation
* Do whatever else it takes to submit to CRAN

Bugs
* arrange() doesn't lead to properly sorted marimekko (ignores sort)
* suppress warning re: stacking in barmekko (or just replace geom_bar)
* why doesn't this line work with the .md file created by keep_md option (shows text, doesn't run code):
    date: "`r Sys.Date()`"

Immediate
* add border lines to marimekko as default (hard to see differences in columns with same color right now)
* if you leave in a grouping variable it groups the chart by it (see cancelation analysis rmd and group by time zone name and time zone)... geom_bar doesn't do this; should I keep this or remove it?
* add value label examples to demo and documentation
* add arrange/sorting examples to the demo and documentation
* add label rotation examples to demo and documentation
* improve label placement when all values are negative
* allow user to set text y, vjust including using a variable (or should it default to y rather than 0?)

Soon
* add Simpson's Paradox example from here: http://quillette.com/2017/05/26/paradoxes-probability-statistical-strangeness/
* hack plotly so that it shows the options I want it to show
-- see https://cpsievert.github.io/plotly_book/extending-ggplotly.html for:
"Figure 1.9: Using the style() function to modify hoverinfo attribute values of a plotly object created via ggplotly() (by default, ggplotly() displays hoverinfo for all traces). In this case, the hoverinfo for a fitted line and error bounds are hidden."
* add smart color options e.g. red-green neg-pos (or color can be an additional variable)
* add highlight option e.g. highlight a specific x value or highlight by mininimum or maximum width or y value
* allow multiple columns for X (concatenate) or at least just include a good example in the docs
* replace geom_bar with geom_rect so that it works in plotly (include rangeslider example from
https://cpsievert.github.io/plotly_book/extending-ggplotly.html)
* separate data preparation from rendering to improve testability
* update vignette with new options above once completed
* write tests and include wider array of examples
* get package listed on CRAN. Check that it passes this before submitting: https://github.com/softwaredeng/RRF/blob/master/instruction.txt#L5
* allow option to display raw values, categories or percentages of total

Ideas
* replace do() with something from purrr()
* add smart sorting (width or y or data source order- never alpha) (is desc by width really most common??)

#### Coming back to this project
* Can update README by running the vignette rmarkdown file with output github_document
and then copying that as the README. Need to update references to the .png files.
