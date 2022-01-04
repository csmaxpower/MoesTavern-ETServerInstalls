#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/updateETLScrimServer.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    local downloadLink=${1}
    wget ${downloadLink} -O etlegacy-server-update.sh
    sudo chmod +x etlegacy-server-update.sh
}

function runUpdateScript() {
    # shellcheck source=./updateETLScrimServer.sh
    source "${current_dir}/etlegacy-server-update.sh"
}

function setFilePermissions() {
    sudo chown -R moesftp:moesftp ~/
}

function restartFTP() {
    sudo systemctl restart vsftpd
}

function restartETLServer() {
    sudo systemctl restart etlserver.service
}
function downloadServerConfigs() {
  local servername=${2}
  cd legacy/
  wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
  unzip Legacy-Competition-League-Configs.zip
  rm -rf Legacy-Competition-League-Configs.zip
  cd ..
  cd etmain/
  curl -H 'Authorization: token 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' \
  -H 'Accept: application/vnd.github.v3.raw' \
  -O \
  -L https://api.github.com/repos/randharris/MoesTavern-GameServers/main/moes-legacy-"${servername}"/etmain/etl_server.cfg
  cd ..
}

function main () {
  cd ~/et
  # capture desired redirect and file download URL
  read -rp "Set the URL for update download:" downloadLink
  read -rp "Which Server is being updated (Country-Location eu-uk,na-ny):" servername
  echo "Downloading setup files..."
  downloadSetupFiles "${downloadLink}"
  echo "Running Setup..."
  runUpdateScript
  echo "Setting permissions for installation..."
  setFilePermissions
  echo "Restarting FTP..."
  restartFTP
  echo "Downloading Server configurations..."
  downloadServerConfigs "${servername}"
  echo "Restarting ETL Server Service..."
  restartETLServer

}
current_dir=$(getCurrentDir)
main
