#!/bin/bash

MACHINES_LIST="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

script="
rm -Rf \$HOME/fuse \$HOME/fuse.tar.xz
for i in '/lib' '/usr/lib' '/usr/local/lib'
do
  sudo unlink \$i/libfuse3.so.3
done
"

for machine in $(cat "$MACHINES_LIST")
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" $USER_NAME@$machine "$script"
  echo -e "\t + $machine CLEANED :)"
done

exit 0
