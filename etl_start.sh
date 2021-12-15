#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"${DIR}/etlded" \
    +set dedicated 2 \
    +set vm_game 0 \
    +set net_port 27960 \
    +set fs_game legacy \
    +set fs_basepath "${DIR}" \
    +set fs_homepath "${DIR}" \
    +exec etl_server.cfg
