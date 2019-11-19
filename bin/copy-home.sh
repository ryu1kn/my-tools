#!/bin/bash
# Set `SOURCE` to the old HOME dir and run this script

set -euo pipefail

stubbed_cmds=(rm cp)

[[ ${TEST:-} = true ]] && {
    stub_prefix='echo '
    echo_prefix=': '
}

for cmd in "${stubbed_cmds[@]}" ; do readonly "C_$cmd=${stub_prefix:-}$cmd"; done
readonly C_echo="${echo_prefix:-}echo"

# SOURCE=/media/oldhd/username
TARGET=$HOME

function replace_file () {
  local filename=$1
  local sourcefile=$SOURCE/$filename
  local targetfile=$TARGET/$filename

  if [[ -e $TARGET/$filename ]] ; then
    $C_echo "Removing $targetfile..."
    $C_rm -rf "$targetfile"
  fi
  $C_echo "Copying $sourcefile to $targetfile..."
  $C_cp -r --preserve "$sourcefile" "$targetfile"
}

for FILE in "$SOURCE"/* "$SOURCE"/.* ; do
  FILENAME=$(basename "$FILE")
  if [[ $FILENAME != '..' ]] && [[ $FILENAME != '.' ]] ; then
    replace_file "$FILENAME"
  fi
done
