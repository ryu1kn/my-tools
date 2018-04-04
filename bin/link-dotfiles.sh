#!/bin/bash
# Create dotfiles as symlinks that point backup/source dotfiles

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

    if [ -e $DEST ] ; then
        echo -n "Replace your local $DEST with $SOURCE ? (y/n): "
        read REPLACE
        if [ x$REPLACE = xY -o x$REPLACE = xy ] ; then
            mv -i $DEST $LOCALDIR/$NODOTNAME.bkp
            ln -s $SOURCE $DEST
        fi
    elif [ -L $DEST ] ; then
        rm -i $DEST
        ln -s $SOURCE $DEST
    else
        ln -s $SOURCE $DEST
    fi
done
