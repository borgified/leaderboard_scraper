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

use Data::Dumper qw(Dumper);
print Dumper $xml;
exit;


__END__

my @players;

foreach my $item (@{$$xml{'ActivePlayerData'}}){
	push(@players,"$$item{'PlayerName'}\($$item{'Rank'}\)");
}

my $players=join(' ',@players);

my $my_cnf = '/secret/my_cnf.cnf';

my $dbh = DBI->connect("DBI:mysql:"
                        . ";mysql_read_default_file=$my_cnf"
                        .';mysql_read_default_group=leaderboard_graph',
                        undef,
                        undef
                        ) or die "something went wrong ($DBI::errstr)";

my $sth=$dbh->prepare("insert into currentplayers (players) values ('$players')");
$sth->execute();

#broadcast a message out via twitter if num_players > $threshold
my $threshold=14;
my $num_players=@players;



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
