#!/bin/sh
usage() {
    cat <<HELP
NAME:
   $0 -- watch document dir and build the book

SYNOPSIS:
  $0 <version>
  $0 [-h|--help]

DESCRIPTION:
  A watch and build script.
  This uses 'rustbook' command, and use 'RUSTBOOK' as the path if set.

  -h  --help    Print this help.

EXAMPLE:
  watch and build 1.6

  $ RUSTBOOK=/path/to/rustbook $0 1.6

HELP
}


main() {
    case "$1" in
        -h|--help) usage; exit 0;;
    esac

    if ! command -v inotifywait > /dev/null 2>&1 &&
          ! command -v fswatch > /dev/null 2>&1
    then
        echo "You need to install 'inotifywait'(in inotify-tools) on Linux or 'fswatch' on OS X" >&2
        exit 1
    fi

    : ${RUSTBOOK:=rustbook}
    VERSION=$1
    DIR=$(cd "$(dirname "$0")"; pwd)
    ROOT="${DIR}/../"
    build
    watch "${ROOT}/${VERSION}/ja"
}


build() {
    make -C "${ROOT}" RUSTBOOK=${RUSTBOOK}
}

watch_linux(){
    while  inotifywait -r -e modify "$1"; do
        build
    done
}

watch_mac(){
    fswatch -r "$1" | while read _; do
        build
    done

}

watch(){
    case "$(uname -s)" in
        Darwin) watch_mac "$1";;
        Linux) watch_linux "$1";;
    esac
}

main "$@"
