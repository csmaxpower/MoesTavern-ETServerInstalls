# MoesTavern-ETServerInstalls
### Files for installing and configuring Wolfenstein:Enemy Territory game servers on Linux

These scripts download, install, and configures all necessary files to run an ETLegacy server (tested up to `v2.81.1-54`) with competition settings and maps. It will also configure FTP access for on-going management of the server.

Note that this means the install script assumes a freshly installed Linux server running *Ubuntu 20.xx* and above.  The OS and packages will be updated before the server installation begins.

*The current project only maintains and updates for Wolfenstein: Enemy Territory Legacy servers for which directions are below.  Other automated installation scripts found in `/old` are specific to certain hosts and other game mods and are not actively maintained.*


# Directions
### Installs Enemy Territory Legacy Server with competition (*stopwatch*) settings:

-  Download *installETLScrimServer.sh*  `sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/installETLScrimServer.sh`
-  Set install script permissions  `sudo chmod +x installETLScrimServer.sh`
-  Run *installETLScrimServer.sh*  `sudo ./installETLScrimServer.sh`

- The necessary setup scripts will then be downloaded and executed and then there will be user prompts for server customization of the following cvars: 
    - `sv_hostname`, `g_password` 
    - `sv_maxclients`, `sv_privateclients` 
    - `sv_privatepassword`, `rconpassword`, `refereepassword`, `ShoutcastPassword` 
    - `sv_wwwBaseURL`

- You will need the http link to whichever `.sh` installer version for ETLegacy you are wanting to install when the script asks for the installation url.  (e.g. `https://www.etlegacy.com/workflow-files/dl/01dc5c31ca47758e13455d43ae43682fb3ade3dd/lnx64/etlegacy-v2.81.1-54-g01dc5c3-x86_64.sh`)

There will then be user prompts for setting an username and password for FTP access of the server.  This will configure the vsftpd service and also write a `DENY` line in the SSH access file for the new user that was just created to keep things nice and secure.

Finally, the script will write and configure a system level service for running the ETL server, a system restart service and system timer to manage daily restarts. Example system service usage:  `sudo systemctl start|stop|status|restart etlserver.service`

### Watch the video tutorial below:

[![Watch the video](https://moestavern.site.nfoservers.com/downloads/images/moes/preview.png)](https://youtu.be/85Rn-jtDNPo)
