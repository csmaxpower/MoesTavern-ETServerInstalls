#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-ETServerInstalls/blob/main/update-server-bot.sh

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function downloadSetupFiles() {
    local downloadLink=${1}
    #wget ${downloadLink} -O etlegacy-server-update.sh
    #sudo chmod +x etlegacy-server-update.sh
    echo "Downloading setup files..."
    sudo wget ${downloadLink} -O etlegacy-server-update.tar.gz
}

function runUpdate() {
    local current_dir=${1}

    echo "Running Update..."
    # remove old pk3 before running update so correct version starts with service restart
    cd legacy/
    sudo rm -rf *.pk3
    cd ..
    sudo mkdir -p ${current_dir}/et/etupdate
    sudo tar -xf etlegacy-server-update.tar.gz -C ${current_dir}/et/etupdate
    # account for old arch in builds previous to 2.80.2
    sudo mv ${current_dir}/et/etupdate/et*/etl ${current_dir}/et/etl
    sudo mv ${current_dir}/et/etupdate/et*/etlded ${current_dir}/et/etlded
    # account for new arch in builds after to 2.80.2
    sudo mv ${current_dir}/et/etupdate/et*/etl.x86_64 ${current_dir}/et/etl.x86_64
    sudo mv ${current_dir}/et/etupdate/et*/etlded.x86_64 ${current_dir}/et/etlded.x86_64
    # move other game files and paks
    sudo mv ${current_dir}/et/etupdate/et*/librenderer_opengl1_x86_64.so ${current_dir}/et/
    sudo mv ${current_dir}/et/etupdate/et*/legacy/*.pk3 ${current_dir}/et/legacy/
    sudo mv ${current_dir}/et/etupdate/et*/legacy/qagame.mp.x86_64.so ${current_dir}/et/legacy/
    sudo mv ${current_dir}/et/etupdate/et*/legacy/GeoIP.dat ${current_dir}/et/legacy/
    sudo rm -rf etupdate/
    sudo rm -rf etlegacy-server-update.tar.gz
}

function setFilePermissions() {
    local current_dir=${1}

    echo "Setting permissions for installation..."
    sudo chown -R moesftp:moesftp ${current_dir}
}

function restartFTP() {
    echo "Restarting FTP..."
    sudo systemctl restart vsftpd
}

