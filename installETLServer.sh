#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/installETLScrimServer.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etLegacyServerSetup.sh -O etLegacyServerSetup.sh
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etLegacySetupLibrary.sh -O etLegacySetupLibrary.sh
}

function setFilePermissions() {
    sudo chmod +x etLegacyServerSetup.sh
    sudo chmod +x etLegacySetupLibrary.sh
}

function runSetupScript() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacyServerSetup.sh"
}

function main () {

  echo "Downloading latest setup files..."
  downloadSetupFiles
  echo "Setting permissions for installation..."
  setFilePermissions
  echo "Running Setup..."
  runSetupScript

}
current_dir=$(getCurrentDir)
main
