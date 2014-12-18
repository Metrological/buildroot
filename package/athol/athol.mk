################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 0.1
ATHOL_SOURCE = athol-prerelease.tar.xz
ATHOL_SITE = http://tmp.igalia.com/wpe/

ATHOL_INSTALL_STAGING = YES
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput

ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
