################################################################################
#
# webbridge
#
################################################################################

# WEBBRIDGE_VERSION = 00a5981f771edc475aa5568f1cdd660d6aae2189
WEBBRIDGE_VERSION = master
WEBBRIDGE_SITE = $(call github,metrological,webbridge,$(WEBBRIDGE_VERSION))
WEBBRIDGE_LICENSE = GPLv2
WEBBRIDGE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PLUGIN_FANCONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/plugins/fancontrol build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/plugins/fancontrol target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_TRACECONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/plugins/tracecontrol build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/plugins/tracecontrol target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_DELAYEDRESPONSE),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/plugins/delayedresponse build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/plugins/delayedresponse target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SURFACECOMPOSITOR),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/plugins/surfacecompositor build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/plugins/surfacecompositor target ;
	WEBBRIDGE_PLUGIN_INSTALL_STAGING += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/plugins/surfacecompositor staging ;
endif

define WEBBRIDGE_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" CXX=$(TARGET_CXX) -C $(@D)/webbridge build
	$(WEBBRIDGE_PLUGIN_BUILD)
endef

define WEBBRIDGE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/webbridge staging
	$(WEBBRIDGE_PLUGIN_INSTALL_STAGING)
endef

define WEBBRIDGE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/webbridge target
	$(WEBBRIDGE_PLUGIN_INSTALL_TARGET)
endef

$(eval $(generic-package))
