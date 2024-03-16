#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimSetupLibrary.sh


# needed to colorize text uneedfully
function installLOLcat() {
    if command -v lolcat > /dev/null 2>&1; then
        sudo apt -y update
        sudo apt-get install -y -q lolcat
    else
        sudo echo -e "Starting Main Menu..." | /usr/games/lolcat -S 39
    fi
}

# needed to extract compressed Files
function installUnzip() {
    sudo apt-get install -y unzip | /usr/games/lolcat -S 39
}

# Update the server
function updateServer() {
    sudo apt -y update | /usr/games/lolcat -S 39
    sudo apt -y upgrade | /usr/games/lolcat -S 39
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
    sudo wget ${downloadLink} -q --show-progress -O etlegacy-server-install.sh
    sudo chmod +x etlegacy-server-install.sh
    yes | sudo ./etlegacy-server-install.sh --prefix=$current_dir/$net_port --exclude-subdir --skip-license | /usr/games/lolcat -S 39
    #sudo mv etlegacy-v*/* ${current_dir}/${net_port}/
    rm -rf ${current_dir}/tmp/etsetup
    # download main assets to etmain
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Download main assets to${Color_Off} ${BCyan}/etmain${Color_Off}${BWhite} -------${Color_Off}"
    sudo wget https://mirror.etlegacy.com/etmain/pak0.pk3 -q --show-progress -O ${current_dir}/${net_port}/etmain/pak0.pk3
    sudo wget https://mirror.etlegacy.com/etmain/pak1.pk3 -q --show-progress -O ${current_dir}/${net_port}/etmain/pak1.pk3
    sudo wget https://mirror.etlegacy.com/etmain/pak2.pk3 -q --show-progress -O ${current_dir}/${net_port}/etmain/pak2.pk3

    if [ $installtype == "comp" ]; then
        echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Starting competition configuration${Color_Off}${BWhite} -------${Color_Off}"
        cd ${current_dir}/${net_port}/legacy/
        sudo mkdir configs/
        sudo mkdir mapscripts/
        sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip -q --show-progress -O main.zip
        unzip main.zip | /usr/games/lolcat -S 39
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
        echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Starting public configuration${Color_Off}${BWhite} -------${Color_Off}"
        cd ${current_dir}/${net_port}/legacy/
        sudo mkdir configs/
        sudo mkdir mapscripts/
        # get up to date and best map-scripts from competition repository
        sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip -q --show-progress -O main.zip
        unzip main.zip | /usr/games/lolcat -S 39
        sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/${net_port}/legacy/mapscripts/
        sudo rm -rf main.zip
        sudo rm -rf Legacy-Competition-League-Configs-main/
        cd ${current_dir}/${net_port}/etmain/   
        sudo wget https://raw.githubusercontent.com/etlegacy/etlegacy/master/misc/etmain/etl_server.cfg -q --show-progress -O etl_server.cfg
        sudo wget https://raw.githubusercontent.com/etlegacy/etlegacy/master/misc/etmain/legacy.cfg -q --show-progress -O legacy.cfg
        sudo sed -i 's#set sv_hostname "ET: Legacy Host"#set sv_hostname '\"${sv_hostname}\"'#' etl_server.cfg
        # check to see if custom port was set for server and set net_port cvar if so
        if [ $net_port != "27960" ]; then
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
  
  echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Updating competition configurations and mapscripts${Color_Off}${BWhite} -------${Color_Off}"
  cd ${current_dir}/legacy/
  sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip -q --show-progress -O configs.zip
  unzip -q configs.zip | /usr/games/lolcat -S 39
  sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/legacy/configs/
  sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/legacy/mapscripts/
  sudo rm -rf configs.zip
  sudo rm -rf Legacy-Competition-League-Configs-main/
  
  echo -e "\n${BGreen}Configuration update complete${Color_Off}${BWhite}!${Color_Off}"
}

function setFilePermissions() {
    local current_dir=${1}
    local ftpuser=${2}

    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Setting permissions for installation${Color_Off}${BWhite} -------${Color_Off}"
    sudo chown -R ${ftpuser}:${ftpuser} ${current_dir}
}

