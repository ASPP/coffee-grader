#!/bin/bash

BRANCH="master"

  echo "Trying to build documentation."

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  git clone --quiet --branch=$BRANCH https://${GH_TOKEN}@github.com/${REPO} doc

  cd doc

  git checkout gh-pages
  git checkout $BRANCH

  TREEFILE=$(mktemp TREE.XXXXXX)

  ./make-doc-tree.sh $TREEFILE

  tree=$(cat $TREEFILE)

  # get the ‘git describe’ output
  git_describe=$(git describe)

  # we’ll have a commit
  commit=$(echo "DOC: generated from $git_describe" | git commit-tree $tree -p gh-pages)

  # move the branch to the commit we made, i.e. one up
  git update-ref refs/heads/gh-pages $commit

  git push -q origin gh-pages
