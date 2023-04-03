#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/etproServerSetup.sh

set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etproSetupLibrary.sh"
}

current_dir=$(getCurrentDir)
includeDependencies

function main() {

    echo 'Running Enemy Territory Server setup script...'
    # capture desired name of the server
    read -rp "Enter the Server Name with color characters:" servername
    # capture desired password for server
    read -rp "Set the game password:" g_password
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
    echo 'Installing x86 Architecture'
    installx86arch
    echo 'Installing needed software'
    installUnzip
    echo 'Installing Enemy Territory Server'
    installET "${servername}" "${g_password}" "${sv_privateclients}" "${sv_privatepassword}" "${rconpassword}" "${refereepassword}" "${sv_wwwBaseURL}"
    echo 'Downloading maps'
    installMaps
    echo 'Setting up start script for server'
    configureStartScript
    echo 'Setting up system service for Enemy Territory'
    configureETService
    echo 'Installing and configuring VSFTPD'
    configureVSFTP
    echo 'Configuring firewall rules for Enemy Territory and FTP access'
    configureUFW
    echo 'Starting Enemy Territory Server'
    sudo systemctl start etserver.service
    sudo systemctl status etserver.service
    echo "Setup Complete and the server ${servername} has started"

}

main
