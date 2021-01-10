#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

script="
export PATH=\$HOME/.local/bin:\$PATH
echo \$PATH
cd \$HOME
sudo apt-get install -y python3-pip
pip3 install --user ninja
pip3 install --user meson==0.55
wget https://github.com/libfuse/libfuse/releases/download/fuse-3.6.2/fuse-3.6.2.tar.xz
tar -xvf fuse-3.6.2.tar.xz
mv fuse-3.6.2 fuse
mkdir -p fuse/build
cd fuse/build
meson ..
ninja
sudo \$HOME/.local/bin/ninja install
for i in '/lib' '/usr/lib' '/usr/local/lib'
do 
  sudo ln -s /usr/local/lib/x86_64-linux-gnu/libfuse3.so \$i/libfuse3.so.3
done

exit 0
"

echo ">> FUSE CONFIGURE "
bp_list=""
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" $USER_NAME@$machine "$script" > /dev/null
  echo -e "\t + $machine FINISHED :)"
done

echo ">> WORK IS DONE 🥃"
exit 0
