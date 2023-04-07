#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimSetupLibrary.sh

# Update the server
function updateServer() {
    sudo apt update
    sudo apt -y upgrade
}

# needed to extract compressed Files
function installUnzip() {
    sudo apt-get install -y unzip
}

# installation of ETL and server configs
function installET() {
    # variable to store user input
    local installtype=${1}
    local sv_hostname=${2}
    local g_password=${3}
    local sv_privateclients=${4}
    local sv_privatepassword=${5}
    local rconpassword=${6}
    local refereepassword=${7}
    local ShoutcastPassword=${8}
    local sv_wwwBaseURL=${9}
    local downloadLink=${10}
    local current_dir=${11}
    local sv_maxclients=${12}
    local net_port=${13}

    sudo mkdir -p ${current_dir}/${net_port}/
    sudo mkdir -p ${current_dir}/tmp/etsetup
    cd ${current_dir}/tmp/etsetup
    sudo wget ${downloadLink} -O etlegacy-server-install.sh
    sudo chmod +x etlegacy-server-install.sh
    yes | ./etlegacy-server-install.sh
    sudo mv etlegacy-v*/* ${current_dir}/${net_port}/
    rm -rf ${current_dir}/tmp/etsetup

    if [[ $installtype == "comp" ]]; then
        echo "Starting competition configuration..."
        cd ${current_dir}/${net_port}/legacy/
        sudo mkdir configs/
        sudo mkdir mapscripts/
        sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
        unzip main.zip
        sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/${net_port}/legacy/configs/
        sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/${net_port}/legacy/mapscripts/
        sudo mv Legacy-Competition-League-Configs-main/etl_server_comp.cfg ${current_dir}/${net_port}/etmain/etl_server.cfg
        sudo rm -rf main.zip
        sudo rm -rf Legacy-Competition-League-Configs-main/
        cd ${current_dir}/${net_port}/etmain/    
        sudo sed -i 's#set sv_hostname  			     ""#set sv_hostname '\"${sv_hostname}\"'#' etl_server.cfg
        sudo sed -i 's#set g_password				    ""#set g_password '\"${g_password}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_maxclients 			  ""#set sv_maxclients '\"${sv_maxclients}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_privateclients   	"0"#set sv_privateclients '\"${sv_privateclients}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_privatepassword  	""#set sv_privatepassword '\"${sv_privatepassword}\"'#' etl_server.cfg
        sudo sed -i 's#set rconpassword			    ""#set rconpassword '\"${rconpassword}\"'#' etl_server.cfg
        sudo sed -i 's#set refereePassword 		  ""#set refereepassword '\"${refereepassword}\"'#' etl_server.cfg
        sudo sed -i 's#set ShoutcastPassword		  ""#set ShoutcastPassword '\"${ShoutcastPassword}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_wwwBaseURL 			   ""#set sv_wwwBaseURL '\"${sv_wwwBaseURL}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_hidden "1"#set sv_hidden '\"0\"'#' etl_server.cfg
    else
        echo "Starting public configuration..."
        cd ${current_dir}/${net_port}/legacy/
        sudo mkdir configs/
        sudo mkdir mapscripts/
        # get up to date and best map-scripts from competition repository
        sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
        unzip main.zip
        sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/${net_port}/legacy/mapscripts/
        sudo rm -rf main.zip
        sudo rm -rf Legacy-Competition-League-Configs-main/
        cd ${current_dir}/${net_port}/etmain/   
        sudo wget https://raw.githubusercontent.com/etlegacy/etlegacy/master/misc/etmain/etl_server.cfg -O etl_server.cfg
        sudo wget https://raw.githubusercontent.com/etlegacy/etlegacy/master/misc/etmain/legacy.cfg -O legacy.cfg
        sudo sed -i 's#set sv_hostname "ET: Legacy Host"#set sv_hostname '\"${sv_hostname}\"'#' etl_server.cfg
        # check to see if custom port was set for server and set net_port cvar if so
        if [[ $net_port != "27960" ]]; then
            sudo sed -i 's#//set net_port "27960"#set net_port '\"${net_port}\"'#' etl_server.cfg
        fi            
        sudo sed -i 's#set g_password ""#set g_password '\"${g_password}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_maxclients "24"#set sv_maxclients '\"${sv_maxclients}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_privateclients "4"#set sv_privateclients '\"${sv_privateclients}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_privatepassword ""#set sv_privatepassword '\"${sv_privatepassword}\"'#' etl_server.cfg
        sudo sed -i 's#set rconpassword ""#set rconpassword '\"${rconpassword}\"'#' etl_server.cfg
        sudo sed -i 's#set refereePassword ""#set refereepassword '\"${refereepassword}\"'#' etl_server.cfg
        sudo sed -i 's#set shoutcastPassword ""#set ShoutcastPassword '\"${ShoutcastPassword}\"'#' etl_server.cfg
        sudo sed -i 's#set sv_wwwBaseURL ""#set sv_wwwBaseURL '\"${sv_wwwBaseURL}\"'#' etl_server.cfg
    fi

}

function downloadServerConfigs() {
  local current_dir=${1}
  
  echo -e "\nUpdating competition configurations and mapscripts..."
  cd ${current_dir}/legacy/
  sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip -O configs.zip
  unzip -q configs.zip
  sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/legacy/configs/
  sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/legacy/mapscripts/
  sudo rm -rf configs.zip
  sudo rm -rf Legacy-Competition-League-Configs-main/
  
  echo -e "\nConfiguration update complete..."
}

function setFilePermissions() {
    local current_dir=${1}
    local ftpuser=${2}

    echo "Setting permissions for installation..."
    sudo chown -R ${ftpuser}:${ftpuser} ${current_dir}
}

function runUpdate() {
    local install_dir=${1}
    local net_port=${2}
    local downloadLink=${3}

    echo -e "\nRunning Update..."
    # remove old pk3 before running update so correct version starts with service restart
    echo -e "\nRemoving previous version..."
    cd ${install_dir}/${net_port}/legacy/
    sudo rm -rf *.pk3
    cd ${install_dir}/
    sudo mkdir -p etupdate/
    echo "Downloading setup files..."
    sudo wget ${downloadLink} -O etlegacy-server-update.tar.gz
    sudo tar -xf etlegacy-server-update.tar.gz -C ${install_dir}/etupdate
    # account for old arch in builds previous to 2.80.2
    echo -e "\nMove old binaries if found..."
    sudo mv ${install_dir}/etupdate/et*/etl ${install_dir}/${net_port}/etl
    sudo mv ${install_dir}/etupdate/et*/etlded ${install_dir}/${net_port}/etlded
    echo -e "\nCopying new binaries..."
    # account for new arch in builds after to 2.80.2
    sudo mv ${install_dir}/etupdate/et*/etl.x86_64 ${install_dir}/${net_port}/etl.x86_64
    sudo mv ${install_dir}/etupdate/et*/etlded.x86_64 ${install_dir}/${net_port}/etlded.x86_64
    # move other game files and paks
    echo -e "\nInstall new version contents..."
    sudo mv ${install_dir}/etupdate/et*/librenderer_opengl1_x86_64.so ${install_dir}/${net_port}/librenderer_opengl1_x86_64.so
    sudo mv ${install_dir}/etupdate/et*/legacy/*.pk3 ${install_dir}/${net_port}/legacy/
    sudo mv ${install_dir}/etupdate/et*/legacy/qagame.mp.x86_64.so ${install_dir}/${net_port}/legacy/
    sudo mv ${install_dir}/etupdate/et*/legacy/GeoIP.dat ${install_dir}/${net_port}/legacy/
    echo -e "\nCleanup temporary files..."
    sudo rm -rf ${install_dir}/etupdate/
    sudo rm -rf ${install_dir}/etlegacy-server-update.tar.gz
}


