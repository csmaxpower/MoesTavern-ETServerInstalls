#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/moes/installETLScrimServer-moes.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/moes/etLegacyScrimServerSetup-moes.sh
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/moes/etLegacyScrimSetupLibrary-moes.sh
    sudo wget https://raw.githubusercontent.com/csmaxpower/MoesTavern-ETServerInstalls/main/moes/update-server-bot.sh
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
