#!/bin/bash
ARCH=`uname -m`


if [ "$CUSTOM_SOURCES" == "true" ]
then
if [ "$ARCH" == "x86_64" ]
then
	SOURCE_LIST=$SOURCE_LIST_AMD
elif [ "$ARCH" == "ppc64le" ]
then
	SOURCE_LIST=$SOURCE_LIST_PPC
fi
if [ "$TRUSTED_SOURCE" == "true" ]
then
	echo "Creating sources.list"
	echo "deb [trusted=yes] $SOURCE_LIST bionic main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-updates main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic universe" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-updates universe" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-security main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-security universe" >> /tmp/sources.list
	echo "Replacing Sources.list"
	sudo cp /tmp/sources.list /etc/apt/sources.list
else
	echo "Creating sources.list"
	echo "deb $SOURCE_LIST bionic main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-updates main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic universe" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-updates universe" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-security main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-security universe" >> /tmp/sources.list
	echo "Replacing Sources.list"
	sudo cp /tmp/sources.list /etc/apt/sources.list
fi
fi

