################################################################################
#
# Athol
#
################################################################################

ATHOL_VERSION = 7dbbc0e6e0654b8350609959971b32793b25253e
ATHOL_SITE = $(call github,Metrological,athol,$(ATHOL_VERSION))

ATHOL_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
ATHOL_DEPENDENCIES = wayland libinput libglib2
ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release -DBROADCOM_NEXUS=1
else
ATHOL_DEPENDENCIES = wayland libegl libglib2 libinput
ATHOL_CONF_OPT = -DCMAKE_BUILD_TYPE=Release
endif

$(eval $(cmake-package))
