################################################################################
#
# libav
#
################################################################################
LIBAV_VERSION = master
LIBAV_SITE_METHOD = git
LIBAV_SITE = git://git.libav.org/libav.git
LIBAV_INSTALL_STAGING = YES

LIBAV_CONFIGURE_CMDS =	\
	cd $(@D); 	\
	./configure --prefix=/usr --enable-cross-compile --arch=$(BR2_ARCH) --target-os=linux --sysroot=$(STAGING_DIR) --enable-static --enable-shared --disable-sse

$(eval $(autotools-package))
