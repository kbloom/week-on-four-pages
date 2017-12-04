#!/usr/bin/ruby
puts <<ENDHEADER
<html>
  <head>
    <style>
    @page { margin: 0px; }
    .newpage { break-before:always; }
    @media print {
      #firstpage {
         top:0; 
   	 left:0; 
         bottom: 0; 
         right: 0;
	 padding: 1in;
	 text-align:center;
	 vertical-align:middle;
      }
    }
    </style>
  </head>
  <body>
ENDHEADER

puts "    <p id='firstpage'>This page intentionally left blank. It should be the front side of the first page</p>"
ARGV.each_with_index do |file, index|
	puts "    <div class='newpage'><img src='#{file}'></div>"
end

puts <<ENDFOOTER
  </body>
</html>
ENDFOOTER
