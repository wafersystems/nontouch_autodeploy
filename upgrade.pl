use Net::Telnet::Cisco;
my $username = 'username';
my $password = 'password';
my $prompt = '/.*[\#\>]\s*$/';

#laptop TFTP, upgrade one by one
open (DH,"C9Kip\.txt");
while (<DH>)
{
	my $line=$_;chomp $line;$line=~s/\s//;
	my $ip = $line;
	my $session1;
	eval{$session1 = Net::Telnet::Cisco->new(Host=>$ip,Timeout=>5,Prompt=>$prompt)};
	if ($@){print "$ip\ttelnetfail\n";next;}
	eval{$session1->login(Name=>$username,Password=>$password,Timeout=>5)};
	if ($@){print "$ip\tpasswordfail\n";next;}
	my @output=$session1->cmd(String=>"copy tftp://172.31.56.253/cat9k_iosxe.17.03.04.SPA.bin flash:\n\n", Timeout=>600);
	print "$ip\n@output"
}
<STDIN>;