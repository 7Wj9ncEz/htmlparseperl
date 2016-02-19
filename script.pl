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

}
sub getRoom() {
  while ($temp =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>((\w+\s+\w+).*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
    (my $course, my $tempSche) =($1, $2);
    my @schedules = split /<br>\s/, $tempSche;

    foreach my $schedule (@schedules) {
        $schedule =~ /(\w+\s+\w+)\s+(L\w+\s+\w+\s+(?:\d{2}:\d{2}(?:AM|PM)\s\d{2}:\d{2}(?:AM|PM)))/g;
        $schedule = $2;
        if($1 =~ /HH\s*208/) {
            print $course, "\t",$schedule, "\n";
        }
    }

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
