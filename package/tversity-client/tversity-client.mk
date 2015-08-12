################################################################################
#
# tversity-client.
#
################################################################################

TVERSITY_CLIENT_VERSION = master
TVERSITY_CLIENT_SITE = git@github.com:Metrological/tversity-client.git
TVERSITY_CLIENT_SITE_METHOD = git
TVERSITY_CLIENT_LICENSE = PROPRIETARY

TVERSITY_CLIENT_DEPENDENCIES = host-pkgconf libgles libegl \
	libsoup libopenmax \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-good \
	gst1-plugins-bad \
	gst1-plugins-ugly 

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g -DCLOUD_CLIENT_DEBUG" \
	-DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -DCLOUD_CLIENT_DEBUG"
else
BUILDTYPE=Release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2" \
	-DCMAKE_CXX_FLAGS_RELEASE="-O2"
endif

TVERSITY_CLIENT_CONF_OPT = -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
	$(FLAGS) \

$(eval $(cmake-package))
