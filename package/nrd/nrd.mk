################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = master
NRD_SITE = $(call github,Metrological,nrd,$(NRD_VERSION))

NRD_INSTALL_STAGING = YES
NRD_DEPENDENCIES = libasound

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
BUILDTYPE=Release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

NRD_CONF_OPT = -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
 $(FLAGS)

$(eval $(cmake-package))
