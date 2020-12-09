# Planner pages with a week on 4 pages.

My wife designed this planner for her own use.

To generate pages, run

    ./make_planner.rb <start_date> <num_weeks>

There are several command-line flags you can use to choose an SVG to PDF tool.
Some may render the SVG differently (incorrectly), so choose wisely, and check
the output carefully.  Make sure that:

 * The lines are crisp
 * All of the text substituted properly
 * No fonts are missing
 * The margins are not too large.
 * There are no unwanted artifacts
 * The page size is correct
 * The pages are in the right order
 
These should be booket printed (`make_planner.rb` generates a PDF for this),
and cut down the middle.

# Monthly pages

For the monthly calendar, we like to use "Month on 2 pages" from Scattered
Squirrel as dividers. My wife explicitly requests that these *not* be printed
double-sided, but the 5.5 x 8.5 version should be printed 2-up or booklet-printed 
and cut down the middle. (Use `make_book.sh` for this.)
