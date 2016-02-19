use warnings;
use strict;
open FILE, "<webpage.html";
my $courses = do{local $/; <FILE>};
#\s*<\/td><td>([A-Z]{2}.*(?:PM|AM))

while ($courses =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>(\w+\s+\w+.*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
  print "<$1><$2>\n"
}
