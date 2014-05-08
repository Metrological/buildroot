################################################################################
#
# libnice
#
################################################################################

LIBNICE_VERSION = 0.1.7
LIBNICE_SOURCE = libnice-$(LIBNICE_VERSION).tar.gz
LIBNICE_SITE = http://nice.freedesktop.org/releases/
LIBNICE_INSTALL_STAGING = YES
LIBNICE_LICENSE = MPL 1.1 and LGPL 2.1
LIBNICE_LICENSE_FILES = COPYING.MPL COPYING.LGPL

LIBNICE_AUTORECONF = YES

$(eval $(autotools-package))
