#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/etLegacyScrimServerSetup-moes.sh

set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacyScrimSetupLibrary-moes.sh"
}

current_dir=$(getCurrentDir)
includeDependencies

function main() {

    echo 'Running Enemy Territory Server setup script...'
    # capture desired name of the server
    read -rp "Enter the Server Name with color characters:" servername
    # capture desired password for server
    read -rp "Set the game password:" g_password
    # capture desired number of maximum clients
    read -rp "Enter the number of maximum client slots for the server:" g_maxclients
    # capture desired number of private clients
    read -rp "Enter the number of private slots to be reserved:" sv_privateclients
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
    read -rp "Set the URL for update download:" downloadLink
    # capture desired install directory
    read -rp "Set the installation directory (e.g. /home/username):" installDir
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
    installET "${servername}" "${g_password}" "${sv_privateclients}" "${sv_privatepassword}" "${rconpassword}" "${refereepassword}" "${ShoutcastPassword}" "${sv_wwwBaseURL}" "${downloadLink}" "${installDir}" "${g_maxclients}"
    echo 'Downloading maps'
    installMaps
    echo 'Setting up start script for server'
    configureStartScript "${installDir}"
    echo 'Setting up system service for Enemy Territory Legacy'
    configureETServices "${installDir}"
    # install VSFTP
    echo 'Installing and configuring VSFTPD'
    configureVSFTP "${installDir}"
    # configure firewall rules and enable firewall for access
    echo 'Configuring firewall rules for Enemy Territory and FTP access'
    configureUFW
    echo 'Starting Enemy Territory Server'
    sudo systemctl start etlserver.service
    sudo systemctl start etlmonitor.timer
    sudo systemctl status etlserver.service
    echo "Setup Complete and the server ${servername} has started"

}

main
