################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 57de71693ceaa825a15c0044eec231f2c7132946
ATHOL_SITE = $(call github,Metrological,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
