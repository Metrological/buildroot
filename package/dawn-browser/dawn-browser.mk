################################################################################
#
# dawn-browser
#
################################################################################

DAWN_BROWSER_VERSION = 1.0.0
DAWN_BROWSER_SITE = ../dawn-browser
DAWN_BROWSER_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
DAWN_BROWSER_DEPENDENCIES = qt5webkit
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
DAWN_BROWSER_DEPENDENCIES = qt
endif

define DAWN_BROWSER_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			./dawn-browser.pro \
	)
endef

define DAWN_BROWSER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define DAWN_BROWSER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/dawn-browser $(TARGET_DIR)/usr/bin
endef

define DAWN_BROWSER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/dawn-browser
endef

$(eval $(generic-package))
