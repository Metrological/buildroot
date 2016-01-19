################################################################################
#
# qtwebdriver
#
################################################################################

QTWEBDRIVER_VERSION = WD_1.X_dev
QTWEBDRIVER_SITE = $(call github,cisco-open-source,qtwebdriver,$(QTWEBDRIVER_VERSION))
QTWEBDRIVER_LICENSE = LGPLv2.1

QTWEBDRIVER_DEPENDENCIES = host-gyp
QTWEBDRIVER_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
QTWEBDRIVER_DEPENDENCIES += qt5webkit
endif


define QTWEBDRIVER_CONFIGURE_CMDS
	@echo '  Copying webdriver basic configuration'
	@cp  $(TOPDIR)/package/qt5/qtwebdriver/wd.gypi $(@D)
endef

define QTWEBDRIVER_BUILD_CMDS
	@export QTINCPATH="$(STAGING_DIR)/usr/include/qt5"; export QTBINPATH="$(HOST_DIR)/usr/bin"; cd $(@D); $(TARGET_CONFIGURE_OPTS) ./build.sh ./out mips Release $(STAGING_DIR)
endef

define QTWEBDRIVER_INSTALL_STAGING_CMDS
	cp -dpfru $(@D)/inc $(STAGING_DIR)/usr/include/qt5/QtWebDriver
	cp -dpfu $(@D)/out/bin/mips/Release/* $(STAGING_DIR)/usr/lib
endef

define QTWEBDRIVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/out/bin/mips/Release/*.so $(TARGET_DIR)/usr/lib
endef

define QTWEBDRIVER_UNINSTALL_TARGET_CMDS
#	rm -f $(TARGET_DIR)/usr/bin/qtbrowser
endef

$(eval $(generic-package))
