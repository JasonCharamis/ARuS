use strict;
use warnings;

open ( IN, $ARGV[0] );
open ( IN1, $ARGV[1] );

my %DE_genes = ();
my %file = ();
my %geneids = ();
my $header = ();
my %orthologs = ();

## load DE gene IDs ##
while ( my $line = <IN> ) {
    chomp $line;
    if ( $. == 1 ) { $header = $line; }
    
    my @f = split (/\t/,$line);
    $DE_genes{$f[0]}=$line;
}

close (IN);

my %seen = ();
my @lines = ();

while ( my $line = <IN1> ) {

    chomp $line;
    push ( @lines, $line);
    my @f = split (/\t/,$line);
}

close (IN1);

## extract lines with orthologs for DE genes ##
my @h = ();

foreach ( keys %DE_genes ) {
    @h = grep(/$_/, @lines);
}

## associate DE genes with orthologs (if exist) ##
my @n = ();

foreach ( @h ) {
   
    my @b = split (/\t/,$_);
    $b[2] =~ s/\.\d//g;       
    @n = split (/,/,$b[2]);

    for my $v ( @n ) {
        if ( $b[1] =~ /Turt/ ) {
            $orthologs{$v}=$b[3];
        }
        elsif ( $b[1] =~ /Iscap/ ) {
            $orthologs{$v}=$b[3];
        }
        elsif ( $b[1] =~ /Dpter/ ) {
            $orthologs{$v}="Dpter_$b[3]";
        }
        elsif ( $b[1] =~ /Mocc/ ) {
            $orthologs{$v}="Mocc_$b[3]";
        }
    }
}


## add extra column in headers and print ##
my @hs = split (/\t/,$header);
print "$hs[0]\t$hs[1]\tOrthology\t";

for my $left ( 2..scalar(@hs)-1) {
    print "$hs[$left]\t"
}

print "\n";

## print new output with orthology ##
foreach ( keys %DE_genes ) {

    my @j = split (/\t/,$DE_genes{$_});
    print "$j[0]\t$j[1]\t";
   
    if ( exists $orthologs{$_} ) {
        print "$orthologs{$_}\t";
    }

    else { print "Aculy_specific\t"; }

    for my $lefti ( 2..scalar(@j)-1) {
        print "$j[$lefti]\t"
    }
    print "\n";
}
