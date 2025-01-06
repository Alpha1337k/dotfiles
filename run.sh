#!/usr/bin/env bash

set -euo pipefail

docker build -t dotfiles . 2> /dev/null

docker run --rm -it -v $PWD:/app dotfiles