################################################################################
#
# greenpeak
#
################################################################################
GREENPEAK_VERSION = master
GREENPEAK_SITE_METHOD = git
GREENPEAK_SITE = git@github.com:Metrological/greenpeak.git
GREENPEAK_DEPENDENCIES += linux
GREENPEAK_INSTALL_STAGING = YES
GREENPEAK_ENVIRONMENT = ARCH=$(call qstrip,${BR2_ARCH}) \
			KERNELDIR=$(@D)/../linux-$(call qstrip,${BR2_LINUX_KERNEL_VERSION})/ \
			CROSS_COMPILE=$(TARGET_CROSS) 
GREENPEAK_TARGET_DIR  = $(TARGET_DIR)/lib/modules

ifeq ($(BR2_PACKAGE_GREENPEAK_GP500),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP500 EXTRA_FLAGS="-DGP500" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP500_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

ifeq ($(BR2_PACKAGE_GREENPEAK_GP501),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP501 EXTRA_FLAGS="-DGP501" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP501_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

ifeq ($(BR2_PACKAGE_GREENPEAK_GP510),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP510 EXTRA_FLAGS="-DGP510" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP510_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

ifeq ($(BR2_PACKAGE_GREENPEAK_GP710),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP710 EXTRA_FLAGS="-DGP710" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP710_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

ifeq ($(BR2_PACKAGE_GREENPEAK_GP711),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP711 EXTRA_FLAGS="-DGP711" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP711_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

ifeq ($(BR2_PACKAGE_GREENPEAK_GP712),y)
  GREENPEAK_BUILD_CMDS += $(GREENPEAK_ENVIRONMENT) GP_CHIP=GP712 EXTRA_FLAGS="-DGP712" $(MAKE) -C $(@D)/driver ;
  GREENPEAK_INSTALL_TARGET += $(INSTALL) -D $(@D)/driver/greenpeak_GP712_drv.ko $(GREENPEAK_TARGET_DIR) ;
endif

define GREENPEAK_INSTALL_STAGING_CMDS
  $(INSTALL) -m 755 -D $(@D)/driver/load /$(TARGET_DIR)/etc/init.d/greenpeak
  $(GREENPEAK_INSTALL_TARGET)
endef

$(eval $(generic-package))
