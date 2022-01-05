#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-GameServers/blob/main/server-install/updateETLScrimServer.sh

function downloadSetupFiles() {
    local downloadLink=${1}
    #wget ${downloadLink} -O etlegacy-server-update.sh
    #sudo chmod +x etlegacy-server-update.sh
    wget ${downloadLink} -O etlegacy-server-update.tar.gz
}

function runUpdateScript() {
    # remove old pk3 before running update so correct version starts with service restart
    cd legacy/
    rm -rf *.pk3
    cd ..
    mkdir -p ~/et/etupdate
    tar -xvf etlegacy-server-update.tar.gz -C ~/et/etupdate
    mv ~/et/etupdate/et*/etl ~/et/etl
    mv ~/et/etupdate/et*/etlded ~/et/etlded
    mv ~/et/etupdate/et*/legacy/*.pk3 ~/et/legacy/
    mv ~/et/etupdate/et*/legacy/qagame.mp.x86_64.so ~/et/legacy/
    mv ~/et/etupdate/et*/legacy/GeoIP.dat ~/et/legacy/
    rm -rf etupdate/
    rm -rf etlegacy-server-update.tar.gz
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
  local servername=${1}
  local token=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
  cd legacy/
  wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
  unzip main.zip
  mv Legacy-Competition-League-Configs-main/configs/* ~/et/legacy/configs/
  mv Legacy-Competition-League-Configs-main/mapscripts/* ~/et/legacy/mapscripts/
  rm -rf main.zip
  rm -rf Legacy-Competition-League-Configs-main/
  cd ..
  cd etmain/
  curl -v -o etl_server.cfg -H "Authorization: token $token" https://raw.githubusercontent.com/randharris/MoesTavern-GameServers/main/moes-legacy-"${servername}"/etmain/etl_server.cfg
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
  echo "Update Complete..."
}
main
