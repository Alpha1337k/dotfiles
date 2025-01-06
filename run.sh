#!/usr/bin/env bash

set -euo pipefail

docker build -t dotfiles .

docker run --rm -it -v $PWD:/root dotfiles