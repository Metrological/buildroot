################################################################################
#
# cloog
#
################################################################################

CLOOG_VERSION = 0.18.1
CLOOG_SITE = http://www.bastoul.net/cloog/pages/download
CLOOG_SOURCE = cloog-$(CLOOG_VERSION).tar.gz
CLOOG_LICENSE = LGPLv2+
CLOOG_LICENSE_FILES = COPYING.LIB
CLOOG_INSTALL_STAGING = YES
CLOOG_CONF_OPT = --with-isl=system
CLOOG_DEPENDENCIES = gmp isl host-pkgconf
CLOOG_AUTORECONF = YES
HOST_CLOOG_AUTORECONF = YES
HOST_CLOOG_CONF_OPT = --with-isl=system

$(eval $(autotools-package))
$(eval $(host-autotools-package))
