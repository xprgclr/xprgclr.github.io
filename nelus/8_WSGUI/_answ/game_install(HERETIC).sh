#!/bin/bash

# for Heretic game
# run after Apache-Emscripten-o0C.md script !

cd ~/emsdk/
. ./emsdk_env.sh
cd ~/em-dosbox/src/

mkdir -p HERETIC
cd HERETIC
wget -c https://image.dosgamesarchive.com/games/htic-box.zip
unzip htic-box
cd ..
./packager.py heretic $(pwd)/HERETIC/ HERETIC.BAT
sudo cp heretic.html heretic.data /var/www/html
# game now available as http://<vm_ip>/HERETIC.html