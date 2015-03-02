################################################################################
#
# stubs
#
################################################################################

STUBS_VERSION = f0bfcb7c08c4fbe5aa442e52ecbed081688a45a9
STUBS_SITE = $(call github,Metrological,stubs,$(STUBS_VERSION))

STUBS_INSTALL_STAGING = YES

ifeq ($(BR2_ENABLE_DEBUG),Y)
  STUBS_BUILDTYPE=Debug
else
  STUBS_BUILDTYPE=Release
endif

ifeq ($(BR2_PACKAGE_DDPSTUB),y)
  STUBS_DDPSTUB_BUILD = $(MAKE) CC=$(TARGET_CC_NOCCACHE) TYPE=$(STUBS_BUILDTYPE) -C $(@D)/ddpstub build
  STUBS_DDPSTUB_INSTALL_STAGING = $(MAKE) TYPE=$(STUBS_BUILDTYPE) -C $(@D)/ddpstub staging
  STUBS_DDPSTUB_INSTALL_TARGET = $(MAKE) TYPE=$(STUBS_BUILDTYPE) -C $(@D)/ddpstub target
endif
define STUBS_BUILD_CMDS
  $(STUBS_DDPSTUB_BUILD)
endef
define STUBS_INSTALL_STAGING_CMDS
  $(STUBS_DDPSTUB_INSTALL_STAGING)
endef
define STUBS_INSTALL_TARGET_CMDS
  $(STUBS_DDPSTUB_INSTALL_TARGET)
endef

$(eval $(generic-package))
