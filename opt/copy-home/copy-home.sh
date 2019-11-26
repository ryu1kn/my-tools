#!/bin/bash

set -euo pipefail

source "$(dirname $0)/commands.sh"

usage() {
    cat <<EOF

    Usage: ${0##*/} [-h] <old_home_path> <new_home_path>

    -h      This info
EOF
}

for arg in "$@" ; do [[ $arg = -h ]] && { usage; exit 0; } ; done

old_home=$1
new_home=$2

function replace_file () {
    local filename=$1
    local sourcefile=$old_home/$filename
    local targetfile=$new_home/$filename

    if [[ -e $targetfile ]] ; then
        $ECHO "Removing $targetfile..."
        $RM -rf "$targetfile"
    fi
    $ECHO "Copying $sourcefile to $targetfile..."
    $CP -r --preserve "$sourcefile" "$targetfile"
}

for file in "$old_home"/* "$old_home"/.* ; do
    filename=$(basename "$file")
    [[ $filename != '..' ]] && [[ $filename != '.' ]] && replace_file "$filename"
done
