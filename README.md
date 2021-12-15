# MoesTavern-ETServerInstalls
Files for installing and configuring ET and ETL game servers

These scripts download, install, and configures all necessary files to run an ETLegacy server (version 2.78) with competition settings and maps. It will also configure FTP access for on-going management of the server.

The scripts, system services, configs, and downloads links are baselined to Moe's Tavern's hosts for everything except the game assets installation and key generation.

Note that this install script assumes a bare metal Linux server running Ubuntu 20.xx and >.  The system and packages will be updated before the server installation begins.


# Directions

1.  Run installETL(Scrim/Pub)Server.sh  (wget http://moestavern.site.nfoservers.com/downloads/server/installETL(Scrim/Pub)Server.sh)
2.  chmod +x installETL(Scrim/Pub)Server.sh
3.  ./installETL(Scrim/Pub)Server.sh

The necessary setup scripts will then be downloaded and executed.  There will be user prompts for server customization of the following cvars:
servername, g_password, sv_maxclients, sv_privateclients, sv_privatepassword, rconpassword, refereepassword, sv_wwwBaseURL

There will then be user prompts for setting an username and password for FTP access of the server.  This will configure the vsftpd service and also write a DENY line in the SSH access file for the new user that was just created to keep things nice and secure.

Finally, the script will install and configure a system level service for running the ETL server and start it automatically.  

usage:  systemctl start/stop/restart etlserver.service
