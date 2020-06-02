#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

script="
cd \$HOME
sudo apt install -y python3-pip ninja-build
pip3 install --user meson
wget https://github.com/libfuse/libfuse/releases/download/fuse-3.6.2/fuse-3.6.2.tar.xz
tar -xvf fuse-3.6.2.tar.xz
cd fuse-3.6.2
mkdir build; cd build
\$HOME/.local/bin/meson ..
ninja
sudo ninja install
for i in '/lib' '/usr/lib' '/usr/local/lib'
do 
  sudo ln -s /usr/local/lib/x86_64-linux-gnu/libfuse3.so \$i/libfuse3.so.3
done

exit 0
"

echo ">> FUSE CONFIGURE "
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" $USER_NAME@$machine "$script" > /dev/null
  echo -e "\t + $machine DONE :)"
done

echo ">> WORK IS DONE 🥃"
exit 0
