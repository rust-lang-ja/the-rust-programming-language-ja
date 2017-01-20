#!/bin/sh
usage() {
    cat <<HELP
NAME:
   $0 -- watch document dir, build the book and serve built HTML

SYNOPSIS:
  $0 <version>
  $0 [-h|--help]

DESCRIPTION:
  A watch and build and serve script.
  The server will listen on localhost:8080 and document root will be 'public' dir.
  This uses 'rustbook' command.
  You can pass the 'rustbook' path via 'RUSTBOOK' env var.

  -h  --help    Print this help.

EXAMPLE:
  watch and build then serve HTML of 1.6

  $ RUSTBOOK=/path/to/rustbook $0 1.6

BUGS:
  Server program might survive even after you INTed this program.
  Pathes are wellcome!


HELP
}

main() {
    case "$1" in
        -h|--help) usage; exit 0;;
    esac

    RUBY=ruby
    DIR=$(cd "$(dirname "$0")"; pwd)
    ROOT="${DIR}/../"
    set -e
    trap "trap - TERM && pkill -P $$" INT TERM EXIT

    "$RUBY" -run -e httpd -- "${ROOT}/docs" --port 8080 &
    "$DIR/watch.sh" "$@"
}

main "$@"
