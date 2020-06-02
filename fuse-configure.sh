#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

script="
export PATH=\"/usr/bin/:\"\$PATH
cd \$HOME
sudo apt-get install -y python3-pip ninja-build
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
bp_list=""
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" $USER_NAME@$machine "$script" > /dev/null &
  bp_list="$bp_list $!"
  echo -e "\t + $machine ADDED :)"
done

echo -e "\nWAITING FOR SETUP TO FINISH..\n"
TOTAL=$(cat $MACHINES | wc -l | sed 's/ //')
DATE=$(date| tr '[:lower:]' '[:upper:]')
echo $DATE
echo -e "CHECKING PIDS STATUS.."
FINISHED=1
while [[ $FINISHED -gt 0 ]]; do
	FINISHED=$TOTAL
	
  states=""
	for pid in $bp_list; do 
		state=$(ps -o state $pid  |tail -n +2)
		states="$states $state"
		if [[ ${#state} -eq 0 ]]; then
			FINISHED=$((FINISHED-1))
		fi;
	done;
	
  #echo $states
  echo "REMAINING: "$FINISHED"/"$TOTAL
	states=${states// /}
	if [[ ${#states} -gt 0 ]]; then
		sleep 30
	fi
done;

DATE=$(date| tr '[:lower:]' '[:upper:]')
echo $DATE
wait

echo ">> WORK IS DONE 🥃"
exit 0
