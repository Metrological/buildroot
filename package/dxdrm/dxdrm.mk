################################################################################
#
# dxdrm
#
################################################################################

DXDRM_VERSION = 1.6.0
DXDRM_SITE = ../dxdrm
DXDRM_SITE_METHOD = local
DXDRM_LICENSE = PROPRIETARY
DXDRM_REDISTRIBUTE = NO

DXDRM_INSTALL_STAGING = YES

DXDRM_DEPENDENCIES = libcurl

define DXDRM_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 $(@D)/$(call qstrip,$(BR2_ARCH))/libDxDrm.so $(STAGING_DIR)/usr/lib/libDxDrm.so
	$(INSTALL) -m 755 $(@D)/$(call qstrip,$(BR2_ARCH))/libTrusted.so $(STAGING_DIR)/usr/lib/libTrusted.so
	$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/dxdrm
	$(INSTALL) -m 644 $(@D)/include/*.h $(STAGING_DIR)/usr/include/dxdrm
endef

define DXDRM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/$(call qstrip,$(BR2_ARCH))/libDxDrm.so $(TARGET_DIR)/usr/lib/libDxDrm.so
	$(INSTALL) -m 755 $(@D)/$(call qstrip,$(BR2_ARCH))/libTrusted.so $(TARGET_DIR)/usr/lib/libTrusted.so
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/dxdrm
	$(INSTALL) -m 644 $(@D)/dxdrm.config $(TARGET_DIR)/etc/dxdrm
	$(INSTALL) -m 644 $(@D)/credentials/* $(TARGET_DIR)/etc/dxdrm
endef

$(eval $(generic-package))
