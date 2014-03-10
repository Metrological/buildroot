################################################################################
#
# isl
#
################################################################################

ISL_VERSION = 0.12.2
ISL_SITE = http://isl.gforge.inria.fr
ISL_SOURCE = isl-$(ISL_VERSION).tar.bz2
ISL_LICENSE = LGPLv2+
ISL_LICENSE_FILES = COPYING.LIB
ISL_INSTALL_STAGING = YES
ISL_DEPENDENCIES = gmp host-pkgconf
ISL_AUTORECONF = YES
HOST_ISL_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
