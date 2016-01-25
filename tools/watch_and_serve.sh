#!/bin/sh
RUBY=ruby
ROOT=$(cd "$(dirname "$0")"; pwd)

trap "trap - SIGINT && kill -INT -- -$$" SIGINT SIGTERM EXIT

"$RUBY" -run -e httpd -- . --port 8080 &
"$ROOT/watch.sh" "$1"

