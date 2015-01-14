################################################################################
#
# RTL8192-DU
#
################################################################################

RTL8192DU_VERSION = 28a74b240efcc1e3e180dd5a1c91f797e98f9567
RTL8192DU_SITE = https://github.com/chris-rebox/rtl8192du.git
RTL8192DU_SITE_METHOD = git
RTL8192DU_DEPENDENCIES = linux

# rtl81DU
ifeq ($(BR2_PACKAGE_RTL8192DU),y)
RTL8192DU_FIRMWARE_FILES += \
	rtl8192dufw.bin
endif


define RTL8192DU_BUILD_CMDS
 $(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D)
endef

define RTL8192DU_INSTALL_TARGET_CMDS
 $(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D) modules_install

	mkdir -p $(TARGET_DIR)/lib/firmware/rtlwifi
	$(INSTALL) -m 0644 $(@D)/$(RTL8192DU_FIRMWARE_FILES) \
		$(TARGET_DIR)/lib/firmware/rtlwifi
endef

$(eval $(generic-package))