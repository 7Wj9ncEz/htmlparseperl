#!/usr/bin/perl
use warnings;
use strict;

open FILE, "<webpage.html";
my $temp = do{local $/; <FILE>};
#\s*<\/td><td>([A-Z]{2}.*(?:PM|AM))

sub help() {
  print("\nUsage: perl -w perlproject.pl \"Term\" \"Room\" [> filename.html]\n
  List of options:
    \tRequired:
        \t\tTerm : which Term (semester) the class is in, e.g. \"16/SP - Spring 2016\"
        \t\tRoom : which classroom
    \tOptional:
        \t\t--help : display this help screen and sample usage
        \t\t--terms : list all currently available\n\n");
}

sub getRooms() {
  while ($temp =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>(\w+\s+\w+.*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
    print "<$2>\n"
  }
}

sub getTerms() {
  print "teste terms\n"
}


foreach (@ARGV) {
      if($_ =~ /--terms/) {
        getTerms();
        exit 0;
      }
      elsif($_ =~ /--rooms/) {
        getRooms();
        exit 0;
      }
      else {
        help();
        exit 0;
      }
};
