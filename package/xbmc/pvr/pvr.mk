################################################################################
#
# xbmc_pvr
#
################################################################################

PVR_VERSION = 1ed2578d088726c9681c8526467b474d8ae2b504
PVR_SITE = $(call github,adamsutton,xbmc-pvr-addons,$(PVR_VERSION))
PVR_LICENSE = GPLv2
PVR_LICENSE_FILES = LICENSE.GPL

define CREATE_CONFIG_FILE
    cd $(@D); $(TARGET_MAKE_ENV) ./bootstrap
endef

PVR_PRE_CONFIGURE_HOOKS += CREATE_CONFIG_FILE

PVR_CONF_OPT = \
                --disable-oggtest \
                --disable-vorbistest \
                --disable-sdltest \
                --disable-examples \
                --disable-spec

$(eval $(autotools-package))
