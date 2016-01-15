################################################################################
#
# gyp
#
################################################################################

GYP_VERSION = 4ff48eb1830766226851646525de2d68336c2e84
GYP_SITE = https://chromium.googlesource.com/external/gyp.git
GYP_SITE_METHOD=git
GYP_LICENSE = LGPLv2.1
GYP_INSTALL_STAGING = NO
GYP_DEPENDENCIES = host-python host-python-setuptools


define GYP_CONFIGURE_CMDS
	cp  $(TOPDIR)/package/qt5/qtwebdriver/wd.gypi $(@D)
endef

define HOST_GYP_BUILD_CMDS
	@echo ___BUILDING THE GYP HOST COMMANDS___
endef

define HOST_GYP_INSTALL_CMDS
	@cd $(@D); $(TARGET_MAKE_ENV) python setup.py install
endef

define GYP_UNINSTALL_TARGET_CMDS
#	rm -f $(TARGET_DIR)/usr/bin/qtbrowser
endef

$(eval $(host-generic-package))