function runUpdate() {
    local install_dir=${1}
    local net_port=${2}
    local downloadLink=${3}

    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Running Update${Color_Off}${BWhite} -------${Color_Off}"
    # remove old pk3 before running update so correct version starts with service restart
    echo -e "\n${BRed}Removing previous version${Color_Off}${BWhite}..................${Color_Off}"
    cd ${install_dir}/${net_port}/legacy/
    sudo rm -rf *.pk3
    cd ${install_dir}/
    sudo mkdir -p etupdate/
    echo "\n${BWhite}------- ${Color_Off}${BYellow}Downloading setup files${Color_Off}${BWhite} -------${Color_Off}"
    sudo wget ${downloadLink} -q --show-progress -O etlegacy-server-update.tar.gz
    sudo tar -xf etlegacy-server-update.tar.gz -C ${install_dir}/etupdate | /usr/games/lolcat -S 39
    # account for old arch in builds previous to 2.80.2
    echo -e "\n${BYellow}Move old binaries if found${Color_Off}${BWhite}..................${Color_Off}"
    sudo mv ${install_dir}/etupdate/et*/etl ${install_dir}/${net_port}/etl
    sudo mv ${install_dir}/etupdate/et*/etlded ${install_dir}/${net_port}/etlded
    echo -e "\n${BGreen}Copying new binaries${Color_Off}${BWhite}..................${Color_Off}"
    # account for new arch in builds after to 2.80.2
    sudo mv ${install_dir}/etupdate/et*/etl.x86_64 ${install_dir}/${net_port}/etl.x86_64
    sudo mv ${install_dir}/etupdate/et*/etlded.x86_64 ${install_dir}/${net_port}/etlded.x86_64
    # move other game files and paks
    echo -e "\n${BGreen}Install new version contents${Color_Off}${BWhite}..................${Color_Off}"
    sudo mv ${install_dir}/etupdate/et*/librenderer_opengl1_x86_64.so ${install_dir}/${net_port}/librenderer_opengl1_x86_64.so
    sudo mv ${install_dir}/etupdate/et*/legacy/*.pk3 ${install_dir}/${net_port}/legacy/
    sudo mv ${install_dir}/etupdate/et*/legacy/qagame.mp.x86_64.so ${install_dir}/${net_port}/legacy/
    sudo mv ${install_dir}/etupdate/et*/legacy/GeoIP.dat ${install_dir}/${net_port}/legacy/
    echo -e "\n${BRed}Cleanup temporary files${Color_Off}${BWhite}..................${Color_Off}"
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
    
    if [ $installtype == "comp"]; then
        echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Update process for Competition server starting${Color_Off}${BWhite} -------${Color_Off}"
        runUpdate "${install_dir}" "${net_port}" "${downloadLink}"
        downloadServerConfigs
    else
        echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Update process for Public server is starting${Color_Off}${BWhite} -------${Color_Off}"
        runUpdate "${install_dir}" "${net_port}" "${downloadLink}"
    fi

    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Setting File Permissions${Color_Off}${BWhite} -------${Color_Off}"
    #setFilePermissions "${install_dir}" "${ftpuser}"
    
    # restart VSFTP after permissions change
    sudo systemctl restart vsftpd
    
    # restart server service and check status
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Restarting ${Color_Off}${BWhite}ET: ${Color_Off}${BRed}Legacy ${Color_Off}${BWhite}Server ${Color_Off}${BYellow}service for server on port ${Color_Off}${BCyan}$net_port${Color_Off}${BWhite} -------${Color_Off}"
    sudo systemctl stop etlserver-$net_port.service
    sudo systemctl start etlserver-$net_port.service
    sudo systemctl status etlserver-$net_port.service --lines=0
    echo -e "\n${BGreen}The server located at ${Color_Off}${BCyan}$install_dir/$net_port/${Color_Off}${BGreen} has been successfully updated${Color_Off}${BWhite}!${Color_Off}"
}

