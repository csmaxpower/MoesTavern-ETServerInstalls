# MoesTavern-ETServerInstalls
### Files for installing and configuring Wolfenstein:Enemy Territory and ET: Legacy game servers on Linux (x86_64)

These scripts download, install, and configure all necessary components to run an ET: Legacy game server (*tested up to* `v2.81.1-54`).  From a menu, you can select either a **Competition** based server or a **Public** based server and the installer will download and configure the appropriate settings for each. It will also configure FTP access for on-going management of the server.  More than one server can be installed on the same host with this installer using a different `net_port` for each installation.  Each server instance is installed into a directory corresponding to the servers port number and systemctl services are created for each in the same manner.  (e.g. `/install_path/27960`,`/install_path/27970` & `etlserver-27960.service`, `etlserver-27970.service`)

Note that this install script assumes it is being run a freshly installed Linux server running **Ubuntu 20.xx** and above.  The OS and packages will be updated before the server installation begins.

*The current project only maintains updates for Wolfenstein: Enemy Territory Legacy servers for which the directions are below.  Other automated installation scripts found in `/old` are specific to certain hosts and other game mods and are not actively maintained.*


# Directions
### Installs ET: Legacy Server with desired options and cusomizations:

- [ ] Download *installETLServer.sh*:   `sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/installETLServer.sh`
- [ ] Set install script permissions:   `sudo chmod +x installETLServer.sh`
- [ ] Run *installETLServer.sh*:   `sudo ./installETLServer.sh`
- [ ] Choose menu option to begin installation:
    
![menu](https://moestavern.site.nfoservers.com/downloads/images/moes/etl-serverinstall-menu.png)

- [ ] The necessary setup scripts will then be downloaded and executed and then there will be user prompts for server customization of the following cvars: 
    - `sv_hostname`, `net_port`
    - `sv_maxclients`, `sv_privateclients` 
    - `g_password`, `sv_privatepassword`, `rconpassword`, `refereepassword`, `ShoutcastPassword` 
    - `sv_wwwBaseURL`

- [ ] You will need the http link to whichever `.sh` installer version for ETLegacy you are wanting to install when the script asks for the installation url.  
    - Example URL: `https://www.etlegacy.com/workflow-files/dl/01dc5c31ca47758e13455d43ae43682fb3ade3dd/lnx64/etlegacy-v2.81.1-54-g01dc5c3-x86_64.sh`

- [ ] There will then be user prompts for setting an `username` and `password` for **FTP** access of the server.  This will configure the `vsftpd` service and also write a `DENY` line in the SSH access file for the new user that was just created to keep things nice and secure.

- Finally, the script will write and configure a system level service for running the ETL server, a system restart service and system timer to manage daily restarts.  The default timer is set to restart the server service at `05:00am` if not specified during installation (server local time). 

### Example system service usage:  
`sudo systemctl start|stop|status|restart etlserver-27960.service`


```bash
etuser@moestavern-na-dev:~# sudo systemctl status etlserver-27960.service
● etlserver-27960.service - Wolfenstein Enemy Territory Server
     Loaded: loaded (/etc/systemd/system/etlserver-27960.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2023-04-03 09:00:08 PDT; 9h ago
   Main PID: 139900 (etl_start.sh)
      Tasks: 2 (limit: 2266)
     Memory: 99.3M
     CGroup: /system.slice/etlserver-27960.service
             ├─139900 /bin/bash /home/etuser/et/etl_start.sh start
             └─139908 /home/etuser/et etlded.x86_64 +set dedicated 2 +set vm_game 0
             +set net_port 27960 +set sv_maxclients 32 +set fs_game legacy
             +set fs_basepath /home/etuser/et
             +set fs_homepath /home/etuser/et +exec etl_server.cfg
```

`sudo systemctl start|stop|status|restart etlmonitor-27960.timer`

```bash
etuser@moestavern-na-dev:~# sudo systemctl status etlmonitor-27960.timer
● etlmonitor.timer - This timer restarts the Enemy Territory Legacy server service etlserver.service every day at 5am
     Loaded: loaded (/etc/systemd/system/etlmonitor-27960.timer; enabled; vendor preset: enabled)
     Active: active (waiting) since Thu 2023-03-16 06:15:51 PDT; 2 weeks 4 days ago
    Trigger: Tue 2023-04-04 09:00:00 PDT; 14h left
   Triggers: ● etlrestart.service
```

### Watch the video tutorial below:

[![Watch the video](https://moestavern.site.nfoservers.com/downloads/images/moes/preview.png)](https://youtu.be/fojhP5CBE4k)
