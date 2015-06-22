################################################################################
#
# nrdplugin
#
################################################################################
NRDPLUGIN_VERSION = master
NRDPLUGIN_SITE_METHOD = git
NRDPLUGIN_SITE = git@github.com:Metrological/nrdplugin.git
NRDPLUGIN_INSTALL_STAGING = YES
NRDPLUGIN_DEPENDENCIES += nrd cppsdk

ifeq ($(BR2_ENABLE_DEBUG),Y)
  NRDPLUGIN_BUILDTYPE=Debug
else ifeq ($(BR2_PACKAGE_NRDAPPLICATION_DEBUG),Y)
  NRDPLUGIN_BUILDTYPE=Debug
else
  NRDPLUGIN_BUILDTYPE=Release
endif

ifeq ($(BR2_PACKAGE_NRDPLUGIN_QT),y)
  NRDPLUGIN_DEPENDENCIES += qt5webkit
  NRDPLUGIN_PLUGIN_CONFIG = (cd $(@D)/qt5; $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake ./nrdplugin.pro)
  NRDPLUGIN_PLUGIN_BUILD = $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/qt5
  define NRDPLUGIN_PLUGIN_INSTALL_STAGING
    rm -f $(STAGING_DIR)/usr/lib/libnrdplugin.so*
    $(INSTALL) -D -m 0755 $(@D)/qt5/libnrdplugin.so.1 $(STAGING_DIR)/usr/lib
    ln -s libnrdplugin.so.1 $(STAGING_DIR)/usr/lib/libnrdplugin.so
    cp $(@D)/qt5/nrdplugin.h $(STAGING_DIR)/usr/include/nrd
  endef
  define NRDPLUGIN_PLUGIN_UNINSTALL_STAGING
    rm -f $(STAGING_DIR)/usr/lib/libnrdplugin.so*
    rm -f $(STAGING_DIR)/usr/include/nrd/nrdplugin.h
  endef
  define NRDPLUGIN_PLUGIN_INSTALL_TARGET
    rm -f $(TARGET_DIR)/usr/lib/libnrdplugin.so*
    $(INSTALL) -D -m 0755 $(@D)/qt5/libnrdplugin.so.1 $(TARGET_DIR)/usr/lib
    ln -s libnrdplugin.so.1 $(TARGET_DIR)/usr/lib/libnrdplugin.so
  endef
  define NRDPLUGIN_PLUGIN_UNINSTALL_TARGET
    rm -f $(TARGET_DIR)/usr/lib/libnrdplugin.so*
  endef
endif

ifeq ($(BR2_PACKAGE_NRDAPPLICATION),y)
  
  NRDPLUGIN_APP_BUILD = $(TARGET_CONFIGURE_OPTS) $(MAKE) TYPE=Debug -C $(@D)/app build
  NRDPLUGIN_APP_INSTALL_TARGET = $(MAKE) TYPE=Debug -C $(@D)/app target
endif

define NRDPLUGIN_CONFIGURE_CMDS
  $(NRDPLUGIN_PLUGIN_CONFIG)
  $(NRDPLUGIN_APP_CONFIG)
endef

define NRDPLUGIN_BUILD_CMDS
  $(NRDPLUGIN_PLUGIN_BUILD)
  $(NRDPLUGIN_APP_BUILD)
endef

define NRDPLUGIN_INSTALL_STAGING_CMDS
  $(NRDPLUGIN_PLUGIN_INSTALL_STAGING)
  $(NRDPLUGIN_APP_INSTALL_STAGING)
endef

define NRDPLUGIN_UNINSTALL_STAGING_CMDS
  $(NRDPLUGIN_PLUGIN_UNINSTALL_STAGING)
  $(NRDPLUGIN_APP_UNINSTALL_STAGING)
endef

define NRDPLUGIN_INSTALL_TARGET_CMDS
  $(NRDPLUGIN_PLUGIN_INSTALL_TARGET)
  $(NRDPLUGIN_APP_INSTALL_TARGET)
endef

define NRDPLUGIN_UNINSTALL_TARGET_CMDS
  $(NRDPLUGIN_PLUGIN_UNINSTALL_TARGET)
  $(NRDPLUGIN_APP_UNINSTALL_TARGET)
endef

$(eval $(generic-package))
