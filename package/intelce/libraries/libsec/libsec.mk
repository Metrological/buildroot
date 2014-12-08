################################################################################
#
# libsec
#
################################################################################

LIBSEC_VERSION = $(INTELCE_VERSION).0
LIBSEC_SITE = $(INTELCE_SITE)/libsec/
LIBSEC_SITE_METHOD = local
LIBSEC_LICENSE = PROPRIETARY
LIBSEC_REDISTRIBUTE = NO

#LIBSEC_DEPENDENCIES =

LIBSEC_INSTALL_STAGING = YES

define LIBSEC_BUILD_CMDS
endef

define LIBSEC_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/lib/*.so $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libsec/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libsec/
endef

define LIBSEC_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/lib/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
