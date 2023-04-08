#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimServerSetup.sh

#set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacySetupLibrary.sh"
}

current_dir=$(getCurrentDir)
includeDependencies

# Color  Variables
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Reset
Color_Off='\033[0m'       # Text Reset

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Color Functions
ColorGreen(){
	echo -ne $Green$1$Color_Off
}
ColorBGreen(){
	echo -ne $BGreen$1$Color_Off
}
ColorBlue(){
	echo -ne $Blue$1$Color_Off
}
ColorPurple(){
	echo -ne $Purple$1$Color_Off
}
ColorRed(){
	echo -ne $Red$1$Color_Off
}
ColorBRed(){
	echo -ne $BRed$1$Color_Off
}
ColorCyan(){
	echo -ne $Cyan$1$Color_Off
}
ColorBCyan(){
	echo -ne $BCyan$1$Color_Off
}

function runInstall() {
    local installtype=${1}

    # capture desired name of the server
    read -rp "Enter the Server Name (can be with color):" sv_hostname
    # capture desired UDP port of server
    read -rp "Enter the UDP Port # for server to run on (Default: 27960):" net_port
    # capture desired number of maximum clients
    read -rp "Enter the number of maximum client slots:" sv_maxclients
    # capture desired number of private clients
    read -rp "Enter the number of private slots to be reserved:" sv_privateclients
    # set game password if installation type is competition
    if [ $installtype == "comp" ]; then
        # capture desired password for server
        read -rp "Set the game password:" g_password
    else
        g_password=""
    fi
    # capture desired private slot password
    read -rp "Set the private slot password:" sv_privatepassword
    # capture desired RCON password
    read -rp "Set the RCON Password:" rconpassword
    # capture desired ref password
    read -rp "Set the Referee Password:" refereepassword
    # capture desired ref password
    read -rp "Set the Shoutcast Password:" ShoutcastPassword
    # capture desired redirect and file download URL
    read -rp "Set the URL for file downloads and redirect:" sv_wwwBaseURL
    # capture desired installer download URL
    read -rp "Set the URL for current version installer download (.sh):" downloadLink
    # capture desired install directory
    read -rp "Set the installation directory (e.g. /home/username):" installDir
    # capture desired restart time
    read -rp "Enter the time of day for automatic restart (e.g. hh:mm:ss / 5am = 05:00:00):" restart_time
    # capture desired username
    read -rp "Enter a username for FTP access:" username
    echo -e "Setting up user account for FTP access"
    addUserAccount "${username}"
    # Updating server packages
    echo 'Updating server packages'
    updateServer
    echo 'Installing needed software'
    installUnzip
    echo 'Installing Enemy Territory Legacy Server'
    installET "${installtype}" "${sv_hostname}" "${g_password}" "${sv_privateclients}" "${sv_privatepassword}" "${rconpassword}" "${refereepassword}" "${ShoutcastPassword}" "${sv_wwwBaseURL}" "${downloadLink}" "${installDir}" "${sv_maxclients}" "${net_port}"
    echo 'Downloading maps'
    echo "$installDir"
    installMaps "${installDir}"
    echo 'Setting up start script for server'
    configureStartScript "${installDir}" "${net_port}" "${installtype}"
    echo 'Setting up system service for Enemy Territory Legacy'
    configureETServices "${installDir}" "${net_port}" "${restart_time}"
    # install VSFTP
    echo 'Installing and configuring VSFTPD'
    configureVSFTP "${installDir}"
    # configure firewall rules and enable firewall for access
    echo -e "Configuring firewall rules for Enemy Territory and FTP access"
    configureUFW
    echo -e "\nStarting Enemy Territory Server...\n"
    sudo systemctl start etlserver-$net_port.service
    sudo systemctl start etlmonitor-$net_port.timer
    echo -e "\nChecking server status...\n"
    sudo systemctl status etlserver-$net_port.service --lines=0 --no-pager --full

    echo -e "\n${BGreen}Setup Complete and the server at${Color_Off} ${BCyan}$installDir/$net_port${Color_Off} ${BGreen}has been started.${Color_Off}\n\n${BYellow}You may now quit the installer or install another server instance on a different port.${Color_Off}\n"
    
}

function uninstallInfo() {
    # capture desired UDP port of server to delete
    read -rp "Enter the root installation directory of your servers (e.g. /home/username):" install_dir
    # capture desired UDP port of server to delete
    read -rp "Enter the UDP Port # for server you wish to uninstall (e.g. 27960):" net_port
    # send info to uninstall procedure
    uninstallMenu "${install_dir}" "${net_port}"
}

function uninstallMenu() {
    local install_dir=${1}
    local net_port=${2}

    echo -e "\nYou have chosen to uninstall server found at $install_dir/$net_port/"
    read -p "$(ColorRed 'Do you want to proceed?') (y/n) " yn

    case $yn in 
        [yY] ) removeETLServer $install_dir $net_port;;
        [nN] ) echo Returning to main menu...; main;;
        *) echo -e "\n$(ColorRed 'Invalid option selected.')"; uninstallMenu $install_dir $net_port;;
    esac    
}

function installMenu() {
    echo -ne "

\n${BWhite}ET: ${Color_Off}${BRed}Legacy${Color_Off}${BWhite} Installation Menu${Color_Off}\n
$(ColorBGreen '1)') Install ${IWhite}Competition${Color_Off} Server
$(ColorBGreen '2)') Install ${IWhite}Public${Color_Off} Server
$(ColorBGreen '3)') Check Server Status
$(ColorBGreen '4)') List Installed Servers
$(ColorBCyan '0)') Main Menu
\n${BYellow}Please choose an option: ${Color_Off}"

    read a
    case $a in
	    1) runInstall "comp" ; installMenu ;;
	    2) runInstall "pub" ; installMenu ;;
        3) checkServerStatus ; installMenu ;;
        4) listServers ; installMenu ;;
	    0) main ;;
	    *) echo -e $red"Invalid option selected."$clear; main;;
    esac
    
}

