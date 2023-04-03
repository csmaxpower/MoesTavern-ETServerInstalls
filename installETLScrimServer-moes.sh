#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/installETLScrimServer-moes.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etLegacyScrimServerSetup-moes.sh
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/etLegacyScrimSetupLibrary-moes.sh
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/update-server-bot.sh
}

function setFilePermissions() {
    sudo chmod +x etLegacyScrimServerSetup-moes.sh
    sudo chmod +x etLegacyScrimSetupLibrary-moes.sh
    sudo chmod +x update-server-bot.sh
}

function runSetupScript() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/etLegacyScrimServerSetup-moes.sh"
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
