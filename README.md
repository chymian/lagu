# LaGu Mining Rig

This Project is to test Mining on div. Arm v7 (32bit) and Arm v8 (64bit) SBC-Boards.
Inspired by the Electroneum Project and their intent to mine their Cryptonight-Based Coin ETN on mobile Phones.

At the moment, we started off with Arm v7 (32bit) based Odroid XU4 (MC1,HC1) from hardkernel.org.  
Others to follow.

In this repository is the Miner (see https://github.com/tpruvot/cpuminer-multi) and a little mimik for downloading a  
config-file from an central location on every start of the miner, stop mining and enable/disable a watchdog-style process-mgmt.  

The Image can be downloaded from http://lagu.eb8.org/lagu/
Unizp it with 7zip and use etcher or other SW to write it to an microSD card.


## Configuration
After the first boot, the hostname is set to rig-xxxxxx, where xxxxxxx are the least 6 chararcters from the MAC-Address.  
To find it, use a Android-App like Fing, have a look at your Routers DHCP-listing, or on linux use something like  
```nmap -sn 192.168.1.0/24|egrep --color "for.[a-z\.]*.\(*.*.*.*\)"``` (adopt the IP-Address to your Network-Address).  

There is a user lagu (pw: lagu) which is used for mining.  
The root password is set to ```.pw_lagu```. I's recommended to change both passwords with ```sudo passwd <user>``` on your first login.  
You can ssh to your SBC (Windows user use i.e. PUTTY) and adapt the config.

* If you have more SBCs on which you want to mine and access to a webserver, it might be easiest too upload a config-file to the webserver and 
let the rigs download them before starting to mine. So you have only config to take care of in case you want to switch Pools, etc.  
In this scenario, SSH to every SDB once and use an editor of your choice to write the link of the config-file into the file lagu/remote.conf  

```
ssh rig-abcdef # or use putty on win
cd lagu
nano remote.conf
```

Download the config-file from http://lagu.eb8.org/lagu/template.conf to your workstation, adapt it and upload it to your webserver 
so that it ends up in the location which you referred in ```remote.conf```


* If you have only one or two SBCs or no access to an Webserver, rename the file lagu.conf to local.conf and adapt it to your needs.  
Either localy and copy them over or per SSH (scp) to every SBC and delete the remote.conf file.  
Without an remote.conf, the miner don't try to download a remote config-file.

```
cd lagu
mv lagu.conf local.conf
nano local.conf
rm remote.conf
```

The miner first reads local.conf, and then, if remote.conf exists, downloads lagu.conf and reads that overwriting the "defaults" in local.conf.

## Grouping SBCs
The name of the config-file, which resides on the webserver can be freely choosen. So, with different ```remote.conf``` on different SBCs,  
you can let them downlowd different config-files and so group multiples SBCs together, to i.e mine on different pools.



### Activate new config
To activate a new config, restart miner:  
```
mining restart
```

or reboot the SBC:

```
sudo reboot
```


### Mining command

```
mining --help
usage: mining <command>
command:
        start   Start mining (and download config-file)
	stop    Stop mining
	restart Restart mining
	enable  Enable autostart & Watchdog
	disable Disable autostart & Watchdog
	update  Update lagu-rig sw from git
```

