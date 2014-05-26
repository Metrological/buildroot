################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = 979e5ee3d8a4010b1fb387f4aea96f95bf152be5
WEBKITGTK_SITE = $(call github,Metrological,webkitgtk,$(WEBKITGTK_VERSION))
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	icu libxml2 libxslt libgtk3 sqlite enchant libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

WEBKITGTK_AUTORECONF = YES

WEBKITGTK_DEPENDENCIES += $(if $(BR2_PACKAGE_OPENSSL),ca-certificates)

WEBKITGTK_EGL_CFLAGS = $(shell PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig pkg-config --define-variable=prefix=$(STAGING_DIR)/usr --cflags egl)

# Give explicit path to icu-config.
WEBKITGTK_CONF_ENV = \
	ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	AR_FLAGS="cru" \
	CFLAGS="$(TARGET_CFLAGS) -fno-omit-frame-pointer -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -fno-omit-frame-pointer -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS) -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"

WEBKITGTK_CONF_OPT = \
	--disable-webkit1 \
	--disable-credential-storage \
	--disable-geolocation \
	--disable-web-audio

ifeq ($(BR2_PACKAGE_XORG7),y)
	WEBKITGTK_CONF_OPT += --enable-x11-target
	WEBKITGTK_DEPENDENCIES += xlib_libXt
endif
ifeq ($(BR2_PACKAGE_WAYLAND),y)
	WEBKITGTK_CONF_OPT += --enable-wayland-target
	WEBKITGTK_DEPENDENCIES += wayland
endif

$(eval $(autotools-package))
