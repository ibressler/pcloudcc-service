#!/bin/sh

set -x
set -e

[ -f /etc/os-release ] && . /etc/os-release

if ! command -v apt-get > /dev/null; then
    echo "Apt seems not available, not on Debian/Ubuntu? "
    echo "-> Please adjust build script, thanks!"
    exit 1
fi

if ! command -v sudo > /dev/null && [ "$(id -u)" -eq 0 ]; then
    # assuming we run as root
    apt-get update
    apt-get install -y sudo
fi

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git build-essential libreadline-dev libsqlite3-dev libfuse-dev \
    libboost-program-options-dev libudev-dev
sh get_mbedtls3.sh

