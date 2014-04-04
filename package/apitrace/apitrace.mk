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

ifeq ($(BR2_PACKAGE_XLIB_LIBX11), y)
APITRACE_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
APITRACE_CFLAGS += -DPLATFORM_RPI
APITRACE_CXXFLAGS += -DPLATFORM_RPI
endif

ifeq ($(findstring y,$(BR2_PACKAGE_DAWN_SDK)$(BR2_PACKAGE_BCM_REFSW)),y)
#These platforms are currently not supported
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL), y)
APITRACE_CONF_OPT += \
	-DSYSTEM_EGL=false \
	-DENABLE_EGL_NO_X11=true \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(APITRACE_CXXFLAGS) $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(APITRACE_CFLAGS) $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)" \
	-DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS) $(APITRACE_LDFLAGS) $(shell $(PKG_CONFIG_HOST_BINARY) --libs egl)"
endif

ifeq ($(BR2_PACKAGE_APITRACE_GUI),y)
APITRACE_DEPENDENCIES = qt5webkit
APITRACE_CONF_OPT += -DENABLE_GUI=true
else
APITRACE_CONF_OPT += -DENABLE_GUI=false
endif

$(eval $(cmake-package))
