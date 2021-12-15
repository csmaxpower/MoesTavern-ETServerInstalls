#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/installETLPubServer.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    wget http://moestavern.site.nfoservers.com/downloads/server/etLegacyPubServerSetup.sh
    wget http://moestavern.site.nfoservers.com/downloads/server/etLegacyPubSetupLibrary.sh
}

function setFilePermissions() {
    sudo chmod +x etLegacyPubServerSetup.sh
    sudo chmod +x etLegacyPubSetupLibrary.sh
}

function runSetupScript() {
    # shellcheck source=./etLegacyPubServerSetup.sh
    source "${current_dir}/etLegacyPubServerSetup.sh"
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
