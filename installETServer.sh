#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/installETServer.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    wget http://moestavern.site.nfoservers.com/downloads/server/etproServerSetup.sh
    wget http://moestavern.site.nfoservers.com/downloads/server/etproSetupLibrary.sh
}

function setFilePermissions() {
    sudo chmod +x etproServerSetup.sh
    sudo chmod +x etproSetupLibrary.sh
}

function runSetupScript() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etproServerSetup.sh"
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
