#!/bin/sh

# This script publishes the contents of `./public` directory of
# the `master` branch to `origin/gh-pages` branch.
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

# Recreate the worktree for gh-pages
rm -rf ./gh-pages || true
git worktree prune || true
git branch -D gh-pages || true
mkdir -p ./gh-pages
git branch gh-pages origin/gh-pages
git worktree add ./gh-pages gh-pages

# Copy the contents of public to gh-pages
cp -rp public/* gh-pages/
cd gh-pages

# Create circle.yml to disable CI on gh-pages branch.
cat > circle.yml <<EOF
general:
  branches:
    ignore:
      - gh-pages
EOF

# If there are anything to commit, do `git commit` and `git push`
git add .
set +e
ret=$(git status | grep -q 'nothing to commit'; echo $?)
set -e
if [ $ret -eq 0 ] ; then
    echo "Nothing to push to gh-pages."
else
    git commit -m "ci: publish pages at ${REVISION}"
    echo "Pushing to gh-pages..."
    git push origin gh-pages
fi
