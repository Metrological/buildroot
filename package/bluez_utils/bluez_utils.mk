################################################################################
#
# bluez_utils
#
################################################################################

BLUEZ_UTILS_VERSION = 5.34
BLUEZ_UTILS_SOURCE = bluez-$(BLUEZ_UTILS_VERSION).tar.xz
BLUEZ_UTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/bluetooth
BLUEZ_UTILS_INSTALL_STAGING = YES
BLUEZ_UTILS_DEPENDENCIES = dbus libglib2 libical readline systemd
BLUEZ_UTILS_CONF_OPT = --enable-test --enable-tools
BLUEZ_UTILS_AUTORECONF = YES
BLUEZ_UTILS_LICENSE = GPLv2+ LGPLv2.1+
BLUEZ_UTILS_LICENSE_FILES = COPYING COPYING.LIB

# BlueZ 3.x compatibility
ifeq ($(BR2_PACKAGE_BLUEZ_UTILS_COMPAT),y)
BLUEZ_UTILS_CONF_OPT +=	\
	--enable-hidd	\
	--enable-pand	\
	--enable-sdp	\
	--enable-dund
endif

# audio support
ifeq ($(BR2_PACKAGE_BLUEZ_UTILS_AUDIO),y)
BLUEZ_UTILS_DEPENDENCIES +=	\
	alsa-lib		\
	libsndfile
BLUEZ_UTILS_CONF_OPT +=	\
	--enable-alsa	\
	--enable-audio
else
BLUEZ_UTILS_CONF_OPT +=	\
	--disable-alsa	\
	--disable-audio
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS_GATT),y)
BLUEZ_UTILS_DEPENDENCIES += readline
BLUEZ_UTILS_CONF_OPT += --enable-gatt
else
BLUEZ_UTILS_CONF_OPT += --disable-gatt
endif

# USB support
ifeq ($(BR2_PACKAGE_BLUEZ_UTILS_USB),y)
BLUEZ_UTILS_DEPENDENCIES += libusb
BLUEZ_UTILS_CONF_OPT +=	\
	--enable-usb
else
BLUEZ_UTILS_CONF_OPT +=	\
	--disable-usb
endif

$(eval $(autotools-package))
