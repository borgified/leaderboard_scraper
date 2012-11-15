#!/usr/bin/env perl

use warnings;
use strict;

#use Sys::Hostname;

use XML::Simple;
use LWP::Simple;
use DBI;

my %config = do '/secret/leaderboard_scraper.config';

my $url		= $config{url};

my $xml = XMLin(get($url));


#my $my_cnf = '/secret/my_cnf.cnf';
#
#my $dbh = DBI->connect("DBI:mysql:"
#                        . ";mysql_read_default_file=$my_cnf"
#                        .';mysql_read_default_group=scraper',
#                        undef,
#                        undef
#                        ) or die "something went wrong ($DBI::errstr)";

#my $sth=$dbh->prepare("insert into currentplayers (players) values ('$players')");
#$sth->execute();

use Data::Dumper qw(Dumper);
print Dumper $xml;
exit;


foreach my $item (@{$$xml{'StatsLeaderboard'}}){

	foreach my $cat (keys $item){
		print "$cat $$item{$cat}\n";
	}
}

#load lastmodified table

#compare lastmodified on new leaderboard and update if different







__END__

my $content = get("http://acss.alleg.net/Stats/Leaderboard.aspx");
if(!defined($content)){
	&batsignal("couldn't load leaderboard");
	exit;
}

print $content;


sub batsignal {
	my($msg)=shift @_;
	my $to = 'borgified@gmail.com';

	open(MAIL, "|/usr/sbin/sendmail -t");

	my $from=$0.'@spathiwa.com';
	my $subject="FAILED: $msg";

	print MAIL "To: $to\n";
	print MAIL "From: $from\n";
	print MAIL "Subject: $subject\n\n";

	print MAIL "-------------------------------------------\n";
	print MAIL "-------------------------------------------\n";

	close(MAIL);
}
