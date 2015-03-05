################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 975849b2721dc051972ffec3399fb8dea99c22cf
ATHOL_SITE = $(call github,Metrological,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
