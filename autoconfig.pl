#!perl
use Net::SSH2::Cisco;
use Net::Telnet::Cisco;

my $prompt = '/.*[\#\>]\s*$/';
#my $enablepwd = 'cisco123';#‘’里填写enable password!!
my $username = 'username';
my $password = 'password';
my $dhcpip='172.31.57.254';

#dhcpip.txt records ip address copyed from DHCP server lease
#nontouch deploy DHCP server
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
	$session1->cmd(String=>"terminal length 0");
    #login in IP use command to check serial number, we use the serial number to match its configuration file
	my @sncmd=$session1->cmd(String=>"show ver | in System Serial",Timeout => 5);#现场查看
	my $sn;
	my $hostname;
	my $tmp=$sncmd[0];
	$tmp=~/\:\s*([A-Z0-9]+)/;
	$sn=$1;
    
    #open sn_rack.txt to check sn->hostname list. 
    #later, the configuration file's name is combined with hostname and .txt
	open(FH,"sn_rack\.txt");
	while (<FH>)
	{
		my $line=$_;
		chomp $line;
		my @sn_host=split /\t/,$line;
		if ($sn_host[3] eq $sn)
		{
			print "$sn_host[1]\t$sn\n";
			$hostname=$sn_host[1];
			last;
		}
	}
	close(FH);

    #the configuration file name is combined with hostname and .txt
	open (CM,"./C9Kconfig/$hostname\.txt");
    #send configuration
	while (<CM>)
	{
		my $cmds = $_;chomp $cmds;
        #if there is wrong with configuration, print the line
		eval{$session1->cmd(String=>$cmds)};
		if($@)
		{
			print "$cmds\n$@";
		}
	}
}
