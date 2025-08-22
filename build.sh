#!/bin/sh

set -x
set -e

git clone https://github.com/lneely/pcloudcc-lneely.git src
cd src
make && make install

