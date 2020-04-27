#!/bin/bash

if [ "$SOURCE_LIST" != "empty" ] 
then 
if [ "$TRUSTED_SOURCE" == "empty" ]
then
	echo "Creating sources.list"
	echo "deb $SOURCE_LIST bionic main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-updates main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic universe" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-updates universe" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-security main restricted multiverse" >> /tmp/sources.list
	echo "deb $SOURCE_LIST bionic-security universe" >> /tmp/sources.list
	echo "Replacing Sources.list"
	cp /tmp/sources.list /etc/apt/sources.list

else
	echo "Creating sources.list"
	echo "deb [trusted=yes] $SOURCE_LIST bionic main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-updates main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic universe" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-updates universe" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-security main restricted multiverse" >> /tmp/sources.list
	echo "deb [trusted=yes] $SOURCE_LIST bionic-security universe" >> /tmp/sources.list
	echo "Replacing Sources.list"
	cp /tmp/sources.list /etc/apt/sources.list
fi
fi

