#!/bin/bash
# Set `SOURCE` to the old HOME dir and run this script

set -u

# SOURCE=/media/oldhd/username
TARGET=$HOME

function replace_file () {
  local filename=$1
  local sourcefile=$SOURCE/$filename
  local targetfile=$TARGET/$filename

  if [[ -e $TARGET/$filename ]] ; then
    echo "Removing $targetfile..."
    rm -rf "$targetfile"
  fi
  echo "Copying $sourcefile to $targetfile..."
  cp -r --preserve "$sourcefile" "$targetfile"
}

for FILE in "$SOURCE"/* "$SOURCE"/.* ; do
  FILENAME=$(basename "$FILE")
  if [[ $FILENAME != '..' ]] && [[ $FILENAME != '.' ]] ; then
    replace_file "$FILENAME"
  fi
done
