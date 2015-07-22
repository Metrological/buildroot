################################################################################
#
# nrdwrapper
#
################################################################################

NRDWRAPPER_VERSION = d483bdfb2a68465bc9ad914b1505d1f6c431d49c
NRDWRAPPER_SITE_METHOD = git
NRDWRAPPER_SITE = git@github.com:Metrological/nrdwrapper.git
NRDWRAPPER_LICENSE = PROPRIETARY

NRDWRAPPER_DEPENDENCIES = cppsdk

NRDWRAPPER_INSTALL_STAGING = YES

NRDWRAPPER_CXXFLAGS = \
	$(TARGET_CXXFLAGS) -Wall -v 

ifeq ($(BR2_ENABLE_DEBUG),y)
# enable ASSERT
NRDWRAPPER_CXXFLAGS += -D__DEBUG__
endif

ifneq ($(BR2_PACKAGE_CPPSDK),y)
$(error CPPSDK is required. Check BR2_PACKAGE_CPPSDK.)
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL),y)
NRDWRAPPER_DEPENDENCIES   += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))
NRDWRAPPER_EXTRA_CFLAGS   += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)
NRDWRAPPER_EXTRA_CXXFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags  egl)
NRDWRAPPER_EXTRA_LDFLAGS  += $(shell $(PKG_CONFIG_HOST_BINARY) --libs egl)
else
$(error EGL is required. Check BR2_PACKAGE_NRD_GRAPHICS_GLES2_EGL.)
endif

define NRDWRAPPER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CXX="$(TARGET_CXX)" CPPFLAGS="$(TARGET_CPPFLAGS)" CXXFLAGS="$(NRDWRAPPER_CXXFLAGS) $(NRDWRAPPER_EXTRA_CXXFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)/
endef

define NRDWRAPPER_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/libnrdwrapper.{a,so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/nrdwrapper/
	$(INSTALL) -m 755 $(@D)/*.h $(STAGING_DIR)/usr/include/nrdwrapper/
endef

define NRDWRAPPER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/libnrdwrapper.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
