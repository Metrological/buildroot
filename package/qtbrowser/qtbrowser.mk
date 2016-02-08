################################################################################
#
# qtbrowser
#
################################################################################

QTBROWSER_VERSION = 2.0.14
QTBROWSER_SITE = $(call github,metrological,qtbrowser,$(QTBROWSER_VERSION))
QTBROWSER_LICENSE = GPLv2

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
QTBROWSER_DEPENDENCIES = qt5webkit
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QTBROWSER_DEPENDENCIES = qt
endif

ifeq ($(BR2_PACKAGE_QTWEBDRIVER),y)
QTBROWSER_DEPENDENCIES += qtwebdriver
QTBROWSER_CONFIG += \
	INCLUDEPATH+=$(STAGING_DIR)/usr/include/qt5/QtWebDriver \
	LIBS+="-lchromium_base -lWebDriver_core -lWebDriver_extension_qt_base -lWebDriver_extension_qt_web" \
	BROWSER_CONFIG+=qtwebdriver
endif

define QTBROWSER_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/usr/bin/qmake \
			$(QTBROWSER_CONFIG) ./qtbrowser.pro \
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
