#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimServerSetup.sh

#set -e

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
function ColorGreen(){
	echo -ne $Green$1$Color_Off
}
function ColorBGreen(){
	echo -ne $BGreen$1$Color_Off
}
function ColorBlue(){
	echo -ne $Blue$1$Color_Off
}
function ColorPurple(){
	echo -ne $Purple$1$Color_Off
}
function ColorRed(){
	echo -ne $Red$1$Color_Off
}
function ColorBRed(){
	echo -ne $BRed$1$Color_Off
}
function ColorCyan(){
	echo -ne $Cyan$1$Color_Off
}
function ColorBCyan(){
	echo -ne $BCyan$1$Color_Off
}

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacySetupLibrary.sh"
}

function author() {
    sudo echo -e "\n"
    sudo echo -e "            ____ ___ _____ ____   _____  " | /usr/games/lolcat -S 27 
    sudo echo -e "           / __ \`__ \  __ \  _ \ _  __/ " | /usr/games/lolcat -S 27 
    sudo echo -e "          / / / / / / /_/ /  __/(__  ) _ " | /usr/games/lolcat -S 27 
    sudo echo -e "         /_/ /_/ /_/\____/\___//____/ (_)" | /usr/games/lolcat -S 27 
    sudo echo -e "               Moe's Tavern Gaming       " | /usr/games/lolcat -S 27
    sudo echo -e "\n\n\n\n"
}

function title() {
    sudo echo -e "${BWhite}_________________________________________________${Color_Off}"
    sudo echo -e "${BRed} _____ _____   ${Color_Off}${BWhite} _                                ${Color_Off}"
    sudo echo -e "${BRed}| ____|_   _|  ${Color_Off}${BWhite}| |    ___  __ _  __ _  ___ _   _ ${Color_Off}"
    sudo echo -e "${BRed}|  _|   | |(_) ${Color_Off}${BWhite}| |   / _ \/ _\` |/ _\` |/ __| | | |${Color_Off}"
    sudo echo -e "${BRed}| |___  | | _  ${Color_Off}${BWhite}| |__|  __/ (_| | (_| | (__| |_| |${Color_Off}"
    sudo echo -e "${BRed}|_____| |_|(_) ${Color_Off}${BWhite}|_____\___|\__, |\__,_|\___|\__, |${Color_Off}"
    sudo echo -e "${BRed}               ${Color_Off}${BWhite}            |___/            |___/${Color_Off}"
    sudo echo -e "${BWhite}_________________________________________________${Color_Off}"
    sudo echo -e "    ${BWhite}Server Installation Manager${Color_Off} ${BRed}Version${Color_Off} ${BWhite}3.0${Color_Off}       "
}

current_dir=$(getCurrentDir)
includeDependencies
installLOLcat
author
title

