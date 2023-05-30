use strict;
use warnings;

open ( IN, $ARGV[0] );

while ( my $line = <IN> ) {

    my $new_name = $ARGV[0];
    $new_name =~ s/counts.mod.txt.|.edgeR.DE_results//g;
    rename ($ARGV[0], $new_name );

}
