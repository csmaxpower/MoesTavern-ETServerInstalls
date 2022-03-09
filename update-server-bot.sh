#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/randharris/MoesTavern-ETServerInstalls/blob/main/update-server-bot.sh

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

function runUpdate() {
    local current_dir=${1}
    # remove old pk3 before running update so correct version starts with service restart
    cd legacy/
    sudo rm -rf *.pk3
    cd ..
    sudo mkdir -p ${current_dir}/et/etupdate
    sudo tar -xf etlegacy-server-update.tar.gz -C ${current_dir}/et/etupdate
    sudo mv ${current_dir}/et/etupdate/et*/etl ${current_dir}/et/etl
    sudo mv ${current_dir}/et/etupdate/et*/etlded ${current_dir}/et/etlded
    sudo mv ${current_dir}/et/etupdate/et*/legacy/*.pk3 ${current_dir}/et/legacy/
    sudo mv ${current_dir}/et/etupdate/et*/legacy/qagame.mp.x86_64.so ${current_dir}/et/legacy/
    sudo mv ${current_dir}/et/etupdate/et*/legacy/GeoIP.dat ${current_dir}/et/legacy/
    sudo rm -rf etupdate/
    sudo rm -rf etlegacy-server-update.tar.gz
}

function setFilePermissions() {
    local current_dir=${1}
    sudo chown -R moesftp:moesftp ${current_dir}
}

function restartFTP() {
    sudo systemctl restart vsftpd
}

function restartETLServer() {
    sudo systemctl restart etlserver.service
}

function addMap() {
    local current_dir=${1}
    local mapLink=${2}
    local mapName=${3}
    local fileext=${4}

    cd ${current_dir}/et/etmain/
    sudo wget ${mapLink} -O "${mapName}.${fileext}"
    echo "${mapName}.${fileext}" + "has been successfully added to the server."
}

function downloadServerConfigs() {
  local current_dir=${1}
  local token=${2}
  local repopath=${3}
  local servercfg=${4}
  cd legacy/
  sudo wget https://github.com/BystryPL/Legacy-Competition-League-Configs/archive/refs/heads/main.zip
  unzip -q main.zip
  sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/et/legacy/configs/
  sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/et/legacy/mapscripts/
  sudo rm -rf main.zip
  sudo rm -rf Legacy-Competition-League-Configs-main/
  cd ..
  cd etmain/
  sudo curl -v -o etl_server.cfg -H "Authorization: token $token" "${repopath}/etmain/${servercfg}"
  cd ..
}

function updateServer () {
  # capture desired redirect and file download URL
  local downloadLink=${1}
  local authToken=${2}
  local repopath=${3}
  local servercfg=${4}
  local installPath=${5}

  cd ${installPath}/et
  echo "Downloading setup files..."
  downloadSetupFiles "${downloadLink}"
  echo "Running Setup..."
  runUpdate "${installPath}"
  echo "Setting permissions for installation..."
  setFilePermissions "${installPath}"
  echo "Restarting FTP..."
  restartFTP
  echo "Downloading Server configurations..."
  downloadServerConfigs "${installPath}" "${authToken}" "${repopath}" "${servercfg}"
  echo "Restarting ETL Server Service..."
  restartETLServer
  echo "Update Complete..."
}

function main () {
  # capture arguments passed from bot to local variables
  local downloadLink=${1}
  local authToken=${2}
  local repopath=${3}
  local servercfg=${4}
  local installPath=${5}
  local maplink=${6}
  local mapname=${7}
  local fileext=${8}
  local command=${9}

  if [[ "${command}" == "addmap" ]]; then
    echo "Adding map to server..."
    addMap "${installPath}" "${maplink}" "${mapname}" "${fileext}"
  else
    echo "Starting Server Update Process..."
    updateServer "${downloadLink}" "${authToken}" "${repopath}" "${servercfg}" "${installPath}"
  fi

}
#current_dir=$(getCurrentDir)
main "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
