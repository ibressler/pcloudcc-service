#!/bin/sh
# Installing libmbedtls3 on Ubuntu as documented here:
# https://github.com/lneely/pcloudcc-lneely/blob/main/doc/MBEDTLS-3.x.md
# EXCEPT: installs under '/usr' instead of '/usr/local' to avoid pcloudcc source mods

sudo apt install -y python3 python3-pip python3-venv
mkdir -p $HOME/src; cd $HOME/src
builddir="$(mktemp -d)"
git clone https://github.com/Mbed-TLS/mbedtls/ "$builddir"
cd "$builddir"
git checkout tags/v3.6.2
git submodule update --init
python3 -m venv ./venv
. ./venv/bin/activate
python3 -m pip install -r scripts/basic.requirements.txt

make DESTDIR=/usr
sudo make DESTDIR=/usr install
sudo ln -s /usr/local/include/mbedtls/ /usr/local/include/mbedtls3

