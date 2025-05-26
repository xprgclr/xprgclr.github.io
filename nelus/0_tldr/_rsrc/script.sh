#!/bin/bash

set -x

sudo apt update && sudo apt upgrade -y
sudo apt install tldr -y
mkdir -p /home/it/.local/share/tldr
tldr -u



