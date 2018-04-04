#!/bin/bash
# Copy dotfiles from backup location to your HOME

if [ x$REMOTE_CONFIG_DIR = x ] ; then
    echo Environment variable REMOTE_CONFIG_DIR must be set
    exit 1
fi

REMOTEDIR=$REMOTE_CONFIG_DIR
LOCALDIR=$HOME

for ITEM in $REMOTEDIR/_*
do
    CONFFILE=`basename $ITEM`
    NODOTNAME=`echo $CONFFILE | sed -e 's/^_//'`

    SOURCE=$REMOTEDIR/_$NODOTNAME
    DEST=$LOCALDIR/.$NODOTNAME

    if [ -e "$DEST" -o -L "$DEST" ] ; then
        echo -n "Replace your local $DEST with $SOURCE ? (y/n): " > /dev/stdout
        read REPLACE
        if [ x$REPLACE = xY -o x$REPLACE = xy ] ; then
            mv -i $DEST $LOCALDIR/$NODOTNAME.bkp
            cp -r $SOURCE $DEST
        fi
    # else    # if $DEST doesn't exist, $SOURCE wouldn't be needed to local
    #     cp $SOURCE $DEST
    fi
done
