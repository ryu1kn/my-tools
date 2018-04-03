#!/bin/bash
#
# Obtain dotfiles to your HOME by either downloading them from
# the remote location or creating links to the remote dotfiles

FLG_LOCAL=R2L
FLG_REMOTE=L2R
SHELL_LIB_DIR=`dirname "$0"`/../lib/shell

if [ x$1 != x$FLG_LOCAL -a x$1 != x$FLG_REMOTE ] ; then
    echo Please specify \'$FLG_LOCAL\' or \'$FLG_REMOTE\'
    exit 1;
fi

if [ x$REMOTE_CONFIG_DIR = x ] ; then
    echo Please set the environment variable REMOTE_CONFIG_DIR first
    exit 1;
fi

if [ ! -d $REMOTE_CONFIG_DIR ] ; then
    echo Make sure there\'s config directory at $REMOTE_CONFIG_DIR
    exit 1;
fi

if [ x$1 = x$FLG_LOCAL ] ; then

    echo -n "Are you sure you want to copy dotfiles from remote to local? (y/n): "
    read ANSWER
    if [ x$ANSWER != xY -a x$ANSWER != xy ] ; then
        exit 0;
    fi

    . $SHELL_LIB_DIR/copy-dotfiles.sh
    copy_dotfiles $REMOTE_CONFIG_DIR $HOME

elif [ x$1 = x$FLG_REMOTE ] ; then

    echo -n "Are you sure you want to use remote dotfiles by creating links? (y/n): "
    read ANSWER
    if [ x$ANSWER != xY -a x$ANSWER != xy ] ; then
        exit 1;
    fi

    . $SHELL_LIB_DIR/link-dotfiles.sh
    link_dotfiles $REMOTE_CONFIG_DIR $HOME

fi

