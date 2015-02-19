################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = bda02c3915d2994b4cc4374b3aa5ae3719ad91f4
ATHOL_SITE = $(call github,WebKitForWayland,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
