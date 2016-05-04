################################################################################
#
# libpng
#
################################################################################

LIBPNG_VERSION = 1.5.15
LIBPNG_SERIES = 15
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.xz
LIBPNG_SITE = http://downloads.sourceforge.net/project/libpng/libpng${LIBPNG_SERIES}/older-releases/$(LIBPNG_VERSION)
LIBPNG_LICENSE = libpng license
LIBPNG_LICENSE_FILES = LICENSE
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkgconf zlib
LIBPNG_CONFIG_SCRIPTS = libpng$(LIBPNG_SERIES)-config libpng-config
LIBPNG_CONF_OPT = $(if $(BR2_ARM_CPU_HAS_NEON),--enable-arm-neon=on,--enable-arm-neon=off)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
