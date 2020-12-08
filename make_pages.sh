#!/bin/sh

set -x

for x in $1/*.svg; do
   rsvg-convert -f pdf $x -o ${x%.svg}.pdf
done

pdfunite fillerpage.pdf $1/*.pdf daily-pages.pdf
