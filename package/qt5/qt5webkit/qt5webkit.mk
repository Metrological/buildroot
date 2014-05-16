################################################################################
#
# qt5webkit
#
################################################################################

QT5WEBKIT_VERSION = 1570f7a108337fbad0235658cd645ff5b54b2f3d
QT5WEBKIT_SITE = $(call github,Metrological,qtwebkit,$(QT5WEBKIT_VERSION))

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

QT5WEBKIT_CONFIG = 
QT5WEBKIT_MAKE_ENV = $(TARGET_MAKE_ENV) QMAKEPATH=$(@D)/Tools/qmake/

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_DEPENDENCIES += qt5declarative
else
QT5WEBKIT_CONFIG += \
	CONFIG-=webkit2
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
QT5WEBKIT_DEPENDENCIES += webp
endif

ifeq ($(BR2_PACKAGE_LIBXSLT),y)
QT5WEBKIT_DEPENDENCIES += libxslt
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
QT5WEBKIT_BUILDDIR = $(@D)/debug
QT5WEBKIT_CONFIG += \
	CONFIG+=debug \
	CONFIG-=release
else
QT5WEBKIT_BUILDDIR = $(@D)/release
QT5WEBKIT_CONFIG += \
	CONFIG-=debug \
	CONFIG+=release
endif

ifeq ($(BR2_QT5WEBKIT_USE_GSTREAMER),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=video \
	WEBKIT_CONFIG+=use_gstreamer \
	WEBKIT_CONFIG+=web_audio
endif

ifeq ($(BR2_PACKAGE_LIBSOUP),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=use_soup
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
	QT5WEBKIT_CONFIG += \
		CONFIG-=production_build
endif


ifeq ($(BR2_QT5WEBKIT_USE_ACCELERATED_CANVAS), y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=accelerated_2d_canvas
endif

ifeq ($(BR2_QT5WEBKIT_USE_DISCOVERY), y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=discovery
	QT5WEBKIT_DEPENDENCIES += gupnp avahi
endif

define QT5WEBKIT_CONFIGURE_CMDS
	(mkdir -p $(QT5WEBKIT_BUILDDIR); cd $(QT5WEBKIT_BUILDDIR); \
		$(QT5WEBKIT_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			$(QT5WEBKIT_CONFIG) ../WebKit.pro \
	)
endef

define QT5WEBKIT_BUILD_CMDS
	$(QT5WEBKIT_MAKE_ENV) $(MAKE) -C $(QT5WEBKIT_BUILDDIR)
endef

define QT5WEBKIT_BUILD_MINIBROWSER
	(mkdir -p $(QT5WEBKIT_BUILDDIR)/minibrowser; cd $(QT5WEBKIT_BUILDDIR)/minibrowser; \
		$(QT5WEBKIT_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake $(@D)/Tools/MiniBrowser/qt/MiniBrowser.pro \
	)
	$(QT5WEBKIT_MAKE_ENV) $(MAKE) LFLAGS="$(LFLAGS) -L$(QT5WEBKIT_BUILDDIR)/lib" -C $(QT5WEBKIT_BUILDDIR)/minibrowser
endef

define QT5WEBKIT_BUILD_TESTBROWSER
	(mkdir -p $(QT5WEBKIT_BUILDDIR)/testbrowser; cd $(QT5WEBKIT_BUILDDIR)/testbrowser; \
		$(QT5WEBKIT_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake $(@D)/Tools/QtTestBrowser/QtTestBrowser.pro \
	)
	$(QT5WEBKIT_MAKE_ENV) $(MAKE) LFLAGS="$(LFLAGS) -L$(QT5WEBKIT_BUILDDIR)/lib" -C $(QT5WEBKIT_BUILDDIR)/testbrowser
endef

define QT5WEBKIT_BUILD_DUMPRENDERTREE
	(mkdir -p $(QT5WEBKIT_BUILDDIR)/drt; cd $(QT5WEBKIT_BUILDDIR)/drt; \
		$(QT5WEBKIT_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake $(@D)/Tools/DumpRenderTree/qt/DumpRenderTree.pro \
	)
	$(QT5WEBKIT_MAKE_ENV) $(MAKE) LFLAGS="$(LFLAGS) -L$(QT5WEBKIT_BUILDDIR)/lib" -C $(QT5WEBKIT_BUILDDIR)/drt
endef

define QT5WEBKIT_INSTALL_STAGING_CMDS
	$(QT5WEBKIT_MAKE_ENV) $(MAKE) -C $(QT5WEBKIT_BUILDDIR) install
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
	cp -dpf $(QT5WEBKIT_BUILDDIR)/bin/* $(TARGET_DIR)/usr/bin/
	$(QT5WEBKIT_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
