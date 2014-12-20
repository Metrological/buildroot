################################################################################
#
# webbridge
#
################################################################################

# WEBBRIDGE_VERSION = 00a5981f771edc475aa5568f1cdd660d6aae2189
WEBBRIDGE_VERSION = master
WEBBRIDGE_SITE_METHOD = git
WEBBRIDGE_SITE = git@github.com:Metrological/webbridge.git
WEBBRIDGE_INSTALL_STAGING = YES
WEBBRIDGE_DEPENDENCIES += cppsdk

ifeq ($(BR2_PACKAGE_PLUGIN_FANCONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/Plugins/FanControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/FanControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_TRACECONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/Plugins/TraceControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/TraceControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_DELAYEDRESPONSE),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/Plugins/DelayedResponse build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/DelayedResponse target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_DEVICEINFO),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/Plugins/DeviceInfo build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/DeviceInfo target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_BROWSER),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX=$(TARGET_CXX) -C $(@D)/Plugins/QtBrowser build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/QtBrowser target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SURFACECOMPOSITOR),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor target ;
	WEBBRIDGE_PLUGIN_INSTALL_STAGING += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor staging ;
	WEBBRIDGE_DEPENDENCIES += bcm-refsw
endif

define WEBBRIDGE_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" CXX=$(TARGET_CXX) -C $(@D)/WebBridgeSupport build
	$(MAKE) CXX="$(TARGET_CXX)" CXX=$(TARGET_CXX) -C $(@D)/WebBridge build
	$(WEBBRIDGE_PLUGIN_BUILD)
endef

define WEBBRIDGE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/WebBridgeSupport staging
	$(MAKE) -C $(@D)/WebBridge staging
	$(WEBBRIDGE_PLUGIN_INSTALL_STAGING)
endef

define WEBBRIDGE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/WebBridgeSupport target
	$(MAKE) -C $(@D)/WebBridge target
	$(WEBBRIDGE_PLUGIN_INSTALL_TARGET)
endef

$(eval $(generic-package))
