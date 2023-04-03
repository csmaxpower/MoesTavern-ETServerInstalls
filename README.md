# MoesTavern-ETServerInstalls
Files for installing and configuring ET and ETL game servers

These scripts download, install, and configures all necessary files to run an ETLegacy server (tested up to `v2.81.1-54`) with competition settings and maps. It will also configure FTP access for on-going management of the server.

The scripts, system services, configs, and downloads links are baselined to Moe's Tavern's hosts for everything except the game assets installation and key generation.

Note that this install script assumes a bare metal Linux server running Ubuntu 20.xx and above.  The OS and packages will be updated before the server installation begins.


# Directions

1.  Download installETLScrimServer.sh  `sudo wget http://moestavern.site.nfoservers.com/downloads/server/installETLScrimServer.sh`
2.  Set install script permissions  `sudo chmod +x installETLScrimServer.sh`
3.  Run installETLScrimServer.sh  `sudo ./installETLScrimServer.sh`

The necessary setup scripts will then be downloaded and executed.  There will be user prompts for server customization of the following cvars:
servername, g_password, sv_maxclients, sv_privateclients, sv_privatepassword, rconpassword, refereepassword, sv_wwwBaseURL

There will then be user prompts for setting an username and password for FTP access of the server.  This will configure the vsftpd service and also write a DENY line in the SSH access file for the new user that was just created to keep things nice and secure.

Finally, the script will write and configure a system level service for running the ETL server, a system restart service and system timer to manage daily restarts. Example system service usage:  `sudo systemctl start|stop|status|restart etlserver.service`

[![Watch the video](https://i9.ytimg.com/vi/85Rn-jtDNPo/mq2.jpg?sqp=COjbrKEG-oaymwEmCMACELQB8quKqQMa8AEB-AHUBoAC4AOKAgwIABABGGUgZShlMA8=&rs=AOn4CLCEgHb02Vtdwe3qGhLPzmd3laipQA)](https://youtu.be/85Rn-jtDNPo)
