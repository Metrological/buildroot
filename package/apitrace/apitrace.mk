################################################################################
#
# apitrace
#
################################################################################

APITRACE_VERSION = 485846b2a40d8ac7d6c1c5f8af6d15b0c10af19d
APITRACE_SITE = $(call github,apitrace,apitrace,$(APITRACE_VERSION))
APITRACE_LICENSE = MIT
APITRACE_LICENSE_FILES = LICENSE

APITRACE_DEPENDENCIES = host-python

APITRACE_CONF_OPT = -DSYSTEM_EGL=false

ifeq ($(BR2_PACKAGE_XLIB_LIBX11), y)
APITRACE_DEPENDENCIES += xlib_libX11
APITRACE_CONF_OPT += -DENABLE_EGL_NO_X11=false
else
APITRACE_CONF_OPT += -DENABLE_EGL_NO_X11=true
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
APITRACE_DEPENDENCIES += rpi-userland
APITRACE_CFLAGS += -DPLATFORM_RPI $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)"
APITRACE_CXXFLAGS += $(APITRACE_CFLAGS)
APITRACE_LDFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --libs egl)"
endif

ifeq ($(BR2_PACKAGE_INTELCE),y)
APITRACE_DEPENDENCIES += khronos
APITRACE_CFLAGS += -DPLATFORM_INTELCE -I$(STAGING_DIR)/usr/include/intelce/libgdl/
APITRACE_CXXFLAGS += $(APITRACE_CFLAGS)
APITRACE_LDFLAGS += -lgdl
endif

ifeq ($(findstring y,$(BR2_PACKAGE_DAWN_SDK)$(BR2_PACKAGE_BCM_REFSW)),y)
#These platforms are currently not supported
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL), y)
APITRACE_CONF_OPT += \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(APITRACE_CXXFLAGS)" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(APITRACE_CFLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS) $(APITRACE_LDFLAGS)"
endif

ifeq ($(BR2_PACKAGE_APITRACE_GUI),y)
APITRACE_DEPENDENCIES += qt5webkit
APITRACE_CONF_OPT += -DENABLE_GUI=true
else
APITRACE_CONF_OPT += -DENABLE_GUI=false
endif

$(eval $(cmake-package))
