#!/usr/bin/perl
use WWW::Mechanize;
use warnings;
use strict;
my $arg = shift @ARGV;
my $url = 'http://www2.monmouth.edu/muwebadv/wa3/search/SearchClasses.aspx';
my $m = WWW::Mechanize->new();




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
sub getRoom {
  $m->get($url);
  print $_[0], "\n";
  print $_[1], "\n";
  $m->select('ddlTerm',$_[0]);
  my$response = $m->click_button(name => 'btnSubmit');
  my $temp = $response->content();
  while ($temp =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>((\w+\s+\w+).*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
    (my $course, my $tempSche) =($1, $2);
    my @schedules = split /<br>\s/, $tempSche;

    foreach my $schedule (@schedules) {
        $schedule =~ /(\w+\s+\w+)\s+(L\w+\s+\w+\s+(?:\d{2}:\d{2}(?:AM|PM)\s\d{2}:\d{2}(?:AM|PM)))/g;
        $schedule = $2;
        my $room = $_[1];
        print $room;
        if(my $schedule =~ /\Q$_[1]/) {
            print $course, "\t",$schedule, "\n";
        }
    }

  }
}

sub getTerms() {
  my @terms = (1,2,3);

  foreach my $term (@terms) {
    print $term, "\n";
  }

  return @terms;
}


if($arg =~ /--terms/) {
  getTerms();
  exit 0;
}
if($arg =~ /--rooms/) {
  getRooms();
  exit 0 ;
}
if($arg =~ /(\w+\/\w+)\s+.+/) {
  my $arg1 = shift @ARGV;
  my $term = $1;
  if($arg1 =~ /(\w+\s+\w+)/) {
    my $room = $1;

    getRoom($term, $room);
  }
  exit 0;
}
if($arg =~ /--help/) {
  help();
  exit 0;
}
