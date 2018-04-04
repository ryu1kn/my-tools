#!/bin/bash
# Copy dotfiles from backup location to your HOME

set -euo pipefail

for ITEM in $REMOTE_CONFIG_DIR/_* ; do
    CONFFILE=`basename $ITEM`
    NODOTNAME=${CONFFILE#_}

    SOURCE=$REMOTE_CONFIG_DIR/_$NODOTNAME
    DEST=$HOME/.$NODOTNAME

    if [[ -e $DEST ]] ; then
        echo -n "Replace your local $DEST with $SOURCE ? (y/n): "
        read REPLACE
        [[ $REPLACE != Y ]] && [[ $REPLACE != y ]] && continue

        mv -i $DEST $HOME/$NODOTNAME.bkp
    elif [[ -L $DEST ]] ; then
        rm -f $DEST
    fi
    cp -r $SOURCE $DEST
done
