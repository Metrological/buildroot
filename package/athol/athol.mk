################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 0df4a13e712533ef333c3f4eddfe334f375b65e2
ATHOL_SITE = $(call github,Metrological,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
