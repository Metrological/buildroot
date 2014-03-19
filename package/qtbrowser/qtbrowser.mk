################################################################################
#
# qtbrowser
#
################################################################################

QTBROWSER_VERSION = 1.0.0
QTBROWSER_SITE = ../qtbrowser
QTBROWSER_SITE_METHOD = local

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
QTBROWSER_DEPENDENCIES = qt5webkit
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QTBROWSER_DEPENDENCIES = qt
endif

define QTBROWSER_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			./qtbrowser.pro \
	)
endef

define QTBROWSER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTBROWSER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qtbrowser $(TARGET_DIR)/usr/bin
endef

define QTBROWSER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/qtbrowser
endef

$(eval $(generic-package))