function addUserAccountMenu() {

    # capture desired username to create
    read -rp "Enter a username for FTP access:" username
    addUserAccount "${username}"
    
}

function changeUserPassMenu() {
    
    # capture desired username for password change
    read -rp "Enter a username for FTP access:" username
    setFTPUserPass "${username}"
    
}

function removeFTPUserMenu() {
    
    # capture desired username to delete
    read -rp "Enter the FTP username to be deleted:" username
    removeFTPUser "${username}"
    echo -e "\nThe FTP user $username has been deleted."
}

function checkServerStatus() {
    
    # capture desired username to delete
    read -rp "Enter the port number for server:" net_port
    sudo systemctl status etlserver-$net_port.service --lines=0 --no-pager --full
    echo -e "\nReturing to main menu..."
}

function listServers() {
    
    # capture desired username to delete
    echo -e "\nThe following server services were found:\n"
    sudo ls -l /etc/systemd/system/etlserver-*.service
    
}

function changeRestartTime() {
    
    # capture desired UDP port of server
    read -rp "Enter the net_port # for the server to change the restart time on (e.g. 27960):" net_port
    # capture desired restart time
    read -rp "Enter the time of day for automatic restart (e.g. hh:mm:ss / 5am = 05:00:00):" restart_time
    # stop old timer and remove so new can be created with desired restart time
    echo -e "\nStopping current timer for server on port: $net_port..."
    echo -e "\nRemoving current timer for server on port: $net_port from system..."
    sudo rm /etc/systemd/system/etlmonitor-$net_port.timer
    sudo systemctl daemon-reload
    # create service file based on new restart time
    echo -e "\nCreating new server monitor timer..."
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
    # reload systemctl daemon to grab new timer
    echo -e "\nReloading systemctl daemon..."
    sudo systemctl daemon-reload
    sudo systemctl enable etlmonitor-$net_port.timer
    # start server monitor timer
    sudo systemctl start etlmonitor-$net_port.timer
    echo -e "\nThe restart time for the server on port $net_port has been changed to $restart_time."
    sudo systemctl status etlmonitor-$net_port.timer
    echo -e "\n"
}



function updateServerInfo () {
    local installtype=${1}

    # capture desired install directory
    read -rp "Enter the installation directory of the server to update (e.g. /home/username):" installDir
    # capture desired UDP port of server
    read -rp "Enter the ${BWhite}net_port${Clear_Off} # for the server to update (e.g. 27960):" net_port
    # capture desired install directory
    read -rp "Enter the FTP username used to manage server (e.g. moesftpuser):" ftpuser
    # capture desired update download URL
    read -rp "Set the URL for current version installer download (.tar.gz):" downloadLink

    if [ installtype == "comp"]; then
        updateGameServer "comp" "${installDir}" "${net_port}" "${downloadLink}" "${ftpuser}"
    else
        updateGameServer "pub" "${installDir}" "${net_port}" "${downloadLink}" "${ftpuser}"
    fi
  
}


function updateServerMenu () {

echo -ne "
\n${BWhite}ET: ${Color_Off}${BRed}Legacy${Color_Off}${BWhite} Update Menu${Color_Off}\n
$(ColorBGreen '1)') Update ${IWhite}Competition${Color_Off} Server
$(ColorBGreen '2)') Update ${IWhite}Public${Color_Off} Server
$(ColorBGreen '3)') Check Server Status
$(ColorBGreen '4)') List Installed Servers
$(ColorBCyan '0)') Main Menu
\n${BYellow}Please choose an option: ${Color_Off}"

    read a
    case $a in
	    1) updateServerInfo "comp" ; updateServerMenu ;;
	    2) updateServerInfo "pub" ; updateServerMenu ;;
        3) checkServerStatus ; updateServerMenu ;;
        4) listServers ; updateServerMenu ;;
	    0) main ;;
	    *) echo -e $red"Invalid option selected."$clear; main;;
    esac    
}

function main() {

echo -ne "
${Purple}Moes Tavern Gaming${Color_Off}
\n${BWhite}ET:${Color_Off} ${BRed}Legacy${Color_Off}${BWhite} - Server Manager\n
$(ColorBGreen '1)') Install a Server
$(ColorBGreen '2)') Update a Server
$(ColorBGreen '3)') Check Server Status
$(ColorBGreen '4)') List Installed Servers
$(ColorBGreen '5)') Create New FTP User
$(ColorBGreen '6)') Change an FTP User Password
$(ColorBGreen '7)') Change Daily Restart Time
$(ColorBRed '8)') Remove an FTP User
$(ColorBRed '9)') Uninstall a Server
$(ColorBCyan '0)') Exit
\n${BYellow}Please choose an option: ${Color_Off}"

    read a
    case $a in
	    1) installMenu ; main ;;
        2) updateServerMenu ; main ;;
        3) checkServerStatus ; main ;;
        4) listServers ; main ;;
        5) addUserAccountMenu ; main ;;
        6) changeUserPassMenu ; main ;;
        7) changeRestartTime ; main ;;
        8) removeFTPUserMenu ; main ;;
        9) uninstallInfo ; main ;;
	    0) exit 0 ;;
	    *) echo -e $red"Invalid option selected."$clear; main;;
    esac
    
}

main