use Net::Telnet::Cisco;
my $username = 'username';
my $password = 'password';
my $prompt = '/.*[\#\>]\s*$/';
open (DH,"dhcpip\.txt");
while (<DH>)
{
	my $line=$_;chomp $line;$line=~s/\s//;
	my $ip = $line;
	my $session1;
	eval{$session1 = Net::Telnet::Cisco->new(Host=>$ip,Timeout=>5,Prompt=>$prompt)};
	if ($@){print "$ip\ttelnetfail\n";next;}
	eval{$session1->login(Name=>$username,Password=>$password,Timeout=>5)};
	if ($@){print "$ip\tpasswordfail\n";next;}
	my @output=$session1->cmd(String=>"wr");
	foreach (@output)
	{
		if ($_=~/building conf/i)
		{
			print "$ip\n$_";
		}
	}
}
<STDIN>;