# remove ETL Server instance
function removeETLServer() {
    local current_dir=${1}
    local net_port=${2}

    echo -e "${BRed}Starting removal of server located on port ${Color_Off}${BYellow}$net_port${Color_Off}${BWhite}...${Color_Off}\n"
    echo -e "${BWhite}..........................................................................................${Color_Off}\n"
    sudo rm -rf ${current_dir}/${net_port}
    
    sudo systemctl stop etlserver-$net_port.service
    sudo systemctl stop etlmonitor-$net_port.timer
    sudo rm /etc/systemd/system/etlserver-$net_port.service
    sudo rm /etc/systemd/system/etlrestart-$net_port.service
    sudo rm /etc/systemd/system/etlmonitor-$net_port.timer
    sudo systemctl daemon-reload

    echo -e "\n${BGreen}The server found at${Color_Off} ${BCyan}$install_dir${Color_Off}${BWhite}/${Color_Off}${BCyan}$net_port${Color_Off}${BWhite}/${Color_Off} ${BGreen}and associated system services have been successfully uninstalled${Color_Off}${BWhite}!${Color_Off}"
}

# installation of maps for ETL
function installMaps() {
    local current_dir=${1}
    
    cd ${current_dir}/${net_port}/etmain/
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/adlernest.pk3 -q --show-progress -O adlernest.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_adlernest_v4.pk3 -q --show-progress -O etl_adlernest_v4.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/badplace4_rc.pk3 -q --show-progress -O badplace4_rc.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_bergen_v9.pk3 -q --show-progress -O etl_bergen_v9.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/braundorf_b4.pk3 -q --show-progress -O braundorf_b4.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/bremen_b3.pk3 -q --show-progress -O bremen_b3.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/crevasse_b3.pk3 -q --show-progress -O crevasse_b3.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/ctf_multi.pk3 -q --show-progress -O ctf_multi.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/decay_sw.pk3 -q --show-progress -O decay_sw.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/element_b4_1.pk3 -q --show-progress -O element_b4_1.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/erdenberg_t2.pk3 -q --show-progress -O erdenberg_t2.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_beach.pk3 -q --show-progress -O et_beach.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_brewdog_b6.pk3 -q --show-progress -O et_brewdog_b6.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_headshot.pk3 -q --show-progress -O et_headshot.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_headshot2_b2.pk3 -q --show-progress -O et_headshot2_b2.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_ice.pk3 -q --show-progress -O et_ice.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_ice_v12.pk3 -q --show-progress -O etl_ice_v12.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/et_ufo_final.pk3 -q --show-progress -O et_ufo_final.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/frostbite.pk3 -q --show-progress -O frostbite.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_frostbite_v17.pk3 -q --show-progress -O etl_frostbite_v17.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/karsiah_te2.pk3 -q --show-progress -O karsiah_te2.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/missile_b3.pk3 -q --show-progress -O missile_b3.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/mp_sillyctf.pk3 -q --show-progress -O mp_sillyctf.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/osiris_final.pk3 -q --show-progress -O osiris_final.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/reactor_final.pk3 -q --show-progress -O reactor_final.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/rifletennis_te.pk3 -q --show-progress -O rifletennis_te.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/rifletennis_te2.pk3 -q --show-progress -O rifletennis_te2.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/sos_secret_weapon.pk3 -q --show-progress -O sos_secret_weapon.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/sp_delivery_te.pk3 -q --show-progress -O sp_delivery_te.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_sp_delivery_v5.pk3 -q --show-progress -O etl_sp_delivery_v5.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/supply.pk3 -q --show-progress -O supply.pk3 etl_supply_v12.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/etl_supply_v12.pk3 -q --show-progress -O etl_supply_v12.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/sw_battery.pk3 -q --show-progress -O sw_battery.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/sw_goldrush_te.pk3 -q --show-progress -O sw_goldrush_te.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/sw_oasis_b3.pk3 -q --show-progress -O sw_oasis_b3.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/tc_base.pk3 -q --show-progress -O tc_base.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/te_escape2.pk3 -q --show-progress -O te_escape2.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/te_escape2_fixed.pk3 -q --show-progress -O te_escape2_fixed.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/te_valhalla.pk3 -q --show-progress -O te_valhalla.pk3
    sudo wget https://github.com/csmaxpower/MoesTavern-ETServerInstalls/raw/main/maps/venice_ne4.pk3 -q --show-progress -O venice_ne4.pk3
}

