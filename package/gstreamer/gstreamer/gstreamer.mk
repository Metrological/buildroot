################################################################################
#
# gstreamer
#
################################################################################

GSTREAMER_VERSION = 0.10.36
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.xz
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_avr32)$(BR2_xtensa)$(BR2_microblaze),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_aarch64),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=yes
endif

GSTREAMER_COMMON_VERSION = 2585de990f508fc7fbe13a4b7c9fb08c68a10aed
GSTREAMER_COMMON_SOURCE = common-$(GSTREAMER_COMMON_VERSION).tar.gz
GSTREAMER_COMMON_SITE = http://cgit.freedesktop.org/gstreamer/common/snapshot/

define GSTREAMER_COMMON_DOWNLOAD
        $(call DOWNLOAD,$(GSTREAMER_COMMON_SITE)$(GSTREAMER_COMMON_SOURCE),$(GSTREAMER_COMMON_SOURCE))
endef

define GSTREAMER_COMMON_EXTRACT
        $(INFLATE.gz) $(DL_DIR)/$(GSTREAMER_COMMON_SOURCE) | \
                $(TAR) $(TAR_STRIP_COMPONENTS)=1 \
                -C $(@D)/common $(TAR_OPTIONS) -
        touch $(@D)/ABOUT-NLS
        touch $(@D)/config.rpath
endef


GSTREAMER_CONF_OPT = \
		--disable-examples \
		--disable-tests \
		--disable-failing-tests \
		--disable-loadsave \
		$(if $(BR2_PACKAGE_GSTREAMER_GST_DEBUG),,--disable-gst-debug) \
		$(if $(BR2_PACKAGE_GSTREAMER_PLUGIN_REGISTRY),,--disable-registry)

GSTREAMER_DEPENDENCIES = libglib2 host-pkgconf host-bison host-flex

$(eval $(autotools-package))
