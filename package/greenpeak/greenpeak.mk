################################################################################
#
# greenpeak
#
################################################################################
GREENPEAK_VERSION = 124d4bcc788f1c94f25dc7b95d846856a62066fa
GREENPEAK_SITE_METHOD = git
GREENPEAK_SITE = git@github.com:Metrological/greenpeak.git

GREENPEAK_DEPENDENCIES = linux

GREENPEAK_CHIP = $(call qstrip,$(BR2_PACKAGE_GREENPEAK_TYPE))

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
	COMPILER=buildroot $(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC)" CFLAGS_COMPILER="$(TARGET_CFLAGS) $(GREENPEAK_EXTRA_CFLAGS)" -C $(@D)/ZRCTarget_GP501_RPi
	$(GREENPEAK_BUILD_MODULE)
endef

define GREENPEAK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ZRCTarget_GP501_RPi/Work/ZRCTarget_GP501_RPi.elf $(TARGET_DIR)/usr/bin/zrc
	$(INSTALL) -D -m 0755 package/greenpeak/S30greenpeak $(TARGET_DIR)/etc/init.d
	$(GREENPEAK_INSTALL_MODULE)
endef

$(eval $(generic-package))
