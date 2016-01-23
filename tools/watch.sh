#!/bin/sh
VERSION=$1
while inotifywait -r -e modify ./${VERSION}/ja; do
    make RUSTBOOK=${RUSTBOOK}
done
