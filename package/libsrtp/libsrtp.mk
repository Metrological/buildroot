################################################################################
#
# libsrtp
#
################################################################################

LIBSRTP_VERSION = v1.5.2
LIBSRTP_SITE = $(call github,cisco,libsrtp,$(LIBSRTP_VERSION))
LIBSRTP_INSTALL_STAGING = YES
LIBSRTP_LICENSE = BSD
LIBSRTP_LICENSE_FILES = LICENCE

#LIBSRTP_AUTORECONF = YES

$(eval $(autotools-package))
