#!/bin/sh

# Script to automatically generate documentation and write this
# to a git tree. See http://ASPP.github.com/pelita/development.rst
# for more information.

# check, if index is empty
if ! git diff-index --cached --quiet --ignore-submodules HEAD ; then
  echo "Fatal: cannot work with indexed files!"
  exit 1
fi

# get the 'git describe' output
git_describe=$(git describe)

# make the documentation, hope it doesn't fail
echo "Generating from $git_describe"

docdirectory=doc/
rm -rf "$docdirectory"
mkdir "$docdirectory"
./make_html.py > "$docdirectory"/index.html

# Add a .nojekyll file
# This prevents the GitHub jekyll website generator from running
touch $docdirectory".nojekyll"

# Adding the doc files to the index
git add -f $docdirectory

# writing a tree using the current index
tree=$(git write-tree --prefix=$docdirectory)

# reset the index
git reset HEAD

if [ "$#" -eq 1 ]; then
  echo "New tree $tree. Writing to file $FILE"
  echo $tree > $1
else
  echo "New tree $tree."
fi
