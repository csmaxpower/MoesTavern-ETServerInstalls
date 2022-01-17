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
    #wget ${downloadLink} -O etlegacy-server-update.sh
    #sudo chmod +x etlegacy-server-update.sh
    sudo wget ${downloadLink} -O etlegacy-server-update.tar.gz
}

function runUpdateScript() {
    # remove old pk3 before running update so correct version starts with service restart
    cd legacy/
    rm -rf *.pk3
    cd ..
    mkdir -p /home/moesroot/et/etupdate
    tar -xvf etlegacy-server-update.tar.gz -C /home/moesroot/et/etupdate
    mv /home/moesroot/et/etupdate/et*/etl /home/moesroot/et/etl
    mv /home/moesroot/et/etupdate/et*/etlded /home/moesroot/et/etlded
    mv /home/moesroot/et/etupdate/et*/legacy/*.pk3 /home/moesroot/et/legacy/
    mv /home/moesroot/et/etupdate/et*/legacy/qagame.mp.x86_64.so /home/moesroot/et/legacy/
    mv /home/moesroot/et/etupdate/et*/legacy/GeoIP.dat /home/moesroot/et/legacy/
    rm -rf etupdate/
    rm -rf etlegacy-server-update.tar.gz
}

function setFilePermissions() {
    sudo chown -R moesftp:moesftp /home/moesroot/
}

function restartFTP() {
    sudo systemctl restart vsftpd
}

function restartETLServer() {
    sudo systemctl restart etlserver.service
}
function downloadServerConfigs() {
  local token=${1}
  local servername=${2}
  cd legacy/
  sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
  unzip main.zip
  mv Legacy-Competition-League-Configs-main/configs/* /home/moesroot/et/legacy/configs/
  mv Legacy-Competition-League-Configs-main/mapscripts/* /home/moesroot/et/legacy/mapscripts/
  rm -rf main.zip
  rm -rf Legacy-Competition-League-Configs-main/
  cd ..
  cd etmain/
  curl -v -o etl_server.cfg -H "Authorization: token $token" https://raw.githubusercontent.com/randharris/MoesTavern-GameServers/main/moes-legacy-"${servername}"/etmain/etl_server.cfg
  cd ..
}

function main () {
  cd /home/moesroot/et
  # capture desired redirect and file download URL
  read -rp "Set the URL for update download:" downloadLink
  read -rp "Provide Git Repository Authorization Token:" token
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
  downloadServerConfigs "${token}" "${servername}"
  echo "Restarting ETL Server Service..."
  restartETLServer
  echo "Update Complete..."
}
current_dir=$(getCurrentDir)
main