# downloads and places the start script for ETL which includes game path, port, etc.
function configureStartScript() {
    local current_dir=${1}
    local net_port=${2}
    local installtype=${3}

    cd ${current_dir}/${net_port}/
    echo -e "\n${BGreen}Downloading ${Color_Off}${BCYan}etl_start.sh${Color_Off}${BWhite}........${Color_Off}"
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etl_start.sh -q --show-progress -O etl_start.sh
    sudo chmod +x ${current_dir}/${net_port}/etl_start.sh
    # check to see if custom port was set for the server and write it to start script if so
    if [ $net_port != "27960" ]; then
            sudo sed -i 's#    +set net_port 27960#    +set net_port '${net_port}'#' etl_start.sh
    fi
    if [ $installtype == "pub" ]; then
            sudo sed -i 's#    +exec etl_server.cfg#    +exec etl_server.cfg \\#' etl_start.sh
            sudo sh -c 'echo "    +set omnibot_enable 1 \\" >> etl_start.sh'
            sudo sh -c 'echo "    +set omnibot_path \"\${DIR}/legacy/omni-bot\"" >> etl_start.sh'
    fi
}

# downloads and places the systemd linux service that runs ETL.  Stop, Stop, Restart, and enabled on Startup.
function configureETServices() {
    local current_dir=${1}
    local net_port=${2}
    local restart_time=${3}

    if [ -z "$restart_time" ]; then
        restart_time="5:00:00"
    fi

    # create service file based on current install directory
    echo -e "\n${BGreen}Creating server service file${Color_Off}${BWhite}...${Color_Off}"
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
    echo -e "\n${BGreen}Creating restart service file${Color_Off}${BWhite}...${Color_Off}"
    sudo cat > /etc/systemd/system/etlrestart-${net_port}.service << EOF
[Unit]
Description=Restarts Enemy Territory Legacy server service

[Service]
ExecStart=/bin/systemctl restart etlserver-${net_port}.service
EOF

    # create service file based on current install directory
    echo -e "\n${BGreen}Creating server monitor timer file${Color_Off}${BWhite}...${Color_Off}"
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
    sudo systemctl enable etlserver-$net_port.service | /usr/games/lolcat -S 39
    sudo systemctl enable etlmonitor-$net_port.timer | /usr/games/lolcat -S 39
    # start server monitor timer
    sudo systemctl start etlmonitor-$net_port.timer

}

# Add the new user account for FTP access
function addUserAccount() {
    # variable to store user input
    local username=${1}
    # create new user account from input
    sudo useradd "${username}" | /usr/games/lolcat -S 39
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    setFTPUserPass "${username}"
    echo -e "\n${BGreen}Setting up user account for FTP access${Color_Off}${BWhite}...${Color_Off}"
    # disable new user from being able to ssh into the server
    sudo echo "DenyUsers ${username}" | sudo tee -a /etc/ssh/sshd_config | /usr/games/lolcat -S 39
    sudo systemctl restart sshd
}

function setFTPUserPass() {
    # variable to store user input
    local username=${1}
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    sudo passwd "${username}" | /usr/games/lolcat -S 39
}

function removeFTPUser() {
    # variable to store user input
    local username=${1}
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    sudo deluser "${username}" | /usr/games/lolcat -S 39
}

# installs and configures VSFTPD
function configureVSFTP() {
    local current_dir=${1}

    if command -v vsftpd > /dev/null 2>&1; then
        sudo apt install -y vsftpd | /usr/games/lolcat -S 39
        cd ${current_dir}/${net_port}/
        sudo echo -e "\n${BYellow}Downloading VSFTP configuration file${Color_Off}${BWhite}...${Color_Off}\n"
        sudo wget http://moestavern.site.nfoservers.com/downloads/server/vsftpd.conf -q --show-progress -O vsftpd.conf
        yes | sudo mv vsftpd.conf /etc/vsftpd.conf
    fi
    # set FTP permissions for new user
    #sudo usermod -d ${current_dir}/${net_port}/ "${username}"
    #sudo chown -R "${username}":"${username}" ${current_dir}
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
    yes | sudo ufw enable | /usr/games/lolcat -S 39
}

