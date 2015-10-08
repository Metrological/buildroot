################################################################################
#
# nrdplugin
#
################################################################################
NRDPLUGIN_VERSION = 5e4f934848215e025ed819a75b36379ee72146b4
NRDPLUGIN_SITE = git@github.com:Metrological/nrdplugin.git
NRDPLUGIN_SITE_METHOD = git
NRDPLUGIN_INSTALL_STAGING = YES
NRDPLUGIN_DEPENDENCIES += 

ifeq ($(BR2_PACKAGE_NRDPLUGIN_QT),y)
ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL),y)
NRDPLUGIN_DEPENDENCIES   += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))
NRDPLUGIN_EXTRA_CFLAGS   += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)
NRDPLUGIN_EXTRA_CXXFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags  egl)
NRDPLUGIN_EXTRA_LDFLAGS  += $(shell $(PKG_CONFIG_HOST_BINARY) --libs egl)
else
$(error EGL is required.)
endif
  NRDPLUGIN_DEPENDENCIES += nrdwrapper qt5webkit
  NRDPLUGIN_PLUGIN_CONFIG = (cd $(@D)/qt5; $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake QMAKE_CXXFLAGS="$(NRDPLUGIN_EXTRA_CXXFLAGS)" ./nrdplugin.pro)
  NRDPLUGIN_PLUGIN_BUILD = $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/qt5
  define NRDPLUGIN_PLUGIN_INSTALL_STAGING
    rm -f $(STAGING_DIR)/usr/lib/libnrdplugin.so*
    $(INSTALL) -D -m 0755 $(@D)/qt5/libnrdplugin.so.1 $(STAGING_DIR)/usr/lib
    ln -s libnrdplugin.so.1 $(STAGING_DIR)/usr/lib/libnrdplugin.so
    mkdir -p $(STAGING_DIR)/usr/include/nrd/
    cp $(@D)/qt5/nrdplugin.h $(STAGING_DIR)/usr/include/nrd/
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

define NRDPLUGIN_CONFIGURE_CMDS
  $(NRDPLUGIN_PLUGIN_CONFIG)
endef

define NRDPLUGIN_BUILD_CMDS
  $(NRDPLUGIN_PLUGIN_BUILD)
endef

define NRDPLUGIN_INSTALL_STAGING_CMDS
  $(NRDPLUGIN_PLUGIN_INSTALL_STAGING)
endef

define NRDPLUGIN_UNINSTALL_STAGING_CMDS
  $(NRDPLUGIN_PLUGIN_UNINSTALL_STAGING)
endef

define NRDPLUGIN_INSTALL_TARGET_CMDS
  $(NRDPLUGIN_PLUGIN_INSTALL_TARGET)
endef

define NRDPLUGIN_UNINSTALL_TARGET_CMDS
  $(NRDPLUGIN_PLUGIN_UNINSTALL_TARGET)
endef

$(eval $(generic-package))
