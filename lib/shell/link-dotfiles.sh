#!/bin/bash

function link_dotfiles() {
    if [ x$1 = x -o x$2 = x -o x$3 != x ] ; then
        echo Invalid number of arguments
        echo Usage: link_dotfiles {SourceConfigDir} {TargetConfigDir}
        exit 1
    fi

    local ITEM
    local CONFFILE
    local NODOTNAME
    local SOURCE
    local DEST
    local REPLACE
    local REMOTEDIR=$1
    local LOCALDIR=$2

    for ITEM in $REMOTEDIR/_*
    do
        CONFFILE=`basename $ITEM`
        NODOTNAME=`echo $CONFFILE | sed -e 's/^_//'`

        SOURCE=$REMOTEDIR/_$NODOTNAME
        DEST=$LOCALDIR/.$NODOTNAME

        if [ -e $DEST ] ; then
            echo -n "Replace your local $DEST with $SOURCE ? (y/n): " > /dev/stdout
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
}

