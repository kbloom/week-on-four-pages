#!/usr/bin/ruby
require 'rubygems'
require 'hebruby'
require 'date'
require 'csv'

startdate = Date.parse(ARGV[0])
num_weeks = ARGV[1].to_i

dates = (0...(num_weeks*7)).map {|n| startdate + n}

headers = (1..7).flat_map{|n| ["dayname_#{n}", "iso_#{n}", "english_#{n}", "hebrew_#{n}"]}
puts headers.to_csv

dates.each_slice(7) do |week|
	row = week.flat_map do |day|
		hebday = Hebruby::HebrewDate.new(day)
		[ day.strftime("%A"), day.strftime("%Y-%m-%d"), day.strftime("%B %-d"), "#{hebday.heb_day_name} #{hebday.heb_month_name}" ]
	end
	puts row.to_csv
end
