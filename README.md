# LaGu Mining Rig

This Project is to test Mining on div. Arm v7 (32bit) and Arm v8 (64bit) SBC-Boards.
Inspired by the Electroneum Project and their intent to mine their Cryptonight-Based Coin ETN on mobile Phones.

Our first take is the Arm v7 (32bit) Exynos5 Octa based Odroid XU4/MC1/HC1 from [hardkernel.com](http://hardkernel.com).  
Others to follow.

In this repository is the Miner (see https://github.com/tpruvot/cpuminer-multi) and a little code around it for downloading a 
config-file from an central location on every start of the miner, stop mining and enable/disable a watchdog-style process-mgmt.  

## Preparing the microSD card  
The Image can be downloaded from [here](http://lagu.eb8.org/lagu/)  
Unizp it with 7zip and use etcher or other SW to write it to an microSD card.


## Configuration
After the first boot, the hostname is set to rig-xxxxxx, where xxxxxxx are the least 6 chararcters from the MAC-Address.  
To find it, use a Android-App like Fing, have a look at your Routers DHCP-listing, or on linux use something like  
```nmap -sn 192.168.1.0/24|egrep --color "for.[a-z\.]*.\(*.*.*.*\)"``` (adopt the IP-Address to your Network-Address).  

There is a user lagu (pw: lagu) which is used for mining.  
The root password is set to ```.pw_lagu```. I's recommended to change both passwords with ```sudo passwd <user>``` on your first login.  
You can ssh to your SBC (Windows user use i.e. PUTTY) and adapt the config.

### Configration Template
Download the config-file from [here](http://lagu.eb8.org/lagu/template.conf) to your workstation, change POOLx and WALLETx to your needs.  
HINT: at the moment, only POOL1, POOLPASSWD1 and WALLET1 are used.


#### If you have only one or two SBCs or no access to an webserver  
on every SBC:  
* delete the file lagu/remote.conf  
* delete the file lagu/lagu.conf  
* copy your template to lagu/local.conf  

Without an remote.conf, the miner don't try to download a remote config-file.


```
ssh rig-xxxxxx # or on win use putty
cd lagu
rm lagu.conf remote.conf
nano local.conf
```

#### If you have more SBCs and access to an webserver
Upload the config-file to the webserver and let the rigs download them before starting to mine.  
In this scenario, SSH to every SDB once and use an editor of your choice to write the link of the config-file 
into the file ```lagu/remote.conf```  

Edit and upload the config-file to your webserver so that it ends up in the location which you  
referred in ```remote.conf```  

```
ssh rig-xxxxxx # or use putty on win
cd lagu
nano remote.conf
```

The miner first reads ```local.conf``` (if it exists) and then, if ```remote.conf``` exists, downloads the confg-file from the link in  
```remote.conf``` to ```lagu.conf``` and reads that, "overwriting" the "defaults" in local.conf.


### Grouping SBCs
The name of the config-file which resides on the webserver can be freely choosen. So, with different ```remote.conf``` on different SBCs, 
you can let them downlowd different config-files and so group multiples SBCs together to i.e mine on different pools.


### Activate new config
To activate a new config, restart miner:  
```
mining restart
```

or reboot the SBC:

```
sudo reboot
```


## Mining command

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

