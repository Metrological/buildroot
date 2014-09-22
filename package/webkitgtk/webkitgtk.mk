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

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g" \
 -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g"
else
BUILDTYPE=Release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG"
endif

WEBKITGTK_CONF_OPT = -DPORT=GTK \
 -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
 $(FLAGS) \
 -DENABLE_X11_TARGET=OFF \
 -DENABLE_WAYLAND_TARGET=ON \
 -DENABLE_CREDENTIAL_STORAGE=OFF


RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests

$(eval $(cmake-package))
