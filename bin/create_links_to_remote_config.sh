#!/bin/bash --debug
#
# Create symlinks that point dotfiles stored in remote config directory
#
# Usage:
#    create_links_to_remote_config.sh
#

if [ x$REMOTE_CONFIG_DIR = x ] ; then
	echo Please set the environment variable REMOTE_CONFIG_DIR first
	exit 1;
fi

if [ ! -e $REMOTE_CONFIG_DIR ] ; then
	echo Make sure there\'s config directory at $REMOTE_CONFIG_DIR
	exit 1;
fi

for CONFFILE in $REMOTE_CONFIG_DIR/_*
do
	NODOTNAME=`basename $CONFFILE | sed -e 's/^_//'`

	SOURCE=$REMOTE_CONFIG_DIR/_$NODOTNAME
	DEST=$HOME/.$NODOTNAME

	if [ -e $SOURCE ] ; then
		if [ -e $DEST ] ; then
			echo -n "Replace your local $DEST with $SOURCE ? (y/n): "
			read REPLACE
			if [ x$REPLACE = xY -o x$REPLACE = xy ] ; then
				mv -i $DEST $HOME/$NODOTNAME.bkp
				ln -s $SOURCE $DEST
			fi
		elif [ -L $DEST ] ; then
			rm -i $DEST
			ln -s $SOURCE $DEST
		else
			ln -s $SOURCE $DEST
		fi
	else
		echo $SOURCE not found
	fi
done

