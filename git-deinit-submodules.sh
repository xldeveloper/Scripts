#!/bin/sh
#

# error exit function
function error_exit
{
	echo "$1" 1>&2
	exit 1
}

# check if we are a submodule folder in and above root git repo
if [ -d ../.git ]; then 
	error_exit "Not a submodule";
fi;
# go parent dir
cd ..

# list all submodules
# grep path .gitmodules | sed 's/.*= //'

# if 'Scripts' directory exist remove the sub-module
if [ -d Scripts ]; then 
	git submodule deinit Scripts;
	if [ "$?" = "0" ]; then
		git rm Scripts;
		rm -rf '.git/modules/Scripts';
		git commit -m "Removed 'Scripts' git sub-module"

		# check if '.git/modules' dir is empty (0)
		modulesdircontent=$(ls -a '.git/modules' | sed -e "/\.$/d" | wc -l);
		#check if '.gitmodules' file exist (!0)
		gitmodulesfile=$(ls -a '.gitmodules' 2>/dev/null | sed -e "/\.$/d" | wc -l);
		if [ $modulesdircontent -eq 0 ] && [ ! $gitmodulesfile -eq 0 ]; then
			git rm '.gitmodules';
			git commit -m "Removed useless '.gitmodules' file"
		fi;
		
	else
		error_exit "Cannot remove sub-module 'Scripts'";
	fi;
fi;

