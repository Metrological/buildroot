################################################################################
#
# WPE
#
################################################################################

WPE_VERSION = 0.1
WPE_SOURCE = wpe-prerelease.tar.xz
WPE_SITE = http://tmp.igalia.com/wpe/

WPE_INSTALL_STAGING = YES
WPE_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	host-pkgconf zlib pcre libgles libegl cairo freetype fontconfig \
	harfbuzz icu libxml2 libxslt sqlite libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad \
	wayland weston athol

WPE_CONF_OPT = -DPORT=WPE \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"

$(eval $(cmake-package))
