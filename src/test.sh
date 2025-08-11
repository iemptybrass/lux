#!/usr/bin/env bash
set -euo pipefail

source ./print.sh
print
exec @NIXOS_REBUILD@ "$@"