function runInstall() {
    local installtype=${1}

    # capture desired name of the server
    echo -ne "\n${BWhite}Enter the Server Name ${Color_Off}${BCyan}(can be with color)${Color_Off}${BWhite}: ${Color_Off}"
    read -r -n 26 "sv_hostname"
    # capture desired UDP port of server
    echo -ne "\n${BWhite}Enter the UDP Port # for server to run on ${Color_Off}${BCyan}(Default: 27960)${Color_Off}${BWhite}: ${Color_Off}"
    read -n 5 "net_port"
    # capture desired number of maximum clients
    echo -ne "\n${BWhite}Enter the number of maximum client slots: ${Color_Off}"
    read -n 2 "sv_maxclients"
    # capture desired number of private clients
    echo -ne "\n${BWhite}Enter the number of private slots to be reserved: ${Color_Off}"
    read -n 1 "sv_privateclients"
    # set game password if installation type is competition
    if [ $installtype == "comp" ]; then
        # capture desired password for server
        echo -ne "\n${BWhite}Set the game password: ${Color_Off}"
        read g_password 
    else
        g_password=""
    fi
    # capture desired private slot password
    echo -ne "\n${BWhite}Set the private slot password: ${Color_Off}" 
    read "sv_privatepassword"
    # capture desired RCON password
    echo -ne "\n${BWhite}Set the RCON Password: ${Color_Off}"
    read "rconpassword"
    # capture desired ref password
    echo -ne "\n${BWhite}Set the Referee Password: ${Color_Off}"
    read "refereepassword"
    # capture desired ref password
    echo -ne "\n${BWhite}Set the Shoutcast Password: ${Color_Off}"
    read "ShoutcastPassword" 
    # capture desired redirect and file download URL
    echo -ne "\n${BWhite}Set the URL for file downloads and redirect: ${Color_Off}"
    read "sv_wwwBaseURL"
    # capture desired installer download URL
    echo -ne "\n${BWhite}Set the URL for current version installer download ${Color_Off}${BCyan}(.sh)${Color_Off}${BWhite}: ${Color_Off}"
    read -r "downloadLink"
    # capture desired install directory
    echo -ne "\n${BWhite}Set the installation directory ${Color_Off}${BCyan}(e.g. /home/username)${Color_Off}${BWhite}: ${Color_Off}"
    read "installDir"
    # capture desired restart time
    echo -ne "\n${BWhite}Enter the time of day for automatic restart ${Color_Off}${BCyan}(e.g. hh:mm:ss / 5am = 05:00:00)${Color_Off}${BWhite}: ${Color_Off}"
    read -n 8 "restart_time"
    # capture desired username
    echo -ne "\n${BWhite}Enter a username for FTP access:  ${Color_Off}"
    read -n 32 "username"
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Setting up user account for ${BCyan}FTP${Color_Off} ${BYellow}access${Color_Off}${BWhite} -------${Color_Off}"
    echo -e "\n${BWhite}Please enter a password for ${Color_Off}${BCyan}$username${Color_Off}"
    addUserAccount "${username}"
    # Updating server packages
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Updating server packages${Color_Off}${BWhite} -------${Color_Off}"
    updateServer
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Installing needed software${Color_Off}${BWhite} -------${Color_Off}"
    installUnzip
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Installing ${Color_Off}${BWhite}ET:${Color_Off} ${BRed}Legacy${Color_Off} ${BWhite}Server${Color_Off}${BWhite} -------${Color_Off}"
    installET "${installtype}" "${sv_hostname}" "${g_password}" "${sv_privateclients}" "${sv_privatepassword}" "${rconpassword}" "${refereepassword}" "${ShoutcastPassword}" "${sv_wwwBaseURL}" "${downloadLink}" "${installDir}" "${sv_maxclients}" "${net_port}"
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Downloading maps${Color_Off}${BWhite} -------${Color_Off}"
    echo -e "$installDir"
    installMaps "${installDir}"
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Setting up start script for server${Color_Off}${BWhite} -------${Color_Off}"
    configureStartScript "${installDir}" "${net_port}" "${installtype}"
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Setting up system service for ${Color_Off}${BWhite}ET:${Color_Off} ${BRed}Legacy${Color_Off}${BWhite} -------${Color_Off}"
    configureETServices "${installDir}" "${net_port}" "${restart_time}"
    # install VSFTP
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Installing and configuring ${Color_Off}${BCyan}VSFTPD${Color_Off}${BWhite} -------${Color_Off}"
    configureVSFTP "${installDir}"
    # configure firewall rules and enable firewall for access
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Configuring firewall rules for ${Color_Off}${BWhite}ET:${Color_Off} ${BRed}Legacy${Color_Off} ${BYellow}and${Color_Off} ${BCyan}FTP${Color_Off} ${BYellow}access${Color_Off}${BWhite} -------${Color_Off}"
    configureUFW
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Starting ${Color_Off}${BWhite}ET:${Color_Off} ${BRed}Legacy${Color_Off} ${BCyan}systemctl services${Color_Off}${BWhite} -------${Color_Off}\n"
    sudo systemctl start etlserver-$net_port.service
    sudo systemctl start etlmonitor-$net_port.timer
    echo -e "\n${BYellow}Checking server status${Color_Off}${BWhite}...${Color_Off}\n"
    sudo systemctl status etlserver-$net_port.service --lines=0 --no-pager --full

    echo -e "\n${BGreen}Setup Complete and the server at${Color_Off} ${BCyan}$installDir/$net_port${Color_Off} ${BGreen}has been started${Color_Off}${BWhite}.${Color_Off}\n\n${BYellow}You may now quit the installer or install another server instance on a different port.${Color_Off}\n"
    
}

function uninstallInfo() {
    # capture desired UDP port of server to delete
    echo -ne "\n${BWhite}Enter the root installation directory of your servers ${Color_Off}${BCyan}(e.g. /home/username)${BWhite}: ${Color_Off}"
    read install_dir
    # capture desired UDP port of server to delete
    echo -ne "\n${BWhite}Enter the UDP Port # for server you wish to uninstall ${Color_Off}${BCyan}(e.g. 27960)${BWhite}: ${Color_Off}"
    read net_port 
    # send info to uninstall procedure
    uninstallMenu "${install_dir}" "${net_port}"
}

function uninstallMenu() {
    local install_dir=${1}
    local net_port=${2}

    echo -e "\n${BYellow}You have chosen to ${Color_Off}${BRed}uninstall${Color_Off} ${BYellow}server found at${Color_Off}${BWhite}: ${Color_Off}${BWhite}$install_dir/$net_port/${Color_Off}\n"
    read -p "$(ColorBRed 'Are you sure you want to proceed?') (y/n) " yn

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
    echo -ne "\n${BWhite}Enter a username for FTP access: ${Color_Off}"
    read username
    addUserAccount "${username}"
    
}

function changeUserPassMenu() {
    
    # capture desired username for password change
    echo -ne "\n${BWhite}Enter a username for FTP access: ${Color_Off}"
    read username 
    setFTPUserPass "${username}"
    
}

function removeFTPUserMenu() {
    
    # capture desired username to delete
    echo -ne "\n${BWhite}Enter the FTP username to be deleted: ${Color_Off}"
    read username 
    removeFTPUser "${username}"
    echo -e "\n${BGreen}The FTP user ${Color_Off}${BCyan}$username${Color_Off} ${BGreen}has been deleted${Color_Off}${BWhite}.${Color_Off}"
}

