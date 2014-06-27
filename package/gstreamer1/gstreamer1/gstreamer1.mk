################################################################################
#
# gstreamer1
#
################################################################################

GSTREAMER1_VERSION = 1.3.3
GSTREAMER1_SOURCE = gstreamer-$(GSTREAMER1_VERSION).tar.gz
GSTREAMER1_SITE = http://cgit.freedesktop.org/gstreamer/gstreamer/snapshot/
GSTREAMER1_INSTALL_STAGING = YES
GSTREAMER1_LICENSE_FILES = COPYING
GSTREAMER1_LICENSE = LGPLv2+ LGPLv2.1+

GSTREAMER1_AUTORECONF = YES
GSTREAMER1_AUTORECONF_OPT = -I $(@D)/m4 -I $(@D)/common/m4

GSTREAMER1_POST_DOWNLOAD_HOOKS += GSTREAMER1_COMMON_DOWNLOAD
GSTREAMER1_POST_EXTRACT_HOOKS += GSTREAMER1_COMMON_EXTRACT
GSTREAMER1_PRE_CONFIGURE_HOOKS += GSTREAMER1_FIX_AUTOPOINT

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_avr32)$(BR2_xtensa)$(BR2_microblaze),y)
GSTREAMER1_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_aarch64),y)
GSTREAMER1_CONF_ENV = as_cv_unaligned_access=yes
endif

GSTREAMER1_CONF_OPT = \
	--disable-examples \
	--disable-tests \
	--disable-failing-tests \
	--disable-debug \
	--disable-valgrind \
	--disable-benchmarks \
	--disable-check \
	$(if $(BR2_PACKAGE_GSTREAMER1_TRACE),,--disable-trace) \
	$(if $(BR2_PACKAGE_GSTREAMER1_PARSE),,--disable-parse) \
	$(if $(BR2_PACKAGE_GSTREAMER1_GST_DEBUG),,--disable-gst-debug) \
	$(if $(BR2_PACKAGE_GSTREAMER1_PLUGIN_REGISTRY),,--disable-registry) \
	$(if $(BR2_PACKAGE_GSTREAMER1_INSTALL_TOOLS),,--disable-tools)

GSTREAMER1_DEPENDENCIES = libglib2 host-pkgconf host-bison host-flex host-gettext

$(eval $(autotools-package))
