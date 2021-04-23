# LibreELEC PMP Build setup

In order to get LibreELEC with PMP building on Ubuntu 20.04 amd64 (Possibly other releases too) there are a few requirements that have to be made after a normal 20.04 amd64 install.

To build a project navigate to the root of the source tree and run one of the two commands:

RPi2: `DISTRO=JellyfinMediaPlayer PROJECT=RPi2 ARCH=arm PMP_REPO=jellyfin-media-player PMP_BRANCH=master make image`

Generic: `DISTRO=JellyfinMediaPlayer PROJECT=Generic ARCH=x86_64 PMP_REPO=jellyfin-media-player PMP_BRANCH=master make image`

## Docker Example Commands
```
docker run --name ubuntu_test --mount type=bind,source="$(pwd)",target=/app -it ubuntu:20.04 bash

dpkg --add-architecture i386
apt update
apt install gcc-multilib libexpat1-dev:i386 libfreetype6-dev:i386 libexpat1-dev libfreetype6-dev fontconfig:i386 build-essential wget bc gawk gperf zip unzip lzop xsltproc openjdk-11-jre-headless libncurses5-dev texi2html libexpat1 patchutils xfonts-utils python python3-pip libjson-perl libxml-parser-perl git curl libparse-yapp-perl

uid=$(stat --format="%u" /app)
echo "user:x:$uid:100:,,,:/home/user:/bin/bash" >> /etc/passwd
echo 'user:*:18718:0:99999:7:::' >> /etc/shadow

su user
cd /app
DISTRO=JellyfinMediaPlayer PROJECT=Generic ARCH=x86_64 PMP_REPO=jellyfin-media-player PMP_BRANCH=master make image

```
