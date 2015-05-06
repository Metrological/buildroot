################################################################################
#
# qt5webkit
#
################################################################################

QT5WEBKIT_VERSION = acb5adb43d97b2a5e30998fb20a50657f168b14a
ifeq ($(BR2_QT5WEBKIT_USE_WEBRTC),y)
QT5WEBKIT_VERSION = de07f58fb904c81794af37238e2c0c2989a59898
endif

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

QT5WEBKIT_CONFIG = CONFIG+=silent
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

ifeq ($(findstring y,$(BR2_PACKAGE_MINIBROWSER)$(BR2_PACKAGE_TESTBROWSER)$(BR2_PACKAGE_DUMPRENDERTREE)),y) 
QT5WEBKIT_CONFIG += \
	CONFIG-=production_build \
	WEBKIT_CONFIG-=build_tests \
	WEBKIT_CONFIG-=build_drt \
	WEBKIT_CONFIG-=build_wtr \
	WEBKIT_CONFIG-=build_imagediff \
	WEBKIT_CONFIG-=build_testbrowser \
	WEBKIT_CONFIG-=build_minibrowser \
	WEBKIT_CONFIG-=build_imagediff \
	WEBKIT_CONFIG-=build_qttestsupport
endif

QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=page_visibility_api \
	WEBKIT_CONFIG+=css_variables \
	WEBKIT_CONFIG+=css_image_orientation \
	WEBKIT_CONFIG+=css3_text \
	WEBKIT_CONFIG+=css3_text_line_break \
	WEBKIT_CONFIG+=mathml \
	WEBKIT_CONFIG+=microdata

ifeq ($(BR2_QT5WEBKIT_USE_GSTREAMER),y)
QT5WEBKIT_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=video \
	WEBKIT_CONFIG+=use_gstreamer \
	WEBKIT_CONFIG+=media_source \
	WEBKIT_CONFIG+=web_audio
endif

ifeq ($(BR2_QT5WEBKIT_USE_DXDRM_EME),y)
QT5WEBKIT_DEPENDENCIES += dxdrm
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=use_dxdrm
endif

ifeq ($(BR2_QT5WEBKIT_USE_ENCRYPTED_MEDIA),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=encrypted_media_v2
endif

ifeq ($(BR2_PACKAGE_LIBSOUP),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=use_soup \
	WEBKIT_CONFIG+=use_glib
QT5WEBKIT_DEPENDENCIES+=libsoup
endif

ifeq ($(BR2_PACKAGE_MINIBROWSER),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=build_minibrowser
endif

ifeq ($(BR2_PACKAGE_TESTBROWSER),y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=build_testbrowser \
	WEBKIT_CONFIG+=build_qttestsupport
endif

ifeq ($(BR2_PACKAGE_DUMPRENDERTREE), y)
QT5WEBKIT_CONFIG += \
	WEBKIT_CONFIG+=build_drt
endif

ifeq ($(BR2_QT5WEBKIT_USE_ACCELERATED_CANVAS),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=accelerated_2d_canvas
endif

ifeq ($(BR2_QT5WEBKIT_USE_DISCOVERY),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=discovery
	QT5WEBKIT_DEPENDENCIES += gupnp avahi
endif

ifeq ($(BR2_QT5WEBKIT_USE_LOCATION),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=location
	QT5WEBKIT_DEPENDENCIES += qt5location
endif

ifeq ($(BR2_QT5WEBKIT_USE_WEBINSPECTOR),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=inspector
else
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG-=inspector
endif

ifeq ($(BR2_QT5WEBKIT_USE_SVG),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=svg
else
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG-=svg
endif

ifeq ($(BR2_QT5WEBKIT_USE_ORIENTATION),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=device_orientation \
		WEBKIT_CONFIG+=orientation_events
	QT5WEBKIT_DEPENDENCIES += qt5sensors
endif

ifeq ($(BR2_QT5WEBKIT_USE_WEBRTC),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=media_stream
	QT5WEBKIT_DEPENDENCIES += libnice
endif

ifeq ($(BR2_QT5WEBKIT_ENABLE_JS_MEMORY_TRACKING),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=enable_js_memory_tracking
endif

ifeq ($(BR2_QT5WEBKIT_ENABLE_DUMP_NODE_STATISTICS),y)
	QT5WEBKIT_CONFIG += \
		WEBKIT_CONFIG+=dump_node_statistics
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
