#!/bin/sh

# This script pushes the contents of `./docs` directory to
# `origin/master` branch.
#
# Requirements:
# - CI must be configured with write access to the git remote `origin`.
# - The current directory must be the top directory of the CircleCI
#   project.
# - The current git branch must be `master` branch. (See circle.yml's
#   deployment -> branch)

set -e

if [ "x_$CIRCLE_BRANCH" != "x_master" ]; then
  echo "This commit was made against the $CIRCLE_BRANCH and not the master. Aborting."
  exit 4
fi

# Get the revision of this branch (master branch)
REVISION=$(git rev-parse --short HEAD)

# If there are anything to commit, do `git commit` and `git push`
# -f flag is needed as docs is listed in .gitignore
git add -f docs
set +e
ret=$(git status | grep -q 'nothing to commit'; echo $?)
set -e
if [ $ret -eq 0 ] ; then
    echo "Nothing to push to master."
else
    git commit -m "ci: generate pages at ${REVISION} [ci skip]"
    echo "Pushing to master."
    git push origin master
fi
