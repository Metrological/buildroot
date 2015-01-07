################################################################################
#
# libsrtp
#
################################################################################

LIBSRTP_VERSION = 2b48665ac51be045e3fe87fbe35d38a3e93e8787
LIBSRTP_SITE = $(call github,cisco,libsrtp,$(LIBSRTP_VERSION))
LIBSRTP_INSTALL_STAGING = YES
LIBSRTP_LICENSE = BSD
LIBSRTP_LICENSE_FILES = LICENCE

#LIBSRTP_AUTORECONF = YES

$(eval $(autotools-package))
