################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = f7dc8babc812211962028a1fef9b88e32d4b3b45
WEBKITGTK_SITE = $(call github,Metrological,webkitgtk,$(WEBKITGTK_VERSION))
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	icu libxml2 libxslt libgtk3 sqlite enchant libsoup jpeg webp

WEBKITGTK_AUTORECONF = YES

# Give explicit path to icu-config.
WEBKITGTK_CONF_ENV = \
	ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	AR_FLAGS="cru" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"

WEBKITGTK_CONF_OPT = \
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
