################################################################################
#
# openwebrtc
#
################################################################################

OPENWEBRTC_VERSION = 659c1bdd1255a636b8e7531c9d3b1a28c1a62473
OPENWEBRTC_SITE = $(call github,Metrological,openwebrtc,$(OPENWEBRTC_VERSION))
OPENWEBRTC_INSTALL_STAGING = YES
OPENWEBRTC_AUTORECONF = YES
OPENWEBRTC_LICENSE = BSD-2 Clause
OPENWEBRTC_LICENSE_FILES = LICENSE

OPENWEBRTC_DEPENDENCIES = gstreamer1 gst1-plugins-openwebrtc libnice pulseaudio

OPENWEBRTC_CONF_OPT += \
	--enable-bridge=no \
	--enable-introspection=no \
	--enable-owr-gst=yes \
	--disable-gtk-doc

ifeq ($(BR2_PACKAGE_OPENWEBRTC_ENABLE_TESTS),y)
OPENWEBRTC_CONF_OPT += --enable-tests=yes
else
OPENWEBRTC_CONF_OPT += --enable-tests=no
endif

$(eval $(autotools-package))
