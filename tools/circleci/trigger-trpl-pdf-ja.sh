#!/usr/bin/env bash

# This script triggers a Travis CI build on trpl-ja-pdf to generates
# PDF files of TRPL. It does so by sending a request to Travis's API
# server.
#
# This script referes to the following mandatory and optional
# environment variables:
#
# - TRPL_JA_PDF_TRAVIS_AUTH_TOKEN (Mandatory):
#     The auth token required by Travis CI web API. Since this
#     variable carries a sensitive data, it should not be defined in
#     circle.yml. Instead, it should be defined at Circle CI's web
#     console at:
#     https://circleci.com/gh/rust-lang-ja/the-rust-programming-language-ja/edit#env-vars
#
#     To obtain a Travis auth token, follow the instructions on:
#     https://docs.travis-ci.com/user/triggering-builds/
#
# - TRPL_JA_PDF_GITHUB_ORG (Optional):
#     The GitHub organization or user name of trpl-ja-pdf, default to
#    `rust-lanu-ja`. To override it, define this variable at
#    CirildCI's web console or in circle.yml.
#
# - TRPL_JA_PDF_GITHUB_REPO (Optional):
#     The GitHub repository name of trpl-ja-pdf, default to
#     `trpl-ja-pdf`. To override it, define this variable at
#     CircleCI's web console or in circle.yml.
#
# - TRPL_JA_PDF_GITHUB_BRANCH (Optional):
#     The GitHub branch of trpl-ja-pdf, default to `master`. To
#     override it, define this variable at CircleCI's web console or
#     in circle.yml.

set -e

if [ -z "${TRPL_JA_PDF_TRAVIS_AUTH_TOKEN+x}" ]; then
    echo "ERROR: Environment variable TRPL_JA_PDF_TRAVIS_AUTH_TOKEN is undefined."
    echo "       If you want to trigger a Travis CI build for trpl-ja-pdf,"
    echo "       please read comments in this script to define the variable."
    exit 1
fi

GITHUB_ORG=${TRPL_JA_PDF_GITHUB_ORG:-rust-lang-ja}
GITHUB_REPO=${TRPL_JA_PDF_GITHUB_REPO:-trpl-ja-pdf}
GITHUB_BRANCH=${TRPL_JA_PDF_GITHUB_BRANCH:-master}

set -u

# Get the revision of current branch.
REVISION=$(git rev-parse --short HEAD)

BUILD_PARAMS=$(cat <<EOF
{
  "request": {
    "branch": "${GITHUB_BRANCH}",
    "message": "automatic build triggered by trpl-ja commit ${REVISION}"
  }
}
EOF
)

echo "Triggering a build on Travis CI for ${GITHUB_BRANCH} branch of ${GITHUB_ORG}/${GITHUB_REPO}."

HTTP_RESPONSE=$(curl -s -X POST \
     -w " - HTTP Status %{http_code}" \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Travis-API-Version: 3" \
     -H "Authorization: token ${TRPL_JA_PDF_TRAVIS_AUTH_TOKEN}" \
     -d "$BUILD_PARAMS" \
        https://api.travis-ci.org/repo/${GITHUB_ORG}%2F${GITHUB_REPO}/requests)

if [[ "x_${HTTP_RESPONSE}" =~ "HTTP Status 202" ]]; then
    echo "Successfully triggered the Travis CI build:"
    echo "${HTTP_RESPONSE}"
else
    echo "Failed to trigger the Travis CI build:"
    echo "${HTTP_RESPONSE}"
    exit 1
fi
