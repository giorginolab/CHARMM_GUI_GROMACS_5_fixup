#!/usr/bin/perl -w

# Read statements from stdin in the form KEY = VALUE (spaces are
# mandatory). Replace or insert them in the given MDP file.

#my $mdp=shift @ARGV;
my %rep=();

while (<STDIN>) {
    chomp;
    my @tmp=split;
    $rep{$tmp[0]}=$tmp[2];
}

while (my $l=<>) {
    chomp $l;
    my @tmp=split ' ', $l;
    if(scalar @tmp && defined $rep{$tmp[0]}) {
	print "$tmp[0] = $rep{$tmp[0]} \t\t; REPLACED, was $tmp[2] \n";
	delete $rep{$tmp[0]};
    } else {
	print "$l\n";
    }
}

foreach my $i (keys %rep) {
    print $i . " = " . $rep{$i} . "\t\t; ADDED\n";
}


    
