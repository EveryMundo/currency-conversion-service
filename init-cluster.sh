#!/bin/bash
source $HOME/.nvm/nvm.sh
nvm use stable

set -e

if [ -f .env ]; then
  for line in $(grep -P '^\w+' .env); do
    varName=$(echo "$line" | grep -Po '^\w+')
    eval "TEMPV=\$${varName}"

    if [ "$TEMPV" = "" ]; then
      echo "eval export $line"
      eval "export $line"
    fi;
  done
else
  echo "no .env file found :D"
fi

cd $(dirname $0)

node ./cluster.js