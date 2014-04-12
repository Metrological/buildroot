
#
# base
#
################################################################################

XBMCBASE_VERSION = 7f24c5655aed37e2b27540d7b8077ed9d6dccc9a
XBMCBASE_SITE = $(call github,xbmc,xbmc,$(XBMCBASE_VERSION))
XBMCBASE_LICENSE = GPLv2
XBMCBASE_LICENSE_FILES = LICENSE.GPL
XBMCBASE_DEPENDENCIES = host-lzo host-sdl_image host-swig host-gzip host-gettext
XBMCBASE_DEPENDENCIES += boost bzip2 expat flac fontconfig freetype jasper jpeg \
	libass libcdio libcurl libfribidi libgcrypt libmad libmodplug libmpeg2 \
	libogg libplist libpng libsamplerate libungif libvorbis libxml2 libxslt lzo ncurses \
	openssl pcre python readline sqlite taglib tiff tinyxml yajl zlib

XBMCBASE_CONF_ENV += PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)"
XBMCBASE_CONF_ENV += PYTHON_LDFLAGS="-L$(STAGING_DIR)/usr/lib/ -lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm"
XBMCBASE_CONF_ENV += PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)"
XBMCBASE_CONF_ENV += PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages"
XBMCBASE_CONF_ENV += PYTHON_NOVERSIONCHECK="no-check"
XBMCBASE_CONF_ENV += TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

XBMCBASE_CONF_OPT +=  --disable-alsa --disable-crystalhd --disable-debug \
	--disable-dvdcss --disable-gl --disable-hal --disable-joystick \
	--disable-mysql --disable-openmax --disable-optical-drive \
	--disable-projectm --disable-pulse --disable-sdl --disable-ssh \
	--disable-vaapi --disable-vdpau --disable-vtbdecoder --disable-x11 \
	--disable-xrandr --enable-gles --enable-optimizations

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
XBMCBASE_DEPENDENCIES += rpi-userland
XBMCBASE_CONF_OPT += --with-platform=raspberry-pi --enable-player=omxplayer
XBMCBASE_CONF_ENV += INCLUDES="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
XBMCBASE_DEPENDENCIES += dbus
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBUSB),y)
XBMCBASE_DEPENDENCIES += libusb-compat
XBMCBASE_CONF_OPT += --enable-libusb
else
XBMCBASE_CONF_OPT += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBMICROHTTPD),y)
XBMCBASE_DEPENDENCIES += libmicrohttpd
XBMCBASE_CONF_OPT += --enable-webserver
else
XBMCBASE_CONF_OPT += --disable-webserver
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBSMBCLIENT),y)
XBMCBASE_DEPENDENCIES += samba
XBMCBASE_CONF_OPT += --enable-samba
else
XBMCBASE_CONF_OPT += --disable-samba
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBNFS),y)
XBMCBASE_DEPENDENCIES += libnfs
XBMCBASE_CONF_OPT += --enable-nfs
else
XBMCBASE_CONF_OPT += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_RTMPDUMP),y)
XBMCBASE_DEPENDENCIES += rtmpdump
XBMCBASE_CONF_OPT += --enable-rtmp
else
XBMCBASE_CONF_OPT += --disable-rtmp
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBBLURAY),y)
XBMCBASE_DEPENDENCIES += libbluray
XBMCBASE_CONF_OPT += --enable-libbluray
else
XBMCBASE_CONF_OPT += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBSHAIRPLAY),y)
XBMCBASE_DEPENDENCIES += libshairplay
XBMCBASE_CONF_OPT += --enable-airplay
else
XBMCBASE_CONF_OPT += --disable-airplay
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_AVAHI),y)
XBMCBASE_DEPENDENCIES += avahi
XBMCBASE_CONF_OPT += --enable-avahi
else
XBMCBASE_CONF_OPT += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_LIBCEC),y)
XBMCBASE_DEPENDENCIES += libcec
XBMCBASE_CONF_OPT += --enable-libcec
else
XBMCBASE_CONF_OPT += --disable-libcec
endif

ifeq ($(BR2_PACKAGE_XBMCBASE_WAVPACK),y)
XBMCBASE_DEPENDENCIES += wavpack
endif

# Add HOST_DIR to PATH for codegenerator.mk to find swig
# TODO: java binary from user's machine is currently used...
define XBMCBASE_BOOTSTRAP
	cd $(@D) && PATH="$(HOST_DIR)/usr/bin/:$(PATH)" ./bootstrap
endef

define XBMCBASE_CLEAN_UNUSED_ADDONS
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.plasma
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.milkdrop
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.projectm
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.itunes
endef

define XBMCBASE_CLEAN_CONFLUENCE_SKIN
	find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.png -delete
	find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.jpg -delete
endef

define XBMCBASE_INSTALL_INIT_SYSV
	[ -f $(TARGET_DIR)/etc/init.d/S50xbmc ] || \
		$(INSTALL) -D -m 755 package/xbmc/xbmcbase/S50xbmc \
		$(TARGET_DIR)/etc/init.d/S50xbmc
endef

define XBMCBASE_INSTALL_INIT_SYSTEMD
	[ -f $(TARGET_DIR)/etc/systemd/system/xbmc.service ] || \
		$(INSTALL) -D -m 644 package/xbmc/xbmcbase/xbmcbase.service \
		$(TARGET_DIR)/etc/systemd/system/xbmc.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../xbmc.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/xbmc.service
endef

XBMCBASE_PRE_CONFIGURE_HOOKS += XBMCBASE_BOOTSTRAP
XBMCBASE_POST_INSTALL_TARGET_HOOKS += XBMCBASE_INSTALL_ETC
XBMCBASE_POST_INSTALL_TARGET_HOOKS += XBMCBASE_CLEAN_UNUSED_ADDONS
XBMCBASE_POST_INSTALL_TARGET_HOOKS += XBMCBASE_CLEAN_CONFLUENCE_SKIN

$(eval $(autotools-package))

