################################################################################
#
# nrdplugin
#
################################################################################
NRDPLUGIN_VERSION = master
NRDPLUGIN_SITE_METHOD = git
NRDPLUGIN_SITE = git@github.com:Metrological/nrdplugin.git
NRDPLUGIN_INSTALL_STAGING = YES
NRDPLUGIN_DEPENDENCIES += nrd qt5base

ifeq ($(BR2_ENABLE_DEBUG),Y)
  NRDPLUGIN_BUILDTYPE=Debug
else
  NRDPLUGIN_BUILDTYPE=Release
endif

define NRDPLUGIN_CONFIGURE_CMDS
        (cd $(@D)/qt5; \
                $(TARGET_MAKE_ENV) \
                $(HOST_DIR)/usr/bin/qmake \
                        ./nrdplugin.pro \
        )
endef

define NRDPLUGIN_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/qt5
endef

define NRDPLUGIN_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0755 $(@D)/qt5/libnrdplugin.so $(STAGING_DIR)/usr/lib
	cp $(@D)/qt5/nrdplugin.h $(STAGING_DIR)/usr/include/nrd
endef

define NRDPLUGIN_UNINSTALL_STAGING_CMDS
        rm -f $(STAGING_DIR)/usr/lib/libnrdplugin.so*
	rm -f $(STAGING_DIR)/usr/include/nrd/nrdplugin.h
endef

define NRDPLUGIN_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/qt5/libnrdplugin.so $(TARGET_DIR)/usr/lib
endef

define NRDPLUGIN_UNINSTALL_TARGET_CMDS
        rm -f $(TARGET_DIR)/usr/lib/libnrdplugin.so*
endef

$(eval $(generic-package))
