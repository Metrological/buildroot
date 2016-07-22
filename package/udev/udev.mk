################################################################################
#
# udev
#
################################################################################

UDEV_VERSION = 182
UDEV_SOURCE = udev-$(UDEV_VERSION).tar.xz
UDEV_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/hotplug/
UDEV_LICENSE = GPLv2+
UDEV_LICENSE_FILES = COPYING
UDEV_INSTALL_STAGING = YES

# mq_getattr is in librt
UDEV_CONF_ENV += LIBS=-lrt

UDEV_CONF_OPT =			\
	--sbindir=/sbin		\
	--with-rootlibdir=/lib	\
	--libexecdir=/lib	\
	--with-usb-ids-path=/usr/share/hwdata/usb.ids	\
	--with-pci-ids-path=/usr/share/hwdata/pci.ids	\
	--with-firmware-path=/lib/firmware		\
	--disable-introspection

UDEV_DEPENDENCIES = host-gperf host-pkgconf util-linux kmod


UDEV_CUSTOM_RULES= $(call qstrip,$(BR2_UDEV_CUSTOM_RULES))

ifeq ($(BR2_PACKAGE_UDEV_RULES_GEN),y)
UDEV_CONF_OPT += --enable-rule_generator
endif

ifeq ($(BR2_PACKAGE_UDEV_ALL_EXTRAS),y)
UDEV_DEPENDENCIES += acl hwdata libglib2
UDEV_CONF_OPT +=		\
	--enable-udev_acl
else
UDEV_CONF_OPT +=		\
	--disable-gudev
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
	UDEV_CONF_OPT += --with-systemdsystemunitdir=/lib/systemd/system/
endif

define UDEV_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/udev/S10udev $(TARGET_DIR)/etc/init.d/S10udev
endef

ifneq ($(UDEV_CUSTOM_RULES)x,x)
define UDEV_INSTALL_CUSTOM_RULES
     cp -f $(TOPDIR)/$(UDEV_CUSTOM_RULES)/*.rules $(TARGET_DIR)/etc/udev/rules.d/
endef

UDEV_POST_INSTALL_TARGET_HOOKS += UDEV_INSTALL_CUSTOM_RULES
endif

UDEV_POST_INSTALL_TARGET_HOOKS += UDEV_INSTALL_INITSCRIPT

$(eval $(autotools-package))
