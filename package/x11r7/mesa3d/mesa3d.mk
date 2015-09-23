################################################################################
#
# mesa3d
#
################################################################################

MESA3D_VERSION = 7.10.3
MESA3D_SOURCE = MesaLib-$(MESA3D_VERSION).tar.gz
MESA3D_SITE = ftp://ftp.freedesktop.org/pub/mesa/older-versions/7.x/$(MESA3D_VERSION)
MESA3D_LICENSE = MIT, SGI, Khronos
MESA3D_LICENSE_FILES = docs/license.html

MESA3D_AUTORECONF = YES
MESA3D_INSTALL_STAGING = YES

MESA3D_CONF_OPT = \
	--enable-egl \
	--enable-gles2 \
	--enable-gles-overlay \
	--disable-glu \
	--disable-glw \
	--disable-glut \
	--enable-gallium \
	--with-driver=dri \
	--with-dri-drivers=swrast \
	--disable-static \
	--enable-xcb

MESA3D_DEPENDENCIES = \
	xproto_glproto \
	xlib_libXxf86vm \
	xlib_libXdamage \
	xlib_libXfixes \
	xproto_dri2proto \
	libdrm \
	expat \
	host-xutil_makedepend \
	host-libxml2 \
	host-python \
	host-bison \
	host-flex

$(eval $(autotools-package))
