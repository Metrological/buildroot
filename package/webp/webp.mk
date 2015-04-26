################################################################################
#
# webp
#
################################################################################

WEBP_VERSION = 0.3.1
WEBP_SOURCE = libwebp-$(WEBP_VERSION).tar.gz
WEBP_SITE = https://webp.googlecode.com/files
WEBP_LICENSE = BSD-3c
WEBP_LICENSE_FILES = COPYING
WEBP_INSTALL_STAGING = YES

WEBP_CONF_OPT += \
	--with-jpegincludedir=$(STAGING_DIR)/usr/include \
	--with-jpeglibdir=$(STAGING_DIR)/usr/lib \
	--with-tiffincludedir=$(STAGING_DIR)/usr/include \
	--with-tifflibdir=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_LIBPNG),y)
WEBP_DEPENDENCIES += libpng
WEBP_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=$(STAGING_DIR)/usr/bin/libpng-config
else
WEBP_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=/bin/false
endif

WEBP_DEPENDENCIES += $(if $(BR2_PACKAGE_JPEG),jpeg)
WEBP_DEPENDENCIES += $(if $(BR2_PACKAGE_TIFF),tiff)

define WEBP_REMOVE_TOOLS
	rm -f $(TARGET_DIR)/usr/bin/{d,c}webp
endef

WEBP_POST_INSTALL_TARGET_HOOKS += WEBP_REMOVE_TOOLS

$(eval $(autotools-package))
