################################################################################
#
# webbridge
#
################################################################################

# WEBBRIDGE_VERSION = 00a5981f771edc475aa5568f1cdd660d6aae2189
WEBBRIDGE_VERSION = master
WEBBRIDGE_SITE = ssh://git@git.integraal.info/~/webbridge
WEBBRIDGE_SITE_METHOD = git
WEBBRIDGE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PLUGIN_FANCONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/plugins/fancontrol build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/plugins/fancontrol target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SURFACECOMPOSITOR),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR)/nexus CXX=$(TARGET_CXX) -C $(@D)/plugins/surfacecompositor build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR)/nexus -C $(@D)/plugins/surfacecompositor target ;
	WEBBRIDGE_PLUGIN_INSTALL_STAGING += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR)/nexus -C $(@D)/plugins/surfacecompositor staging ;
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
