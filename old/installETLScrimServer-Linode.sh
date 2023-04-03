#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/installETServer.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/etLegacyScrimServerSetup-Linode.sh
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/etLegacyScrimSetupLibrary-Linode.sh
    sudo wget http://moestavern.site.nfoservers.com/downloads/server/update-server-bot.sh
}

function setFilePermissions() {
    sudo chmod +x etLegacyScrimServerSetup-Linode.sh
    sudo chmod +x etLegacyScrimSetupLibrary-Linode.sh
    sudo chmod +x update-server-bot.sh
}

function runSetupScript() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacyScrimServerSetup-Linode.sh"
}

function main () {

  echo "Downloading setup files..."
  downloadSetupFiles
  echo "Setting permissions for installation..."
  setFilePermissions
  echo "Running Setup..."
  runSetupScript

}
current_dir=$(getCurrentDir)
main
