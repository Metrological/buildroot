################################################################################
#
# WPE
#
################################################################################

WPE_VERSION = 16122014
WPE_SITE = https://github.com/WebKitForWayland/webkit/archive
WPE_SOURCE = wpe-$(WPE_VERSION).tar.gz

WPE_INSTALL_STAGING = YES
WPE_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	host-pkgconf zlib pcre libgles libegl cairo freetype fontconfig \
	harfbuzz icu libxml2 libxslt sqlite libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad \
	wayland weston athol

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
BUILDTYPE=Release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

ifeq ($(BR2_PACKAGE_WPE_USE_DXDRM_EME),y)
FLAGS += -DENABLE_DXDRM=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_ENCRYPTED_MEDIA),y)
FLAGS += -DENABLE_ENCRYPTED_MEDIA_V2=ON -DENABLE_ENCRYPTED_MEDIA=ON
endif

WPE_CONF_OPT = -DPORT=WPE \
 -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
 $(FLAGS)

RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests

$(eval $(cmake-package))
