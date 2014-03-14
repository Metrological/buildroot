################################################################################
#
# apitrace
#
################################################################################

APITRACE_VERSION = 084fe926e8fbbdf41f19d844157e4baac6a6b538
APITRACE_SITE = $(call github,apitrace,apitrace,$(APITRACE_VERSION))
APITRACE_LICENSE = MIT
APITRACE_LICENSE_FILES = LICENSE

APITRACE_DEPENDENCIES = host-python

ifeq ($(BR2_PACKAGE_XLIB_LIBX11), y)
APITRACE_DEPENDENCIES += xlib_libX11
else
APITRACE_CONF_OPT += \
	-DSYSTEM_EGL=false \
	-DENABLE_EGL_NO_X11=true \
	-DCMAKE_CPP_FLAGS="$(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include/interface/vcos/pthreads" 
endif

# Gui was never tested, so we prefer to explicitly disable it
APITRACE_CONF_OPT += -DENABLE_GUI=false

$(eval $(cmake-package))
