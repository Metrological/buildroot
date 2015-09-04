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

ifeq ($(BR2_PACKAGE_DXDRM_INTERNAL), y)
DXDRM_LOCATOR = internal
else
DXDRM_LOCATOR = external
DXDRM_DEPENDENCIES += openssl
endif

define DXDRM_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libDxDrm.so $(STAGING_DIR)/usr/lib/libDxDrm.so
	$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libTrusted.so $(STAGING_DIR)/usr/lib/libTrusted.so
	$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/dxdrm
	$(INSTALL) -m 644 $(@D)/$(DXDRM_LOCATOR)/include/*.h $(STAGING_DIR)/usr/include/dxdrm
	if [ "x$(BR2_PACKAGE_DXDRM_EXTERNAL)" = "xy" ] ; then \
		$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libprovisioning.so $(STAGING_DIR)/usr/lib/libprovisioning.so; \
		$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libprovisioningproxy.so $(STAGING_DIR)/usr/lib/libprovisioningproxy.so; \
		$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/rpc; \
		$(INSTALL) -m 644 $(@D)/$(DXDRM_LOCATOR)/include/rpc/*.h $(STAGING_DIR)/usr/include/rpc; \
		$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/provisioning; \
		$(INSTALL) -m 644 $(@D)/$(DXDRM_LOCATOR)/include/provisioning/*.h $(STAGING_DIR)/usr/include/provisioning; \
	fi
endef

define DXDRM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libDxDrm.so $(TARGET_DIR)/usr/lib/libDxDrm.so
	$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libTrusted.so $(TARGET_DIR)/usr/lib/libTrusted.so
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/dxdrm
	$(INSTALL) -m 644 $(@D)/$(DXDRM_LOCATOR)/dxdrm.config $(TARGET_DIR)/etc/dxdrm
	if [ "x$(BR2_PACKAGE_DXDRM_INTERNAL)" = "xy" ]; then \
		$(INSTALL) -m 644 $(@D)/$(DXDRM_LOCATOR)/credentials/* $(TARGET_DIR)/etc/dxdrm; \
	fi
	if [ "x$(BR2_PACKAGE_DXDRM_EXTERNAL)" = "xy" ]; then \
		$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libprovisioning.so $(TARGET_DIR)/usr/lib/libprovisioning.so; \
		$(INSTALL) -m 755 $(@D)/$(DXDRM_LOCATOR)/$(call qstrip,$(BR2_ARCH))/release/libprovisioningproxy.so $(TARGET_DIR)/usr/lib/libprovisioningproxy.so; \
	fi
endef

$(eval $(generic-package))
