#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-ETServerInstalls/blob/main/etLegacyServerSetup.sh

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

current_dir=$(getCurrentDir)
includeDependencies

function main() {

    echo 'Running Enemy Territory Legacy Server setup script...'
    # capture desired name of the server
    read -rp "Enter the Server Name with color characters:" servername
    # capture desired password for server
    read -rp "Set the game password:" g_password
    # capture desired number of private clients
    read -rp "Enter the maximum number of clients for the server:" sv_maxclients
    # capture desired number of private clients
    read -rp "Enter the number of private slots to be reserved:" sv_privateclients
    # capture desired private slot password
    read -rp "Set the private slot password:" sv_privatepassword
    # capture desired RCON password
    read -rp "Set the RCON Password:" rconpassword
    # capture desired ref password
    read -rp "Set the refereepassword:" refereepassword
    # capture desired redirect and file download URL
    read -rp "Set the URL for file downloads and redirect:" sv_wwwBaseURL
    # capture desired username
    echo 'Setting up user account for FTP access'
    read -rp "Enter a username for FTP access:" username
    addUserAccount "${username}"
    echo 'Updating server packages'
    updateServer
    echo 'Installing needed software'
    installUnzip
    echo 'Installing Enemy Territory Legacy Server'
    installET "${servername}" "${g_password}" "${sv_maxclients}" "${sv_privateclients}" "${sv_privatepassword}" "${rconpassword}" "${refereepassword}" "${sv_wwwBaseURL}"
    echo 'Downloading maps'
    installMaps
    echo 'Setting up start script for server'
    configureStartScript
    echo 'Setting up system service for Enemy Territory Legacy'
    configureETLService
    echo 'Installing and configuring VSFTPD'
    configureVSFTP
    echo 'Configuring firewall rules for Enemy Territory and FTP access'
    configureUFW
    echo 'Starting Enemy Territory Legacy Server'
    sudo systemctl start etlserver.service
    sudo systemctl status etlserver.service
    echo "Setup Complete and the server ${servername} has started"

}

main
