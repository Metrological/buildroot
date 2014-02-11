################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = 44da20da53deb44b94613199b4e8d506fc980b3f
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPT = -DVMCS_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=OFF

define RPI_USERLAND_POST_TARGET_CLEANUP
    rm -Rf $(TARGET_DIR)/usr/src
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
