Apache server, Emscripten, DOSBOX
=================================

History (pole kontrollitud):

```
sudo apt update
sudo apt upgrade -y
sudo apt install apache2 -y
systemctl status apache2 --no-pager

sudo apt install python-is-python3 git wget -y
sudo apt install autogen automake autotools-dev -y
sudo apt install cmake build-essential -y
sudo apt install software-properties-common -y
sudo apt install nodejs unzip -y

cd ~
mkdir apache-emscripten
cd apache-emscripten/

cd ~
git clone https://github.com/libsdl-org/SDL.git -b SDL2
cd SDL/
mkdir build
cd build
../configure
make
sudo make install

ip a # selleks et konrrollida apache tööd
cd ~
git clone https://github.com/emscripten-core/emsdk.git
ls -l
cd emsdk/
./emsdk install latest
./emsdk activate latest
. ./emsdk_env.sh

cd ~
git clone https://github.com/dreamlayers/em-dosbox.git
cd em-dosbox/
./autogen.sh
./configure
emconfigure ./configure
make -j 2

cd ~/emsdk/upstream/emscripten
./emcc -v
cat << BASTA > hello.c
#include <stdio.h>

int main() {
  printf("hello, world!\n");
  return 0;
}
BASTA
./emcc hello.c

node a.out.js

./emcc hello.c -o hello.html
sudo cp hello.* /var/www/html
# hello_sdl now available as http://<vm_ip>/hello_sdl.html

cat << BASTA > hello_sdl.cpp
#include <stdio.h>
#include <SDL/SDL.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

int main(int argc, char** argv) {
  printf("hello, world!\n");

  SDL_Init(SDL_INIT_VIDEO);
  SDL_Surface *screen = SDL_SetVideoMode(256, 256, 32, SDL_SWSURFACE);

#ifdef TEST_SDL_LOCK_OPTS
  EM_ASM("SDL.defaults.copyOnLock = false; SDL.defaults.discardOnLock = true; SDL.defaults.opaqueFrontBuffer = false;");
#endif

  if (SDL_MUSTLOCK(screen)) SDL_LockSurface(screen);
  for (int i = 0; i < 256; i++) {
    for (int j = 0; j < 256; j++) {
#ifdef TEST_SDL_LOCK_OPTS
      // Alpha behaves like in the browser, so write proper opaque pixels.
      int alpha = 255;
#else
      // To emulate native behavior with blitting to screen, alpha component is ignored. Test that it is so by outputting
      // data (and testing that it does get discarded)
      int alpha = (i+j) % 255;
#endif
      *((Uint32*)screen->pixels + i * 256 + j) = SDL_MapRGBA(screen->format, i, j, 255-i, alpha);
    }
  }
  if (SDL_MUSTLOCK(screen)) SDL_UnlockSurface(screen);
  SDL_Flip(screen);

  printf("you should see a smoothly-colored square - no sharp lines but the square borders!\n");
  printf("and here is some text that should be HTML-friendly: amp: |&| double-quote: |\"| quote: |'| less-than, greater-than, html-like tags: |<cheez></cheez>|\nanother line.\n");

  SDL_Quit();

  return 0;
}
BASTA
./emcc hello_sdl.cpp -o hello_sdl.html
sudo cp hello_sdl.* /var/www/html/
# hello_sdl now available as http://<vm_ip>/hello_sdl.html

cd ~/emsdk/
. ./emsdk_env.sh

cd ~/em-dosbox/src/
wget https://www.oocities.org/KindlyRat/GWBASIC.EXE.zip
unzip GWBASIC.EXE.zip
./packager.py gwbasic GWBASIC.EXE
# DON'T WORRY. BE HAPPY. WARNINGS ONLY BELOW:
# ignoring legacy flag --no-heap-copy 
#    (that is the only mode supported now)
# Remember to build the main file with 
#    `-sFORCE_FILESYSTEM` so that it 
#    includes support for loading this file package
sudo cp gwbasic.html GWBASIC.EXE /var/www/html/
sudo cp gwbasic.data /var/www/html/
sudo cp dosbox.* /var/www/html/
# dosbox now available as http://<vm_ip>/dosbox.html
# gwbasic now available as http://<vm_ip>/gwbasic.html

mkdir -p STRYKER
cd STRYKER
wget -c https://image.dosgamesarchive.com/games/strykerfw.zip
unzip strykerfw.zip
cd ..
./packager.py stryker $(pwd)/STRYKER/ STRYKER.EXE
sudo cp stryker.html stryker.data /var/www/html
# game now available as http://<vm_ip>/stryker.html

mkdir -p HERETIC
cd HERETIC
wget -c https://image.dosgamesarchive.com/games/htic-box.zip
unzip htic-box
cd ..
./packager.py heretic $(pwd)/HERETIC/ HERETIC.BAT
sudo cp heretic.html heretic.data /var/www/html
# game now available as http://<vm_ip>/HERETIC.html

```

Links:
======

1. https://emscripten.org/docs/getting_started/downloads.html
2. https://emscripten.org/docs/getting_started/Tutorial.html
3. https://github.com/dreamlayers/em-dosbox
4. https://github.com/emscripten-core/emsdk
5. https://www.dosgamesarchive.com
