#!/bin/bash

#set -xv

# Copyright 2025 IBM Technology Services
#
# Licensed under the Apache License, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-3.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#############################################################################
#                                                                           #
# Name: get_file_sizes.sh                                                   #
# Path: N/A                                                                 #
# Host(s): N/A                                                              #
# Info: Script to collect all files and their respective sizes in a         #
#       filesystem                                                          #
#                                                                           #
# Author: Anderson F Nobre                                                  #
# Creation date: 06/04/2025                                                 #
# Version: 1.0.0                                                            #
#                                                                           #
# Modification date: DD/MM/YYYY                                             #
# Modified by: XXXXXX                                                       #
# Modifications:                                                            #
# - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                          #
#                                                                           #
#############################################################################

#############################################################################
# Environment variables                                                     #
#############################################################################

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:${HOME}/bin
export PATH
HOST=$(hostname)
DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")
OUTPUT_DIR=$(pwd)

# Not reinventing the wheel. From the following link:
# https://www.ludovicocaldara.net/dba/bash-tips-4-use-logging-levels/
colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colrst='\033[0m'    # Text Reset

verbosity=5

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

#############################################################################
# Function definitions                                                      #
#############################################################################

#----------------------------------------------------------------------------
# Function: usage
#
# Arguments:
# - N/A
#
# Retun:
# - N/A

function usage {

    cat <<EOF
    Usage: $0 [--output-dir /path/to/dir] /fs1 /fs2 ... /fsN
              [--help|-h]
        --output-dir: Directory path to generate data collected.
                      The default directory ${OUTPUT_DIR}
        <filesystem name>: Mountpoint of filesystem
        --help|-h: This help
EOF

}

## esilent prints output even in silent mode
function esilent {
    verb_lvl=$silent_lvl elog "$@"
}

function enotify {
    verb_lvl=$ntf_lvl elog "$@"
}

function eok {
    verb_lvl=$ntf_lvl elog "SUCCESS - $@"
}

function ewarn {
    verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $@"
}

function einfo {
    verb_lvl=$inf_lvl elog "${colwht}INFO${colrst} ---- $@"
}

function edebug {
    verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $@"
}

function eerror {
    verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $@"
}

function ecrit {
    verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $@"
}

function edumpvar {
    for var in "$@"; do
        edebug "$var=${!var}"
    done
}

function elog {
    if [[ $verbosity -ge $verb_lvl ]]; then
        datestring=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "${datestring} - $@"
    fi
}


#############################################################################
# Script main logic                                                         #
#############################################################################

PARAMS=""
while (("$#")); do
    case "$1" in
        --output-dir)
            if [[ -n "$2" && ${2:0:1} != "-" ]]; then
                OUTPUT_DIR=$2
                shift 2
            else
                eerror "Error: Argument for $1 is missing"
                exit 1
            fi
            ;;
        -h | --help | -\?)
            usage
            exit 0
            ;;
        -* | --*=) # unsupported flags
            eerror "Error: Unsupported flag $1"
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
        esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

declare -a FILESYSTEMS=( echo ${PARAMS} )

for fs in "${FILESYSTEMS[@]}"
do
    if [[ -e $fs ]]
    then
        FSNAME=$(echo $fs | sed -e 's#^/##; s#^\./##; s#/#_#g')
        OUTPUT_FILE="${HOST}_${FSNAME}_${DATE}_${TIME}.out"
        echo "File,Size_bytes" > ${OUTPUT_DIR}/${OUTPUT_FILE}
        find "$fs" -xdev -type f -printf '"%p",%s\n' >> ${OUTPUT_DIR}/${OUTPUT_FILE}
    fi
done