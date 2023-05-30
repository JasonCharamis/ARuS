## Perl script to combine the DE output of edgeR with annotation file to get a description for each gene ##

use strict;
use warnings;

my %genes = ();

my @lines = ();

open ( IN, $ARGV[0] );

while ( my $line = <IN> ) {
    chomp $line;

    $line =~ s/PSKW_//g;

    ## print header based on edgeR file architecture ##
    if ( $. == 1 ) {
        my @f = split (/\t/,$line);
        $f[0] =~ s/sampleA/Geneid/g;
        $f[2] =~ s/logFC/log2FC/g;

        ## keep only geneid, log2FC, p-value and FDR ##
        print "$f[0]\tAnnotation\t$f[2]\t$f[4]\t$f[5]\t";

        ## print raw read counts per replicate ##
        for my $p ( 6..scalar(@f) - 1 ) {

            ## counts in samples not used in DE analysis (this is affected by PCA) discarded ##
            unless ( $p =~ /\b9|13|14|17/ ) {
                print "$f[$p]\t";
            }
        }
        print "\n";

    }
    push ( @lines, $line);
}

open ( IN2, $ARGV[1] );

## open annotation file - description here is in the 7th column ##
while ( my $line = <IN2> ) {
    chomp $line;
    $line =~ s/\.\d//g;
    my @f = split (/\t/,$line);

    ## make a hash with geneid - description associations ##
    unless ( exists $genes{$f[0]} ) {
        $genes{$f[0]} = $f[6];
    }

}

foreach ( @lines ) {
  ## combine edgeR output and annotation file to print the final output with
  ## only the desired columns from edgeR output and the gene description/annotation
   my @h = split (/\t/,$_);
    if ( exists $genes{ $h[0] } ) {
        print "$h[0]\t$genes{$h[0]}\t$h[3]\t$h[5]\t$h[6]\t";

        for my $i ( 7..scalar(@h) - 1 ) {
            unless ( $i =~ /9|13|14|17/ ) {
                print "$h[$i]\t";
            }
        }
        print "\n";
    }
}
