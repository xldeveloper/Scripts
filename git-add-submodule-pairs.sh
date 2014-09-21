#!/bin/sh
#
while [ "$1" ]; do
	url=$1; shift; 
	pathname=$1; shift;
	echo "Adding '$pathname' to repository";
    git submodule add $url $pathname;
done;
