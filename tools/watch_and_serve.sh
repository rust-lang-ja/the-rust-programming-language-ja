#!/bin/sh
RUBY=ruby
ROOT=$(cd "$(dirname "$0")"; pwd)

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

"$RUBY" -run -e httpd -- . --port 8080 &
"$ROOT/watch.sh" "$1"

