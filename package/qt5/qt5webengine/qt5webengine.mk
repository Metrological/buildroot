################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = 7bb72a0b500f9ea7d8b3b37adc24a2700a309d2d
QT5WEBENGINE_SITE = https://github.com/metrological/qtwebengine.git
QT5WEBENGINE_SITE_METHOD = gitdev
QT5WEBENGINE_DEPENDENCIES = qt5base qt5declarative libcap sqlite dbus libdrm pciutils host-ruby host-gperf host-bison host-flex
QT5WEBENGINE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WEBENGINE_LICENSE = LGPLv2.1 or GPLv3.0
# Here we would like to get license files from qt5base, but qt5base
# may not be extracted at the time we get the legal-info for
# qt5script.
else
QT5WEBENGINE_LICENSE = Commercial license
QT5WEBENGINE_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBENGINE_DEPENDENCIES += xlib_libXext xlib_libXrender
endif

define QT5WEBENGINE_INIT_REPOSITORY
	(cd $(@D); \
		./init-repository.py \
	)
endef

define QT5WEBENGINE_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
	)
endef

define QT5WEBENGINE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBENGINE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
define QT5WEBENGINE_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebEngine $(TARGET_DIR)/usr/qml/
endef
endif

define QT5WEBENGINE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root/.cache
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebEngine*.so.* $(TARGET_DIR)/usr/lib
endef

QT5WEBENGINE_POST_EXTRACT_HOOKS += QT5WEBENGINE_INIT_REPOSITORY

$(eval $(generic-package))
