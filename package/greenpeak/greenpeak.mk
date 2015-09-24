################################################################################
#
# greenpeak
#
################################################################################
GREENPEAK_VERSION = df4154e8a3db403236e122b1479d971df4761495
GREENPEAK_SITE_METHOD = git
GREENPEAK_SITE = git@github.com:Metrological/greenpeak.git
GREENPEAK_DEPENDENCIES = linux

GREENPEAK_CHIP = $(call qstrip,$(BR2_PACKAGE_GREENPEAK_TYPE))

ifeq ($(BR2_PACKAGE_GREENPEAK_USERLANDLIB), y)

GREENPEAK_ARTIFACT = libRf4ce.a
GREENPEAK_INSTALL_STAGING = YES

define GREENPEAK_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/greenpeak;
	$(INSTALL) -D -m 0644 $(@D)/ZRCTarget_GP501_RPi/libRf4ce.a $(STAGING_DIR)/usr/lib/;
	cp -r $(@D)/ZRCTarget_GP501_RPi/code/BaseComps/v2.4.5.2/comps/* $(STAGING_DIR)/usr/include/greenpeak;
endef

else

define GREENPEAK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ZRCTarget_GP501_RPi/Work/ZRCTarget_GP501_RPi.elf $(TARGET_DIR)/usr/bin/zrc
	$(INSTALL) -D -m 0755 package/greenpeak/S40greenpeak $(TARGET_DIR)/etc/init.d
	$(GREENPEAK_INSTALL_MODULE)
endef

endif

GREENPEAK_ARTIFACT = GP_APPLICATION=1
GREENPEAK_EXTRA_CFLAGS = \
	-std=gnu99 \
	-fomit-frame-pointer \
	-fno-strict-aliasing \
	-fno-pic \
	-ffreestanding \
	-DGP_NVM_PATH=/root/gp \
	-DGP_NVM_FILENAME=/root/gp/gpNvm.dat

define GREENPEAK_BUILD_MODULE
	GP_CHIP=$(GREENPEAK_CHIP) $(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D)/driver modules
endef

define GREENPEAK_INSTALL_MODULE
	GP_CHIP=$(GREENPEAK_CHIP) $(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(@D)/driver modules_install
endef

define GREENPEAK_BUILD_CMDS
	COMPILER=buildroot $(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC)" CFLAGS_COMPILER="$(TARGET_CFLAGS) $(GREENPEAK_EXTRA_CFLAGS)" -C $(@D)/ZRCTarget_$(GREENPEAK_CHIP)_RPi ${GREENPEAK_ARTIFACT}
	$(GREENPEAK_BUILD_MODULE)
endef

define GREENPEAK_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/greenpeak;
	$(INSTALL) -D -m 0644 $(@D)/ZRCTarget_GP501_RPi/libRf4ce.a $(STAGING_DIR)/usr/lib/;
	cp -r $(@D)/ZRCTarget_GP501_RPi/code/BaseComps/v2.4.5.2/comps/* $(STAGING_DIR)/usr/include/greenpeak;
endef

$(eval $(generic-package))
