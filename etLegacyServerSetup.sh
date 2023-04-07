#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimServerSetup.sh

set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacySetupLibrary.sh"
}

# Color  Variables
red="\e[31m"
green="\e[32m"
blue="\e[34m"
clear="\e[0m"

# Color Functions
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}
ColorRed(){
	echo -ne $red$1$clear
}


current_dir=$(getCurrentDir)
includeDependencies

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
    if [[ $installtype == "comp" ]]; then
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
    echo 'Setting up user account for FTP access'
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
    configureStartScript "${installDir}" "${net_port}"
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
    sudo systemctl status etlserver-$net_port.service
    if [[ $installtype == "comp" ]]; then
        echo -e "\nSetup Complete and the server $servername has been started with competition settings.\n\nYou may now quit the installer or install another server instance on a different port.\n"
    else
        echo -e "\nSetup Complete and the server $servername has been started with public settings.\n\nYou may now quit the installer or install another server instance on a different port.\n"
    fi
}

function uninstallMenu() {
    local installtype=${1}

    # capture desired UDP port of server to delete
    read -rp "Enter the root installation directory of your servers (e.g. /home/username):" install_dir
    # capture desired UDP port of server to delete
    read -rp "Enter the UDP Port # for server you wish to uninstall (e.g. 27960):" net_port
    echo -e "\nYou have chosen to uninstall server found at $install_dir/$net_port/."
    read -p "Do you want to proceed? (y/n) " yn

    case $yn in 
        [yY] ) removeETLServer $install_dir $net_port;;
        [nN] ) echo Returning to main menu...;
            exit;;
        * ) echo $red"invalid response"$clear; uninstallMenu;
            exit 1;;
    esac

    echo -e "\nThe server found at $install_dir/$net_port/ and associated system services have been successfully uninstalled."
    
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
    sudo systemctl status etlserver-$net_port.service
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

function main() {

echo -ne "
Enemy Territory: Legacy Server Installion
$(ColorGreen '1)') Install Competition Server
$(ColorGreen '2)') Install Public Server
$(ColorGreen '3)') Check Server Status
$(ColorGreen '4)') List Installed Servers
$(ColorGreen '5)') Create New FTP User
$(ColorGreen '6)') Change a FTP User Password
$(ColorGreen '7)') Change Daily Restart Time
$(ColorRed '8)') Remove a FTP User
$(ColorRed '9)') Uninstall a Server
$(ColorGreen '0)') Exit
$(ColorBlue 'Please choose an option: ')"

    read a
    case $a in
	    1) runInstall "comp" ; main ;;
	    2) runInstall "pub" ; main ;;
        3) checkServerStatus ; main ;;
        4) listServers ; main ;;
        5) addUserAccountMenu ; main ;;
        6) changeUserPassMenu ; main ;;
        7) changeRestartTime ; main ;;
        8) removeFTPUserMenu ; main ;;
        9) uninstallMenu "del" ; main ;;
	    0) exit 0 ;;
	    *) echo -e $red"That is not an option."$clear; main;;
    esac
    
}

main
