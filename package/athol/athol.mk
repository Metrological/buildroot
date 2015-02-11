################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = a835a4450866a90691e72cc7d550bb6c14bc554e
ATHOL_SITE = $(call github,WebKitForWayland,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