# update a server instance
function updateGameServer() {
    local installtype=${1}
    local install_dir=${2}
    local net_port=${3}
    local downloadLink=${4}
    local ftpuser=${5}
    
    if ![[ installtype == "comp"]]; then
        echo -e "\nUpdate process for Competition server starting..."
        runUpdate "${install_dir}" "${net_port}" "${downloadLink}"
        downloadServerConfigs
    else
        echo -e "\nUpdate process for Public server is starting..."
        runUpdate "${install_dir}" "${net_port}" "${downloadLink}"
    fi

    setFilePermissions "${install_dir}" "${ftpuser}"
    
    # restart VSFTP after permissions change
    sudo systemctl restart vsftpd
    
    # restart server service and check status
    echo -e "\nRestarting ET: Legacy Server service for server on port $net_port."
    sudo systemctl stop etlserver-$net_port.service
    sudo systemctl start etlserver-$net_port.service
    sudo systemctl status etlserver-$net_port.service
    echo -e "\n${BGreen}The server located at ${Color_Off}${BCyan}$install_dir/$net_port/${Color_Off}${BGreen} has been successfully updated${Color_Off}${BWhite}...${Color_Off}"
}

# remove ETL Server instance
function removeETLServer() {
    local current_dir=${1}
    local net_port=${2}

    echo -e "Starting removal of server located on port $net_port...\n"
    echo -e ".......................................................\n"
    sudo rm -rf ${current_dir}/${net_port}
    
    sudo systemctl stop etlserver-$net_port.service
    sudo systemctl stop etlmonitor-$net_port.timer
    sudo rm /etc/systemd/system/etlserver-$net_port.service
    sudo rm /etc/systemd/system/etlrestart-$net_port.service
    sudo rm /etc/systemd/system/etlmonitor-$net_port.timer
    sudo systemctl daemon-reload

    echo -e "\n$(ColorBGreen 'The server found at') ${BCyan}$install_dir${Color_Off}${BWhite}/${Color_Off}${BCyan}$net_port${Color_Off}${BWhite}/${Color_Off} $(ColorBGreen 'and associated system services have been successfully uninstalled.')"
}

