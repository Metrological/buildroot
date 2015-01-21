################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 45f4bb4c133b8e302636735e4e93527efec4f250
ATHOL_SITE = $(call github,WebKitForWayland,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
