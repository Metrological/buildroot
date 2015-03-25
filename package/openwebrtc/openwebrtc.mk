################################################################################
#
# openwebrtc
#
################################################################################

OPENWEBRTC_VERSION = 659c1bdd1255a636b8e7531c9d3b1a28c1a62473
OPENWEBRTC_SITE = $(call github,Metrological,openwebrtc,$(OPENWEBRTC_VERSION))
OPENWEBRTC_INSTALL_STAGING = YES
OPENWEBRTC_LICENSE = BSD-2 Clause
OPENWEBRTC_LICENSE_FILES = LICENSE


OPENWEBRTC_CONFIGURE_CMDS = \
	(cd $(@D); \
	gtkdocize;  \
	autoreconf --verbose --force --install; \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--program-prefix="" \
		--enable-bridge=no \
		--enable-introspection=no \
		--enable-tests=yes \
		--enable-owr-gst=yes \
		--disable-gtk-doc \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(QUIET) \
	)

OPENWEBRTC_DEPENDENCIES = gstreamer1 gst1-plugins-openwebrtc libnice pulseaudio

$(eval $(autotools-package))
