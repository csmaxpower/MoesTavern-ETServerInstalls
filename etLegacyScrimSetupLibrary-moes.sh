#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimSetupLibrary-moes.sh

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
    local servername=${1}
    local g_password=${2}
    local sv_privateclients=${3}
    local sv_privatepassword=${4}
    local rconpassword=${5}
    local refereepassword=${6}
    local ShoutcastPassword=${7}
    local sv_wwwBaseURL=${8}
    local downloadLink=${9}
    local current_dir=${10}
    local g_maxclients=${11}
    local legacy1_lua="luascripts/game-stats-web.lua"
    local legacy3_lua="luascripts/game-stats-web.lua"
    local legacy3_snaps_lua="luascripts/game-stats-web.lua"
    local legacy5_lua="luascripts/game-stats-web.lua"
    local legacy6_lua="luascripts/game-stats-web.lua"
    local practice_lua="luascripts/game-stats-web.lua"

    sudo mkdir -p ${current_dir}/et/
    sudo mkdir -p ${current_dir}/tmp/etsetup
    cd ${current_dir}/tmp/etsetup
    sudo wget ${downloadLink} -O etlegacy-server-install.sh
    sudo chmod +x etlegacy-server-install.sh
    yes | ./etlegacy-server-install.sh
    sudo mv etlegacy-v*/* ${current_dir}/et/
    cd ${current_dir}/et/
    rm -rf ${current_dir}/tmp/etsetup
    cd legacy/
    sudo mkdir configs/
    sudo mkdir mapscripts/
    sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
    unzip main.zip
    sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/et/legacy/configs/
    sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/et/legacy/mapscripts/
    sudo mv Legacy-Competition-League-Configs-main/etl_server_comp.cfg ${current_dir}/et/etmain/etl_server.cfg
    sudo rm -rf main.zip
    sudo rm -rf Legacy-Competition-League-Configs-main/
    cd ${current_dir}/et/legacy/configs/
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy1_lua}\"'#' legacy1.config
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy3_lua}\"'#' legacy3.config
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy3_snaps_lua}\"'#' legacy3-snaps.config
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy5_lua}\"'#' legacy5.config
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy6_lua}\"'#' legacy6.config
    sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${practice_lua}\"'#' practice.config
    cd ${current_dir}/et/etmain/    
    sudo sed -i 's#set sv_hostname  			     ""#set sv_hostname '\"${g_servername}\"'#' etl_server.cfg
    sudo sed -i 's#set g_password				    ""#set g_password '\"${g_password}\"'#' etl_server.cfg
    sudo sed -i 's#set sv_maxclients 			  ""#set g_maxclients '\"${g_maxclients}\"'#' etl_server.cfg
    sudo sed -i 's#set sv_privateclients   	"0"#set sv_privateclients '\"${sv_privateclients}\"'#' etl_server.cfg
    sudo sed -i 's#set sv_privatepassword  	""#set sv_privatepassword '\"${sv_privatepassword}\"'#' etl_server.cfg
    sudo sed -i 's#set rconpassword			    ""#set rconpassword '\"${rconpassword}\"'#' etl_server.cfg
    sudo sed -i 's#set refereePassword 		  ""#set refereepassword '\"${refereepassword}\"'#' etl_server.cfg
    sudo sed -i 's#set ShoutcastPassword		  ""#set ShoutcastPassword '\"${ShoutcastPassword}\"'#' etl_server.cfg
    sudo sed -i 's#set sv_wwwBaseURL 			   ""#set sv_wwwBaseURL '\"${sv_wwwBaseURL}\"'#' etl_server.cfg
    sudo sed -i 's#set sv_hidden "1"#set sv_hidden '\"0\"'#' etl_server.cfg
    cd ..
}

# installation of maps for ETL
function installMaps() {
    cd etmain/
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
    cd ..
}

# downloads and places the start script for ETL which includes game path, port, etc.
function configureStartScript() {
    local current_dir=${1}

    cd ${current_dir}/et/
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/etl_start.sh
    sudo chmod +x ${current_dir}/et/etl_start.sh
}

# downloads and places the systemd linux service that runs ETL.  Stop, Stop, Restart, and enabled on Startup.
function configureETServices() {
    local current_dir=${1}

    # old logic for service file download and creation
    #cd ${current_dir}/et/
    # check current directory to download correct server service configuration
    #if [["${current_dir}" == *"moesroot"*]]; then
      #sudo wget http://moestavern.site.nfoservers.com/downloads/server/etlserverazure.service
      #sudo mv etlserverazure.service /etc/systemd/system/etlserver.service
    #fi
      #sudo wget http://moestavern.site.nfoservers.com/downloads/server/etlservergeneral.service
      #sudo mv etlservergeneral.service /etc/systemd/system/etlserver.service
    

    # create service file based on current install directory
    echo "Creating service file"
    sudo cat > /etc/systemd/system/etlserver.service << EOF
[Unit]
Description=Wolfenstein Enemy Territory Server
After=network.target

[Service]
ExecStart=$current_dir/et/etl_start.sh start
Restart=always

[Install]
WantedBy=network-up.target
EOF

    sudo wget http://moestavern.site.nfoservers.com/downloads/server/etlrestart.service
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/etlmonitor.timer
    sudo mv etlrestart.service /etc/systemd/system/etlrestart.service
    sudo mv etlmonitor.timer /etc/systemd/system/etlmonitor.timer
    sudo systemctl daemon-reload
    sudo systemctl enable etlserver.service
    sudo systemctl enable etlmonitor.timer
    sudo systemctl start etlmonitor.timer
}

# Add the new user account for FTP access
# Arguments:
#   Account Username
function addUserAccount() {
    # variable to store user input
    local username=${1}
    # create new user account from input
    sudo useradd "${username}"
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    setFTPUserPass "${username}"
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

# installs and configures VSFTPD
function configureVSFTP() {
    local current_dir=${1}

    sudo apt install -y vsftpd
    cd ${current_dir}/et/
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/vsftpd.conf
    yes | sudo mv vsftpd.conf /etc/vsftpd.conf
    # set FTP permissions for new user
    sudo usermod -d ${current_dir}/et/ "${username}"
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
