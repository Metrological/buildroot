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

# Gui was never tested, so we prefer to explicitly disable it
APITRACE_CONF_OPT += -DENABLE_GUI=false

$(eval $(cmake-package))
