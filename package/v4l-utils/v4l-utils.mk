################################################################################
#
# v4l-utils
#
################################################################################

V4L_UTILS_VERSION = 1.0.1
V4L_UTILS_SOURCE = v4l-utils-$(V4L_UTILS_VERSION).tar.bz2
V4L_UTILS_SITE = http://linuxtv.org/downloads/v4l-utils/
V4L_UTILS_INSTALL_STAGING = YES
V4L_UTILS_LICENSE = GPL2 and LGPL 2.1
V4L_UTILS_LICENSE_FILES = COPYING COPYING.libv4l

V4L_UTILS_AUTORECONF = YES
V4L_UTILS_DEPENDENCIES = libjpeg

ifeq ($(BR2_LARGEFILE),y)
V4L_UTILS_CONF_ENV += \
        CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
        CPPFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))"
endif

$(eval $(autotools-package))
