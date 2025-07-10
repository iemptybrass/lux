#!/usr/bin/env bash
if [ -e "${args[3]}" ]; then
  echo "Directory exists"
  export dir="${args[3]}"
else
  echo "Directory does not exist"
  export dir="."
fi
