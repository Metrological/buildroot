################################################################################
#
# libnice
#
################################################################################

LIBNICE_VERSION = 0.1.13
LIBNICE_SOURCE = libnice-$(LIBNICE_VERSION).tar.gz
LIBNICE_SITE = http://nice.freedesktop.org/releases/
LIBNICE_INSTALL_STAGING = YES
LIBNICE_LICENSE = MPL 1.1 and LGPL 2.1
LIBNICE_LICENSE_FILES = COPYING.MPL COPYING.LGPL

LIBNICE_DEPENDENCIES = gstreamer1

LIBNICE_CONFIGURE_CMDS = \
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
		--enable-introspection=no \
		--disable-gtk-doc \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(QUIET) \
	)

$(eval $(autotools-package))
