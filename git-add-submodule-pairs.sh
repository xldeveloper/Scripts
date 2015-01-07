#!/bin/sh
#

# error exit function
function error_exit
{
	echo "$1" 1>&2
	exit 1
}

# check if we are on the root of git repo
if [ ! -d .git ]; then 
	error_exit "Not a git repo";
fi;

while [ "$1" ]; do
	url=$1; shift; 
	pathname=$1; shift;
	echo "Adding '$pathname' to repository";
    git submodule add $url $pathname;
done;
