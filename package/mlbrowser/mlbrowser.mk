################################################################################
#
# mlbrowser
#
################################################################################

MLBROWSER_VERSION = ebf6586ed9f2d38ac0486c2797eaa885d18df303
MLBROWSER_SITE_METHOD = git
MLBROWSER_SITE = https://github.com/albertd/mlbrowser.git

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
MLBROWSER_DEPENDENCIES = qt5webkit
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
MLBROWSER_DEPENDENCIES = qt
endif

define MLBROWSER_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			DEFINES+=_BROWSER_ \
			DEFINES+=_DEBUG_TOOLS_ \
			./src/mlbrowser.pro \
	)
endef

define MLBROWSER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MLBROWSER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mlbrowser $(TARGET_DIR)/usr/bin
endef

define MLBROWSER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/mlbrowser
endef

$(eval $(generic-package))
