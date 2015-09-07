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
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/FanControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/FanControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_TRACECONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/TraceControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/TraceControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_DELAYEDRESPONSE),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/DelayedResponse build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/DelayedResponse target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_PROVISIONING),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/Provisioning build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/Provisioning target ;
	WEBBRIDGE_DEPENDENCIES += dxdrm
endif

ifeq ($(BR2_PACKAGE_PLUGIN_DEVICEINFO),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/DeviceInfo build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/DeviceInfo target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_BROWSER),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/Browser build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/Browser target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_I2CCONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/I2CControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/I2CControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SPICONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/SPIControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/SPIControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_TEMPCONTROL),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/TempControl build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/TempControl target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_FILESERVER),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/Plugins/FileServer build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) -C $(@D)/Plugins/FileServer target ;
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SURFACECOMPOSITOR),y)
	WEBBRIDGE_PLUGIN_BUILD += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor build ;
	WEBBRIDGE_PLUGIN_INSTALL_TARGET += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor target ;
	WEBBRIDGE_PLUGIN_INSTALL_STAGING += $(MAKE) NEXUS_TOP=$(BCM_REFSW_DIR) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D)/Plugins/SurfaceCompositor staging ;
	WEBBRIDGE_DEPENDENCIES += bcm-refsw
endif

ifeq ($(BR2_PACKAGE_WEBBRIDGE_DAEMON),y)
	WEBBRIDGE_APPLICATION_FLAGS = "CFLAGS=-D__DAEMON__"
endif

define WEBBRIDGE_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D)/WebBridgeSupport build
	$(MAKE) CXX="$(TARGET_CXX)" $(WEBBRIDGE_APPLICATION_FLAGS) -C $(@D)/WebBridge build
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
