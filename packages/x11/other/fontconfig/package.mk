# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="fontconfig"
PKG_VERSION="2.13.1"
PKG_SHA256="9f0d852b39d75fc655f9f53850eb32555394f36104a044bb2b2fc9e66dbbfa7f"
PKG_LICENSE="OSS"
PKG_SITE="http://www.fontconfig.org"
PKG_URL="http://www.freedesktop.org/software/fontconfig/release/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain util-linux util-macros freetype libxml2 zlib expat"
PKG_LONGDESC="Fontconfig is a library for font customization and configuration."

PKG_CONFIGURE_OPTS_TARGET="--with-arch=${TARGET_ARCH} \
                           --with-cache-dir=/storage/.cache/fontconfig \
                           --with-default-fonts=/usr/share/fonts \
                           --without-add-fonts \
                           --disable-dependency-tracking \
                           --disable-docs"

### PLEX
PKG_DEPENDS_HOST="toolchain freetype:host libxml2:host zlib:host"
PKG_CONFIGURE_OPTS_HOST="${PKG_CONFIGURE_OPTS_TARGET} \
			 --with-cache-dir=/usr/share/plexmediaplayer/fc-cache \
			 --enable-static \
			 --disable-shared"

### END PLEX

pre_configure_target() {
# ensure we dont use '-O3' optimization.
  CFLAGS=$(echo ${CFLAGS} | sed -e "s|-O3|-O2|")
  CXXFLAGS=$(echo ${CXXFLAGS} | sed -e "s|-O3|-O2|")
  CFLAGS+=" -I${PKG_BUILD}"
  CXXFLAGS+=" -I${PKG_BUILD}"
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/etc/fonts/conf.d
    cp ${PKG_DIR}/conf.d/*.conf ${INSTALL}/etc/fonts/conf.d
}

### PLEX
pre_configure_host() {
  if [ $ARCH = "arm" ]; then
    PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig
    PKG_CONFIGURE_OPTS_HOST="${PKG_CONFIGURE_OPTS_HOST} \
			    --with-expat-lib=/usr/lib/i386-linux-gnu/ \
			    --disable-largefile \
			    --with-pkgconfigdir=${PKG_CONFIG_PATH}"

    CFLAGS="-m32 -malign-double"
    CXXFLAGS="-m32 -malign-double"
    LDFLAGS="-m32 -L/usr/lib/i386-linux-gnu/"
  fi
}

makeinstall_host() {
  cp $PKG_BUILD/.$HOST_NAME/fc-cache/fc-cache $TOOLCHAIN/bin
}
### END PLEX
