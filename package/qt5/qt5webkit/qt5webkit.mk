################################################################################
#
# qt5webkit
#
################################################################################

QT5WEBKIT_VERSION = $(QT5_VERSION)
QT5WEBKIT_SITE = $(QT5_SITE)
QT5WEBKIT_SOURCE = qtwebkit-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_DEPENDENCIES = qt5base sqlite host-ruby host-gperf host-bison host-flex
QT5WEBKIT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WEBKIT_LICENSE = LGPLv2.1 or GPLv3.0
# Here we would like to get license files from qt5base, but qt5base
# may not be extracted at the time we get the legal-info for
# qt5script.
else
QT5WEBKIT_LICENSE = Commercial license
QT5WEBKIT_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBKIT_DEPENDENCIES += xlib_libXext xlib_libXrender
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_DEPENDENCIES += qt5declarative
endif

QT5WEBKIT_CONFIG = 

ifeq ($(BR2_ENABLE_DEBUG),y)
	QT5WEBKIT_DEBUG_CONFIG = "CONFIG+=debug"
	QT5WEBKIT_DEBUG_CONFIG += "CONFIG-=release"
else
	QT5WEBKIT_DEBUG_CONFIG = "CONFIG-=debug"
	QT5WEBKIT_DEBUG_CONFIG += "CONFIG+=release"
endif

ifeq ($(BR2_USE_GSTREAMER),y)
	QT5WEBKIT_GST_CONFIG = \
		WEBKIT_CONFIG+=video \
		WEBKIT_CONFIG+=use_gstreamer
endif

ifeq ($(BR2_USE_DEPRECATED_GSTREAMER),y)
	QT5WEBKIT_GST_CONFIG = \
		WEBKIT_CONFIG+=video \
		WEBKIT_CONFIG+=use_gstreamer010
endif

ifeq ($(BR2_PACKAGE_MINIBROWSER),y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_MINIBROWSER
endif

ifeq ($(BR2_PACKAGE_TESTBROWSER),y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_TESTBROWSER
endif

ifeq ($(BR2_PACKAGE_DUMPRENDERTREE), y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_DUMPRENDERTREE
endif

ifeq ($(findstring y,$(BR2_PACKAGE_MINIBROWSER)$(BR2_PACKAGE_TESTBROWSER)$(BR2_PACKAGE_DUMPRENDERTREE)),y) 
# CONFIG-=production_build enables the build of certain features/functionality required by some tools
	QT5WEBKIT_TOOLS_CONFIG += "CONFIG-=production_build"
endif


ifeq ($(BR2_USE_ACCELERATED_CANVAS), y)
	QT5WEBKIT_CONFIG+=WEBKIT_CONFIG+=accelerated_2d_canvas
endif

ifeq ($(BR2_USE_DISCOVERY), y)
	QT5WEBKIT_CONFIG+=WEBKIT_CONFIG+=discovery
endif

define QT5WEBKIT_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			$(QT5WEBKIT_CONFIG) \
			$(QT5WEBKIT_GST_CONFIG) \
			$(QT5WEBKIT_DEBUG_CONFIG) \
			$(QT5WEBKIT_TOOLS_CONFIG) \
	)
endef

define QT5WEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBKIT_BUILD_MINIBROWSER
	(cd $(@D)/Tools/MiniBrowser/qt; \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
	)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/MiniBrowser/qt
endef

define QT5WEBKIT_BUILD_TESTBROWSER
	(cd $(@D)/Tools/QtTestBrowser; \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
	)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/QtTestBrowser
endef

define QT5WEBKIT_BUILD_DUMPRENDERTREE
	(cd $(@D)/Tools/DumpRenderTree/qt; \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake ./DumpRenderTree.pro \
	)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/DumpRenderTree/qt
endef

define QT5WEBKIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
define QT5WEBKIT_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebKit $(TARGET_DIR)/usr/qml/
endef
endif

define QT5WEBKIT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root/.cache
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebKit*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
	$(QT5WEBKIT_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