function checkServerStatus() {
    
    # capture desired username to delete
    echo -ne "\n{BWhite}Enter the port number for server: ${Color_Off}"
    read net_port 
    sudo systemctl status etlserver-$net_port.service --lines=0 --no-pager --full
    echo -e "\nReturing to main menu..."
}

function listServers() {
    
    # capture desired username to delete
    echo -e "\n${BWhite}------ ${Color_Off}${BRed}ET:${Color_Off}${BWhite}Legacy ${Color_Off}${BYellow}Servers${Color_Off}${BWhite} ------${Color_Off}\n"
    sudo ls /etc/systemd/system/ "$@" 2>/dev/null | grep etlserver* || echo -e "\n${BCyan}No ${BRed}ET:${Color_Off}${BWhite}Legacy${Color_Off}${BCyan} server services were found${Color_Off}${BWhite}.${Color_Off}"
    echo -e "\n\n"
    
}

function changeRestartTime() {
    
    # capture desired UDP port of server
    echo -ne "\n${BWhite}Enter the net_port # for the server to change the restart time on (e.g. 27960): ${Color_Off}"
    read net_port
    # capture desired restart time
    echo -ne "\n${BWhite}Enter the time of day for automatic restart (e.g. hh:mm:ss / 5am = 05:00:00): ${Color_Off}"
    read restart_time 
    # stop old timer and remove so new can be created with desired restart time
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Stopping current timer for server on port: ${Color_Off}${BCyan}$net_port${Color_Off}${BWhite} -------${Color_Off}"
    echo -e "\n${BWhite}------- ${Color_Off}${BRed}Removing current timer for server on port: ${Color_Off}${BCyan}$net_port${Color_Off}${BWhite} -------${Color_Off}"
    sudo rm /etc/systemd/system/etlmonitor-$net_port.timer
    sudo systemctl daemon-reload
    # create service file based on new restart time
    echo -e "\n${BWhite}------- ${Color_Off}${BGreen}Creating new server monitor timer${Color_Off}${BWhite} -------${Color_Off}"
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
    echo -e "\n${BWhite}------- ${Color_Off}${BYellow}Reloading systemctl daemon ${Color_Off}${BWhite} -------${Color_Off}"
    sudo systemctl daemon-reload
    sudo systemctl enable etlmonitor-$net_port.timer
    # start server monitor timer
    sudo systemctl start etlmonitor-$net_port.timer
    echo -e "\n${BGreen}The restart time for the server on port ${Color_Off}${BYellow}$net_port${Color_Off} ${BGreen}has been changed to${Color_Off} ${BYellow}$restart_time${Color_Off}${BWhite}.${Color_Off}"
    sudo systemctl status etlmonitor-$net_port.timer
    echo -e "\n"
}



function updateServerInfo () {
    local installtype=${1}

    # capture desired install directory
    echo -ne "\n${BWhite}Enter the installation directory of the server to update ${Color_Off}${BCyan}(e.g. /home/username)${Color_Off}${BWhite}:  ${Color_Off}"
    read installDir 
    # capture desired UDP port of server
    echo -ne "\n${BWhite}Enter the ${BWhite}net_port${Clear_Off} # for the server to update ${Color_Off}${BCyan}(e.g. 27960)${Color_Off}${BWhite}:  ${Color_Off}"
    read net_port 
    # capture desired install directory
    echo -ne "\n${BWhite}Enter the FTP username used to manage server ${Color_Off}${BCyan}(e.g. moesftpuser)${Color_Off}${BWhite}:  ${Color_Off}"
    read ftpuser 
    # capture desired update download URL
    echo -ne "\n${BWhite}Set the URL for current version installer download ${Color_Off}${BCyan}(.tar.gz)${BWhite}:  ${Color_Off}"
    read downloadLink 

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

echo -ne "\n${BWhite}Main Menu:${Color_Off}"
echo -ne "
$(ColorBGreen '1)') ${IWhite}Install${Color_Off} a Server
$(ColorBGreen '2)') ${IWhite}Update${Color_Off} a Server
$(ColorBGreen '3)') Check Server ${IWhite}Status${Color_Off}
$(ColorBGreen '4)') ${IWhite}List${Color_Off} Installed Servers
$(ColorBGreen '5)') Create ${IWhite}New FTP User${Color_Off}
$(ColorBGreen '6)') Change an FTP User ${IWhite}Password${Color_Off}
$(ColorBGreen '7)') Change Daily ${IWhite}Restart Time${Color_Off}
$(ColorBRed '8)') ${IWhite}Remove${Color_Off} an FTP User
$(ColorBRed '9)') ${IWhite}Uninstall${Color_Off} a Server
$(ColorBCyan '0)') ${IWhite}Exit${Color_Off}
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
	    0) author ; exit 0;;
	    *) echo -e $red"Invalid option selected."$clear; main;;
    esac

}

main