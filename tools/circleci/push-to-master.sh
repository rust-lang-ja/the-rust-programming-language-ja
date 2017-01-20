#!/bin/sh

# This script pushes the contents of `./public` directory to
# `origin/master` branch.
#
# Requirements:
# - CI must be configured with write access to the git remote `origin`.
# - The current directory must be the top directory of the CircleCI
#   project.
# - The current git branch must be `master` branch. (See circle.yml's
#   deployment -> branch)

set -e

# Get the revision of this branch (master branch)
REVISION=$(git rev-parse --short HEAD)

# If there are anything to commit, do `git commit` and `git push`
git add docs
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
