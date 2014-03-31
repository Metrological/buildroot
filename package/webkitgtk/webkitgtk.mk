################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = 91e995fca1c1e85db7ce89ab4773de0e201d2a76
WEBKITGTK_SITE = $(call github,Metrological,webkitgtk,$(WEBKITGTK_VERSION))
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	icu libxml2 libxslt libgtk3 sqlite enchant libsoup jpeg webp

WEBKITGTK_AUTORECONF = YES

WEBKITGTK_EGL_CFLAGS = $(shell PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig pkg-config --define-variable=prefix=$(STAGING_DIR)/usr --cflags egl)

# Give explicit path to icu-config.
WEBKITGTK_CONF_ENV = \
	ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	AR_FLAGS="cru" \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -I$(STAGING_DIR)/usr/include $(WEBKITGTK_EGL_CFLAGS) -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"

WEBKITGTK_CONF_OPT = \
	--disable-webkit1 \
	--disable-credential-storage \
	--disable-geolocation \
	--disable-video \
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
