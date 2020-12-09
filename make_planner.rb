#!/usr/bin/ruby
require 'rubygems'
require 'hebruby'
require 'date'
require 'csv'
require 'optparse'
require 'fileutils'

$converter = :inkscape
OptionParser.new do |opts|
  opts.on("--inkscape", "Use inkscape to convert SVG to PDF") do
    $converter = :inkscape
  end
  opts.on("--rsvg-convert", "Use rsvg-convert to convert SVG to PDF") do
    $converter = :rsvg_convert
  end
  opts.on("--cairosvg", "Use cairosvg to convert SVG to PDF") do
    $converter = :cairosvg
  end
end.parse!

startdate = Date.parse(ARGV[0])
num_weeks = ARGV[1].to_i

def handlefile in_name, out_date, replacements
 svg_out_name = "generated/#{out_date}.svg"
 s = open(in_name) do |f|
   f.read
 end
 s.gsub! /%VAR_[a-zA-Z0-9_]+%/, replacements
 open(svg_out_name, 'w') do |f|
   f.write s
 end

 pdf_out_name = "generated/#{out_date}.pdf"
 puts pdf_out_name
 case $converter
 when :inkscape
   system("inkscape", svg_out_name, "--export-pdf=#{pdf_out_name}")
 when :cairosvg
   system("cairosvg", svg_out_name, "-o", pdf_out_name)
 when :rsvg_convert
   system("rsvg-convert" , "-f", "pdf", "-o", pdf_out_name, svg_out_name)
 end
end

FileUtils.mkdir_p "generated"
FileUtils.mkdir_p "final"

dates = (0...(num_weeks*7)).map {|n| startdate + n}
dates.each_slice(7) do |week|
  replacements = {}
  week.each_with_index do |day, idx|
    hebday = Hebruby::HebrewDate.new(day)
    replacements["%VAR_hebrew_#{idx+1}%"] = "#{hebday.heb_day_name} #{hebday.heb_month_name}"
  end
  week.each_with_index do |day, idx|
    replacements["%VAR_dayname_#{idx+1}%"] = day.strftime("%A")
  end
  week.each_with_index do |day, idx|
    replacements["%VAR_english_#{idx+1}%"] = day.strftime("%B %-d")
  end

  iso = week.map do |day|
    day.strftime("%Y-%m-%d")
  end

  handlefile "0-sunday-monday.svg", iso[0], replacements
  handlefile "1-tuesday-wednesday.svg", iso[2], replacements
  handlefile "2-thursday-friday.svg", iso[4], replacements
  handlefile "3-saturday-notes.svg", iso[6], replacements
end

puts "final/daily-pages.pdf"
system("pdfunite", "fillerpage.pdf", *Dir.glob("generated/*.pdf").sort, "final/daily-pages.pdf")
puts "final/daily-pages-book.pdf"
system(*%w[pdfbook2 --paper=letter -o 0 -i 0 -t 0 -b 0 --no-crop final/daily-pages.pdf])

puts <<END
Check the outputs in the final/ directory. Make sure that:
 * The lines are crisp
 * All of the text substituted properly
 * No fonts are missing
 * The margins are not too large.
 * There are no unwanted artifacts
 * The page size is correct
 * The pages are in the right order
END
