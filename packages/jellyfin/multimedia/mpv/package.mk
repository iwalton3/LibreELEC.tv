################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="mpv"
PKG_VERSION="old-master"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://nightlies.plex.tv"
PKG_URL="$PKG_SITE/directdl/plex-oe-sources/$PKG_NAME-dummy.tar.gz"
PKG_DEPENDS_TARGET="toolchain libass qt5 libdrm alsa uchardet"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="MPV Movie Player
PKG_LONGDESC="
PKG_TOOLCHAIN="manual"

PKG_CONFIGURE_OPTS_TARGET="--enable-libmpv-shared --disable-libsmbclient --disable-apple-remote --prefix=${SYSROOT_PREFIX}/usr"

# ensure we get proper debug info on mpv
CFLAGS="-g3 -ggdb"

# generate debug symbols for this package
# if we want to
DEBUG=$PLEX_DEBUG

# Handle ffmpeg / codec dependencies
if [ "$CODECS" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET ffmpeg-codecs gnutls"

  case $PROJECT in
    Generic)
      PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET intel-vaapi-driver libvdpau"
    ;;
  esac 
else
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET ffmpeg-plex" 
fi

unpack() {
  mkdir $BUILD/${PKG_NAME}-${PKG_VERSION}
  
  git clone -b $PKG_VERSION git@github.com:plexinc/mpv.git $BUILD/${PKG_NAME}-${PKG_VERSION}/.

  cd  $BUILD/${PKG_NAME}-${PKG_VERSION}/
  git remote add upstream https://github.com/mpv-player/mpv.git
  git fetch upstream
  cd  $BUILD
}

configure_target() {
  cd ${BUILD}/${PKG_NAME}-${PKG_VERSION}
  ./bootstrap.py
  ./waf configure ${PKG_CONFIGURE_OPTS_TARGET}
}

make_target() {
  cd ${BUILD}/${PKG_NAME}-${PKG_VERSION}
  ./waf build
}

makeinstall_target() {
  cd ${BUILD}/${PKG_NAME}-${PKG_VERSION}
  ./waf install

  mkdir -p $INSTALL/usr/lib
  cp ${SYSROOT_PREFIX}/usr/lib/libmpv.so ${INSTALL}/usr/lib

  cd ${INSTALL}/usr/lib/
  ln -s libmpv.so libmpv.so.1

  cd ${ROOT}

  debug_strip ${INSTALL}/usr/lib
}

pre_install()
{
 deploy_symbols
}
