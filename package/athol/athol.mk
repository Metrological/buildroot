################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 1aa597990216e2f2a8e111d2056d21a8ea2f9b76
ATHOL_SITE = $(call github,WebKitForWayland,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
