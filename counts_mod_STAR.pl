use strict;
#use warnings;

open ( IN, $ARGV[0] );

while ( my $line = <IN> ) {

    chomp $line;
    $line =~ s/\.Aligned\.sortedByCoord\.out\.bam|gene:|results\///g;

    if ( $line =~ /\^|#/ ) {
        next;
    }
    
    
    my @f = split (/\t/,$line);  
    print "$f[0]\t$f[6]";
    
    for my $i ( 7..scalar(@f) - 1 ) {
        print "\t";
        print "$f[$i]";
    }

    print "\n";

}
