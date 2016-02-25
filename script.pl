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
  $m->get($url);
  $m->select('ddlTerm','16/SP');
  my$response = $m->click_button(name => 'btnSubmit');
  my $temp = $response->content();
  my %hash = ();
  
  while ($temp =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>((\w+\s+\w+).*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
    (my $course, my $tempSche) =($1, $2);
    my @schedules = split /<br>\s/, $tempSche;
  	
  	
    foreach my $schedule (@schedules) {
        $schedule =~ /(\w+\s+\w+)\s+(L\w+\s+\w+\s+(?:\d{2}:\d{2}(?:AM|PM)\s\d{2}:\d{2}(?:AM|PM)))/g;
        
        if(exists($hash{$1})){
         
        }
        else{
        	$hash{$1} = 1;
        }

    }
  }
  	foreach my $key(sort keys %hash){
  		print $key, "\n";
  	}
}
sub getRoom {
  $m->get($url);
  $m->select('ddlTerm',$_[0]);
  my$response = $m->click_button(name => 'btnSubmit');
  my $temp = $response->content();
  my $count = 0;
  
  while ($temp =~ />([A-Z]+-\w+-\w+)<br>.*<\/span><\/a>\s*<\/td><td>((\w+\s+\w+).*(?:AM|PM)\s*)<\/td><td>[A-Z]/g) {
    (my $course, my $tempSche) =($1, $2);
    my @schedules = split /<br>\s/, $tempSche;
  
    foreach my $schedule (@schedules) {
        $schedule =~ /(\w+\s+\w+)\s+(L\w+\s+\w+\s+(?:\d{2}:\d{2}(?:AM|PM)\s\d{2}:\d{2}(?:AM|PM)))/g;
        $schedule = $2;
        my $room = $_[1];
        my $temp = $1;
        $room =~  s/\s/\\s*/g;
        #print $room;
        if($temp =~/$room/) {
            print $course, "\t",$schedule, "\n";
            $count = 1;
        }        
    }
  }
  if ($count==0){
        	print "No class for this room or room is incorrect!\n";
        }
}

sub getTerms() {
  $m->get($url);
  my $temporary = $m->content();
  
  	while($temporary =~ /<option value="\w+\/\w+">(\w+\/\w+\s+-\s+.+)<\/option>/g){
  		print $1,"\n";	
  	}
}


if($arg =~ /--terms/) {
  getTerms();
  exit 0;
}
if($arg =~ /--rooms/) {
  getRooms();
  exit 0 ;
}
if($arg =~ /(\w+\/\w+)/) {
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
