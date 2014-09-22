################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = b7969ed6e1518eb41e10a37e962e347b2d03101e
WEBKITGTK_SITE = $(call github,Metrological,webkitgtk,$(WEBKITGTK_VERSION))
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	host-pkgconf zlib pcre libgles libegl \
	icu libxml2 libxslt libgtk3 sqlite enchant libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

WEBKITGTK_CONF_OPT = -DPORT=GTK \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG" \
 -DENABLE_X11_TARGET=OFF \
 -DENABLE_WAYLAND_TARGET=ON \
 -DENABLE_CREDENTIAL_STORAGE=OFF


RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests

$(eval $(cmake-package))
