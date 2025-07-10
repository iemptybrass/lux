#!/usr/bin/env bash
if [ -e "$3" ]; then
  echo "Directory exists"
  export dir="$3"
else
  echo "Directory does not exist"
  export dir="."
fi
