#!/bin/bash
# Copy dotfiles from backup location to your HOME

set -euo pipefail

for ITEM in $REMOTE_CONFIG_DIR/_* ; do
    CONFFILE=`basename $ITEM`
    NODOTNAME=${CONFFILE#_}

    SOURCE=$REMOTE_CONFIG_DIR/_$NODOTNAME
    DEST=$HOME/.$NODOTNAME

    if [[ -e $DEST ]] || [[ -L $DEST ]] ; then
        echo -n "Replace your local $DEST with $SOURCE ? (y/n): "
        read REPLACE
        [[ $REPLACE != Y ]] && [[ $REPLACE != y ]] && continue

        mv -i $DEST $HOME/$NODOTNAME.bkp
        cp -r $SOURCE $DEST
    # else    # if $DEST doesn't exist, $SOURCE wouldn't be needed to local
    #     cp $SOURCE $DEST
    fi
done
