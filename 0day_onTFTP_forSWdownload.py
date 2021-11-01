print("\n\n *** Day0 Autostart Python Script *** \n\n")
import cli
print("\n\n *** username & vty *** \n\n")
cli.configurep(["username username privilege 15 password password", "enable password password", "line vty 0 15", "login local", "transport input all", "end"])
#print("\n\n *** image download *** \n\n")
#print("downloading\n")
#cli.command = "copy tftp://172.31.56.253/cat9k_iosxe.17.03.04.SPA.bin flash:\n"
#cli.executep(cli.command)
print("\n\n *** Day0 Autostart Python Script complete *** \n\n")
