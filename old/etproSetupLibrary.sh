#!/bin/bash
# Author:  MaxPower - notoriusmax@gmail.com
# GitHub:  https://github.com/csmaxpower/MoesTavern-GameServers/blob/main/server-install/etproSetupLibrary.sh

# Update the servers
function updateServer() {
    sudo apt update
    sudo apt -y upgrade
}


# installs 32-bit headers and architecture for running ET on 64-bit linux
function installx86arch() {
    sudo dpkg --add-architecture i386
    sudo apt-get install -y libc6-dev-i386
}

# needed to extract compressed Files
function installUnzip() {
    sudo apt-get install -y unzip
}

# installation of ET, ETTV, ETPRO, and server configs
function installET() {
    # variable to store user input
    local servername=${1}
    local g_password=${2}
    local sv_privateclients=${3}
    local sv_privatepassword=${4}
    local rconpassword=${5}
    local refereepassword=${6}
    local sv_wwwBaseURL=${7}
    mkdir -p ~/et/
    mkdir -p /tmp/etsetup
    cd /tmp/etsetup
    wget https://cdn.splashdamage.com/downloads/games/wet/et260b.x86_full.zip
    unzip et260b.x86_full.zip
    ./et260b.x86_keygen_V03.run --noexec --target /tmp/etsetup/extracted
    mv extracted/* ~/et/
    cd ~/et/
    mv bin/Linux/x86/etded.x86 .
    rm -rf /tmp/etsetup
    wget https://www.gamestv.org/drop/ettv.x86
    chmod +x ettv.x86
    wget https://www.gamestv.org/drop/etpro-3_2_6.zip
    unzip etpro-3_2_6.zip
    rm -rf unzip etpro-3_2_6.zip
    cd etpro/
    wget https://www.gamestv.org/drop/globalconfigsv1_3.zip
    unzip globalconfigsv1_3.zip
    rm -rf globalconfigsv1_3.zip
    wget http://moestavern.site.nfoservers.com/downloads/et/etpro/hs.lua
    wget http://moestavern.site.nfoservers.com/downloads/et/etpro/zfixes.lua
    cd configs/
    wget http://moestavern.site.nfoservers.com/downloads/et/etpro/configs/hs.config
    wget http://moestavern.site.nfoservers.com/downloads/et/etpro/configs/riflecup_new.config
    cd ..
    cd ..
    cd etmain/
    wget http://moestavern.site.nfoservers.com/downloads/server/config/etpro.cfg
    wget http://moestavern.site.nfoservers.com/downloads/server/config/etprorotation.cfg
    wget http://moestavern.site.nfoservers.com/downloads/server/config/server.cfg -O server.cfg
    sudo sed -i 's/set sv_hostname ""/set sv_hostname '"\"${servername}\""'/' server.cfg
    sudo sed -i 's/set g_password ""/set g_password '"\"${g_password}\""'/' server.cfg
    sudo sed -i 's/set sv_privateclients ""/set sv_privateclients '"\"${sv_privateclients}\""'/' server.cfg
    sudo sed -i 's/set sv_privatepassword ""/set sv_privatepassword '"\"${sv_privatepassword}\""'/' server.cfg
    sudo sed -i 's/set rconpassword ""/set rconpassword '"\"${rconpassword}\""'/' server.cfg
    sudo sed -i 's/set refereepassword ""/set refereepassword '"\"${refereepassword}\""'/' server.cfg
    sudo sed -i 's#set sv_wwwBaseURL ""#set sv_wwwBaseURL '"\"${sv_wwwBaseURL}\""'#' server.cfg
    cd ..
}

# installation of maps for ETPro
function installMaps() {
    cd etmain/
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/adlernest.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/braundorf_b4.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/bremen_b3.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/crevasse_b3.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/ctf_multi.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/decay_sw.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/element_b4_1.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/erdenberg_t1.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_ice.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/et_ufo_final.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/frostbite.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/karsiah_te2.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/missile_b3.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/osiris_final.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/reactor_final.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/rifletennis_te.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/rifletennis_te2.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sos_secret_weapon.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sp_delivery_te.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/supply.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_battery.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_goldrush_te.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/sw_oasis_b3.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/tc_base.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/te_escape2.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/te_valhalla.pk3
    wget http://moestavern.site.nfoservers.com/downloads/et/etmain/venice_ne4.pk3
    cd ..
}

# downloads and places the start script for ET which includes game path, port, etc.
function configureStartScript() {
    cd ~/et/
    wget http://moestavern.site.nfoservers.com/downloads/server/start.sh
    chmod +x ~/et/start.sh
}

# downloads and places the systemd linux service that runs ET.  Stop, Stop, Restart, and enabled on Startup.
function configureETService() {
    cd ~/et/
    wget http://moestavern.site.nfoservers.com/downloads/server/etserver.service
    mv etserver.service /etc/systemd/system/etserver.service
    sudo systemctl daemon-reload
    sudo systemctl enable etserver.service
}

# Add the new user account for FTP access
# Arguments:
#   Account Username
function addUserAccount() {
    # variable to store user input
    local username=${1}
    # create new user account from input
    sudo useradd "${username}"
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    setFTPUserPass "${username}"
    # disable new user from being able to ssh into the server
    echo "DenyUsers ${username}" | sudo tee -a /etc/ssh/sshd_config
    sudo systemctl restart sshd
}

function setFTPUserPass() {
    # variable to store user input
    local username=${1}
    # set password for new user.  will prompt for input and confirmation. do not want to read plain text as it will cypher to /etc/passwd
    sudo passwd "${username}"
}

# installs and configures VSFTPD
function configureVSFTP() {
    sudo apt install -y vsftpd
    cd ~/et/
    wget http://moestavern.site.nfoservers.com/downloads/server/vsftpd.conf
    mv vsftpd.conf /etc/vsftpd.conf
    # set FTP permissions for new user
    sudo usermod -d ~/et/ "${username}"
    sudo chown -R "${username}":"${username}" ~/
    sudo systemctl restart vsftpd
}

# configures the firewall for FTP and ET
function configureUFW() {
    sudo ufw allow 20/tcp
    sudo ufw allow 21/tcp
    sudo ufw allow OpenSSH
    sudo ufw allow 40000:50000/tcp
    sudo ufw allow 990/tcp
    sudo ufw allow 27960/udp
    yes | sudo ufw enable
}
