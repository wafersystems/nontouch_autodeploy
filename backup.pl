use Net::Telnet::Cisco;
my $username = 'username';
my $password = 'password';
my $prompt = '/.*[\#\>]\s*$/';
open (DH,"dhcpip\.txt");
my $n=0;my $m=0;

#write and save show running config
while (<DH>)
{
	$m++;
	my $line=$_;chomp $line;$line=~s/\s//;
	my $ip = $line;
	print "$ip\n";
	my $session1;
	eval{$session1 = Net::Telnet::Cisco->new(Host=>$ip,Timeout=>5,Prompt=>$prompt)};
	if ($@){print "$ip\ttelnetfail\n";next;}
	eval{$session1->login(Name=>$username,Password=>$password,Timeout=>5)};
	if ($@){print "$ip\tpasswordfail\n";next;}
	my @output=$session1->cmd(String=>"wr",Timeout=>15);
	foreach (@output)
	{
		if ($_=~/building conf/i)
		{
			print "$ip\n$_";
		}
	}
	$session1->cmd(String=>"terminal length 0");
	my $hostname=$session1->last_prompt;
	$hostname=~s/#//;
	unlink "./C9Kbackup/$hostname\.txt";
	open (BK,">>","./C9Kbackup/$hostname\.txt");
	my @running=$session1->cmd(String=>"show run",Timeout=>15);
	eval{print BK "@running"};
	if (!$@){$n++;print "$hostname backup ok\nok:$n\ttotal:$m\n";}
}
<STDIN>;