#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"${DIR}/ettv.x86" \
    +set dedicated 2 \
    +set vm_game 0 \
    +set net_port 27960 \
    +set sv_maxclients 32 \
    +set fs_game etpro \
    +set sv_punkbuster 0 \
    +set fs_basepath "${DIR}" \
    +set fs_homepath "${DIR}" \
    +exec server.cfg
