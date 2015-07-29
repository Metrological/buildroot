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

ifeq ($(findstring x2.6.,x$(LINUX_HEADERS_VERSION)),x2.6.)
UDEV_PRE_PATCH_HOOKS += UDEV_RENAME_PATCH_NAME
UDEV_POST_PATCH_HOOKS += UDEV_RESTORE_PATCH_NAME
endif

# rename the patch so it will be applied
define UDEV_RENAME_PATCH_NAME
	if [ -f ./package/udev/udev-0001-add-trigger-happy-definition.do_not_apply ]; then \
		mv ./package/udev/udev-0001-add-trigger-happy-definition.do_not_apply ./package/udev/udev-0001-add-trigger-happy-definition.patch ; \
	else \
		exit 1; \
	fi
endef

define UDEV_RESTORE_PATCH_NAME
	if [ -f ./package/udev/udev-0001-add-trigger-happy-definition.patch ]; then \
		mv ./package/udev/udev-0001-add-trigger-happy-definition.patch ./package/udev/udev-0001-add-trigger-happy-definition.do_not_apply ; \
	else \
		exit 1; \
	fi
endef

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

UDEV_POST_INSTALL_TARGET_HOOKS += UDEV_INSTALL_INITSCRIPT

$(eval $(autotools-package))
