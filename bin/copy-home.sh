#!/bin/bash

set -euo pipefail

usage() {
    cat <<EOF

    Usage: $0 [-h] <old_home_path>

    -h      This info
EOF
}

for arg in "$@" ; do [[ $arg = -h ]] && { usage; exit 0; } ; done

stubbed_cmds=(rm cp)

[[ ${TEST:-} = true ]] && {
    stub_prefix='echo '
    echo_prefix=': '
}

for cmd in "${stubbed_cmds[@]}" ; do readonly "C_$cmd=${stub_prefix:-}$cmd"; done
readonly C_echo="${echo_prefix:-}echo"

old_home=$1
new_home=$HOME

function replace_file () {
    local filename=$1
    local sourcefile=$old_home/$filename
    local targetfile=$new_home/$filename

    if [[ -e $targetfile ]] ; then
        $C_echo "Removing $targetfile..."
        $C_rm -rf "$targetfile"
    fi
    $C_echo "Copying $sourcefile to $targetfile..."
    $C_cp -r --preserve "$sourcefile" "$targetfile"
}

for file in "$old_home"/* "$old_home"/.* ; do
    filename=$(basename "$file")
    [[ $filename != '..' ]] && [[ $filename != '.' ]] && replace_file "$filename"
done
