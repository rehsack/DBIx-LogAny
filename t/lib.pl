# $Id: lib.pl 4157 2010-07-05 10:45:22Z martin $
use Cwd;
use File::Spec;
use Test::More;

my $logtmp1;
my $logtmp2;

sub get_config
{
    my @v;
    if (-f ($file = 't/dbixl4p.config')  ||
	-f ($file = '../dbixl4p.config') ||
	-f ($file = 'dbixl4p.config')) {
	open IN, "$file";
	while (<IN>) {
	    chomp;
	    if ($_ eq 'UNDEF') {
		push @v, undef;
	    } else {
		push @v, $_;
	    }
	}
    }
    return @v;
}

sub config
{
    my $td = File::Spec->tmpdir or die q/Can't find a temporary directory to use. Please set TMPDIR, TEMP or TMP environment variables to a valid cirectory/;

    $logtmp1 = File::Spec->catfile($td, 'dbixroot.log');
    note("log file 1 is $logtmp1");
    $logtmp2 = File::Spec->catfile($td, 'dbix.log');
    note("log file 2 is $logtmp2");
    return($logtmp1, $logtmp2);
}

sub check_log
{
    my ($s, $file) = @_;
    $$s = "";
    return 0 if (! -r $file);
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size, $atime,$mtime,$ctime,$blksize,$blocks) = stat($file);
    return 0 if ($size <= 0);
    open IN, "<$file";
    while (<IN>) {$$s .= $_};
    close IN;
    unlink $file;
    diag($$s) if ($ENV{TEST_VERBOSE});
    return 1;
}
1;
