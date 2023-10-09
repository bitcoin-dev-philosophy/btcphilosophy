#!/bin/bash

URLPREFIX=$1
URLLISTFILE=$2

function shorten() {
  hash=`echo -e "$1" | sha256sum`
  path=${hash:0:8}
  shorturl=${URLPREFIX}${path}
  echo "${shorturl}"
}

function printblock() {
  if [[ "$1" =~ ^//noqr.* ]]; then
    echo -e "$1"
	  return
  fi

  urls=$(echo "$1" | grep -o 'https\?://[^[]\+\[' | sed -e 's/\[$//')

  # if there are URLs in the block, print them and the block itself
  for url in $urls
  do
    shorturl=`shorten "$url"`
    echo -e "[qrcode,role=qrcode]"
    echo -e "----"
    echo -e "${shorturl}"
    echo -e "----\n"
    echo "${shorturl} ${url}" >> $URLLISTFILE
  done
  echo -e "$1"
}

read -r block    # First line only
block+='\n'
while read -r; do
    if [[ $REPLY =~ ^$ ]]; then
        # Do what you like with the contents
        # $block here, then ...
        printblock "$block"
        block=""
    else
        block+="$REPLY\n"
    fi
done
printblock "$block"