function restartETLServer() {
    local systemservice=${1}
    echo "Restarting ETL Server Service..."
    sudo systemctl restart ${systemservice}
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

function ladderMode() {
    local current_dir=${1}
    local laddermode=${2}
    local ladderpass=${3}
    local authToken=${4}
    local repopath=${5}
    local servercfg=${6}
    local systemservice=${7}

    # ladder mode ON
    if [[ "${laddermode}" == "on" ]]; then
      cd ${current_dir}/et/etmain/
      sudo sed -i 's/set g_password '"\"(.*?)\""'/set g_password '"\"${ladderpass}\""'/' etl_server.cfg
      echo "${ladderpass} has been successfully set as the game password."
      restartETLServer "${systemservice}"
    else
      downloadServerConfigs "${current_dir}" "${authToken}" "${repopath}" "${servercfg}"
      restartETLServer "${systemservice}"
      echo "Ladder mode has been set to ${laddermode}" + "and the server cfg is back to its' original state."
    fi
}

function downloadServerConfigs() {
  local current_dir=${1}
  local token=${2}
  local repopath=${3}
  local mapscriptrepo=${4}
  local servercfg=${5}
  local legacy1_lua=${6}
  local legacy3_lua=${7}
  local legacy3_snaps_lua=${8}
  local legacy5_lua=${9}
  local legacy6_lua=${10}
  local practice_lua=${11}

  echo "Downloading competition and mapscript configurations to /legacy..."
  cd ${current_dir}/et/legacy/
  sudo wget ${mapscriptrepo} -O configs.zip
  unzip -q configs.zip
  sudo mv Legacy-Competition-League-Configs-main/configs/* ${current_dir}/et/legacy/configs/
  sudo mv Legacy-Competition-League-Configs-main/mapscripts/* ${current_dir}/et/legacy/mapscripts/
  sudo rm -rf configs.zip
  sudo rm -rf Legacy-Competition-League-Configs-main/
  cd ${current_dir}/et/legacy/configs/
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy1_lua}\"'#' legacy1.config
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy3_lua}\"'#' legacy3.config
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy3_snaps_lua}\"'#' legacy3-snaps.config
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy5_lua}\"'#' legacy5.config
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${legacy6_lua}\"'#' legacy6.config
  sudo sed -i 's#	setl lua_modules ""#	setl lua_modules '\"${practice_lua}\"'#' practice.config
  cd ${current_dir}/et/etmain/
  echo "Downloading primary server config to /etmain..."
  sudo curl -v -o etl_server.cfg -H "Authorization: token $token" "${repopath}/etmain/${servercfg}"
  cd ..
  echo "Configuration update complete..."
}

function updateServer () {
  # capture desired redirect and file download URL
  local downloadLink=${1}
  local authToken=${2}
  local repopath=${3}
  local mapscriptrepo=${4}
  local servercfg=${5}
  local installPath=${6}
  local systemservice=${7}
  local legacy1_lua=${8}
  local legacy3_lua=${9}
  local legacy3_snaps_lua=${10}
  local legacy5_lua=${11}
  local legacy6_lua=${12}
  local practice_lua=${13}

  echo "Update process starting..."
  cd ${installPath}/et
  downloadSetupFiles "${downloadLink}"
  runUpdate "${installPath}"
  setFilePermissions "${installPath}"
  restartFTP
  downloadServerConfigs "${installPath}" "${authToken}" "${repopath}" "${mapscriptrepo}" "${servercfg}" "${legacy1_lua}" "${legacy3_lua}" "${legacy3_snaps_lua}" "${legacy5_lua}" "${legacy6_lua}" "${practice_lua}"
  restartETLServer "${systemservice}"
  echo "Update Complete..."
}

function main () {
  # capture arguments passed from bot to local variables
  local downloadLink=${1}
  local authToken=${2}
  local repopath=${3}
  local mapscriptrepo=${4}
  local servercfg=${5}
  local installPath=${6}
  local systemservice=${7}
  local maplink=${8}
  local mapname=${9}
  local fileext=${10}
  local laddermode=${11}
  local ladderpass=${12}
  local command=${13}
  local legacy1_lua=${14}
  local legacy3_lua=${15}
  local legacy3_snaps_lua=${16}
  local legacy5_lua=${17}
  local legacy6_lua=${18}
  local practice_lua=${19}

  if [[ "${command}" == "addmap" ]]; then
    echo "Adding map to server..."
    addMap "${installPath}" "${maplink}" "${mapname}" "${fileext}"
  elif [[ "${command}" == "updateconfigs" ]]; then
    echo "Starting server configuration update..."
    downloadServerConfigs "${installPath}" "${authToken}" "${repopath}" "${mapscriptrepo}" "${servercfg}" "${legacy1_lua}" "${legacy3_lua}" "${legacy3_snaps_lua}" "${legacy5_lua}" "${legacy6_lua}" "${practice_lua}"
  elif [[ "${command}" == "laddermode" ]]; then
    echo "Switching server to ladder mode..."
    ladderMode "${installPath}" "${laddermode}" "${ladderpass}" "${authToken}" "${repopath}" "${servercfg}" "${systemservice}"
  else
    echo "Starting Server Update Process..."
    updateServer "${downloadLink}" "${authToken}" "${repopath}" "${mapscriptrepo}" "${servercfg}" "${installPath}" "${systemservice}" "${legacy1_lua}" "${legacy3_lua}" "${legacy3_snaps_lua}" "${legacy5_lua}" "${legacy6_lua}" "${practice_lua}"
  fi

}
#current_dir=$(getCurrentDir)
main "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}" "${19}" 