# installation of maps for ETL
function installMaps() {
    local current_dir=${1}
    
    cd ${current_dir}/${net_port}/etmain/
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/adlernest.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_adlernest_v4.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/badplace4_rc.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_bergen_v9.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/braundorf_b4.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/bremen_b3.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/crevasse_b3.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/ctf_multi.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/decay_sw.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/element_b4_1.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/erdenberg_t2.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_beach.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_brewdog_b6.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_headshot.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_headshot2_b2.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_ice.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_ice_v12.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_ufo_final.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/frostbite.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_frostbite_v17.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/karsiah_te2.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/missile_b3.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/mp_sillyctf.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/osiris_final.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/reactor_final.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/rifletennis_te.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/rifletennis_te2.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sos_secret_weapon.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sp_delivery_te.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_sp_delivery_v5.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/supply.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/etl_supply_v12.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_battery.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_goldrush_te.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_oasis_b3.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/tc_base.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/te_escape2.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/te_escape2_fixed.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/te_valhalla.pk3
    sudo wget http://moestavern.site.nfoservers.com/downloads/et/etmain/venice_ne4.pk3
}

# downloads and places the start script for ETL which includes game path, port, etc.
function configureStartScript() {
    local current_dir=${1}
    local net_port=${2}

    cd ${current_dir}/${net_port}/
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etl_start.sh -O etl_start.sh
    sudo chmod +x ${current_dir}/${net_port}/etl_start.sh
    # check to see if custom port was set for the server and write it to start script if so
    if [[ $net_port != "27960" ]]; then
            sudo sed -i 's#    +set net_port 27960#    +set net_port '${net_port}'#' etl_start.sh
    fi   
}

# downloads and places the systemd linux service that runs ETL.  Stop, Stop, Restart, and enabled on Startup.
function configureETServices() {
    local current_dir=${1}
    local net_port=${2}
    local restart_time=${3}

    if ![[ restart_time == ""]]; then
        restart_time="5:00:00"
    fi

    # create service file based on current install directory
    echo "Creating server service file"
    sudo cat > /etc/systemd/system/etlserver-${net_port}.service << EOF
[Unit]
Description=Wolfenstein Enemy Territory Server
After=network.target

[Service]
ExecStart=$current_dir/$net_port/etl_start.sh start
Restart=always

[Install]
WantedBy=network-up.target
EOF

    # create restart service file based on current install directory
    echo "Creating restart service file"
    sudo cat > /etc/systemd/system/etlrestart-${net_port}.service << EOF
[Unit]
Description=Restarts Enemy Territory Legacy server service

[Service]
ExecStart=/bin/systemctl restart etlserver-${net_port}.service
EOF

    # create service file based on current install directory
    echo "Creating server monitor timer file"
    sudo cat > /etc/systemd/system/etlmonitor-${net_port}.timer << EOF
[Unit]
Description=This timer restarts the Enemy Territory Legacy server service etlserver.service every day at 5am
Requires=etlrestart-$net_port.service

[Timer]
Unit=etlrestart-$net_port.service
OnCalendar=*-*-* $restart_time

[Install]
WantedBy=timers.target
EOF

    # reload systemctl daemon after service file creations
    sudo systemctl daemon-reload
    # enable server service and timer to run at system startup
    sudo systemctl enable etlserver-$net_port.service
    sudo systemctl enable etlmonitor-$net_port.timer
    # start server monitor timer
    sudo systemctl start etlmonitor-$net_port.timer
}

# Add the new user account for FTP access
function addUserAccount() {
    # variable to store user input
    local username=${1}
    # create new user account from input
    sudo useradd "${username}"
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    setFTPUserPass "${username}"
    echo "Setting up user account for FTP access"
    # disable new user from being able to ssh into the server
    sudo echo "DenyUsers ${username}" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl restart sshd
}

function setFTPUserPass() {
    # variable to store user input
    local username=${1}
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    sudo passwd "${username}"
}

function removeFTPUser() {
    # variable to store user input
    local username=${1}
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    sudo deluser "${username}"
}

# installs and configures VSFTPD
function configureVSFTP() {
    local current_dir=${1}

    sudo apt install -y vsftpd
    cd ${current_dir}/${net_port}/
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/vsftpd.conf
    yes | sudo mv vsftpd.conf /etc/vsftpd.conf
    # set FTP permissions for new user
    sudo usermod -d ${current_dir}/${net_port}/ "${username}"
    sudo chown -R "${username}":"${username}" ${current_dir}
    sudo chown root:root /etc/vsftpd.conf
    sudo systemctl restart vsftpd
}

# configures the firewall for FTP and ETL
function configureUFW() {
    sudo ufw allow 20/tcp
    sudo ufw allow 21/tcp
    sudo ufw allow OpenSSH
    sudo ufw allow 40000:50000/tcp
    sudo ufw allow 990/tcp
    sudo ufw allow 27960/udp
    yes | sudo ufw enable
}

