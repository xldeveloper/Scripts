#!/bin/sh
# 
# Filename: 
# pre-commit
#
# Licence:
# The MIT License (MIT)
# 
# Copyright (c) {{year}} {{fullname}}
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# Description:
# Pre-commit hook script for Unity to check that every folder that just has marked to be ignored in .gitignore 
# has an entry for its meta file to be ignored too.
# 
# Put this file into directory .git/hooks. To disable it remove it from there.


# check if staged files contain .gitignore
if [ ! `git diff --name-only --cached | grep "\.gitignore"` ]; then
	# avoid expensive diff actions if there is no change in .gitignore
	exit 0
fi

# new lines have the format {+xxxxx+}
raw_diff_output=`git diff --cached --word-diff=plain .gitignore | egrep  "\{\+.*\+\}"`

# prepare two strings: on for directories and one for meta files
for raw_entry in $raw_diff_output; do
	# strip leading and trailing separator "{+" and "+}"
	e=${raw_entry:2:$((${#raw_entry}-4))}
	is_meta=$((`echo $e | egrep ".*meta" | wc -l`))
	if [ $is_meta -eq 0 ]; then
		diff_output_dirs="${diff_output_dirs} ${e}"
	else
		diff_output_metas="${diff_output_metas} ${e}"
	fi
done

# iterate over directories and check if there is an entry for the appropriate meta file
for i in $diff_output_dirs; do 
	# meta file entries are often without directory, so strip the path
	dir_name=`echo $i | egrep -o "/[^/]+$" | cut -d / -f 2`
	has_meta_ignore=$((`echo $diff_output_metas | grep "$dir_name.meta" | wc -l`))
	if [ ${has_meta_ignore} -eq 0 ]; then
		echo "$dir_name found in .gitignore but not the corresponding meta file! Please add ${dir_name}.meta to .gitignore"
		exit 1
	fi
done
