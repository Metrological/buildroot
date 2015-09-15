################################################################################
#
# dbus
#
################################################################################

DBUS_VERSION = 1.9.20
DBUS_SITE = http://dbus.freedesktop.org/releases/dbus
DBUS_LICENSE = AFLv2.1 GPLv2+
DBUS_LICENSE_FILES = COPYING
DBUS_INSTALL_STAGING = YES

define DBUS_PERMISSIONS
/usr/libexec/dbus-daemon-launch-helper f 4755 0 0 - - - - -
endef

DBUS_DEPENDENCIES = host-pkgconf

DBUS_CONF_ENV = ac_cv_have_abstract_sockets=yes
DBUS_CONF_OPT = --with-dbus-user=dbus \
		--disable-tests \
		--disable-asserts \
		--enable-abstract-sockets \
		--disable-selinux \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--disable-static \
		--disable-dnotify \
		--localstatedir=/var \
		--with-system-socket=/var/run/dbus/system_bus_socket \
		--with-system-pid-file=/var/run/messagebus.pid

ifeq ($(BR2_PREFER_STATIC_LIB),y)
DBUS_CONF_OPT += LIBS='-lpthread'
endif

ifeq ($(BR2_microblaze),y)
# microblaze toolchain doesn't provide inotify_rm_* but does have sys/inotify.h
DBUS_CONF_OPT += --disable-inotify
endif

ifeq ($(BR2_DBUS_EXPAT),y)
DBUS_CONF_OPT += --with-xml=expat
DBUS_DEPENDENCIES += expat
else
DBUS_CONF_OPT += --with-xml=libxml
DBUS_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
DBUS_CONF_OPT += --with-x
DBUS_DEPENDENCIES += xlib_libX11
else
DBUS_CONF_OPT += --without-x
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
DBUS_CONF_OPT += --with-systemdsystemunitdir=/lib/systemd/system
endif

# fix rebuild (dbus makefile errors out if /var/lib/dbus is a symlink)
define DBUS_REMOVE_VAR_LIB_DBUS
	rm -rf $(TARGET_DIR)/var/lib/dbus
endef

DBUS_POST_BUILD_HOOKS += DBUS_REMOVE_VAR_LIB_DBUS

define DBUS_REMOVE_DEVFILES
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
endef

DBUS_POST_INSTALL_TARGET_HOOKS += DBUS_REMOVE_DEVFILES

define DBUS_INSTALL_TARGET_FIXUP
	mkdir -p $(TARGET_DIR)/var/lib
	rm -rf $(TARGET_DIR)/var/lib/dbus
	ln -sf /tmp/dbus $(TARGET_DIR)/var/lib/dbus
endef

DBUS_POST_INSTALL_TARGET_HOOKS += DBUS_INSTALL_TARGET_FIXUP

define DBUS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/dbus/S30dbus \
		$(TARGET_DIR)/etc/init.d/S30dbus
endef

HOST_DBUS_DEPENDENCIES = host-pkgconf host-expat
HOST_DBUS_CONF_OPT = \
		--with-dbus-user=dbus \
		--disable-tests \
		--disable-asserts \
		--enable-abstract-sockets \
		--disable-selinux \
		--disable-xml-docs \
		--disable-doxygen-docs \
		--disable-static \
		--enable-dnotify \
		--without-x \
		--with-xml=expat

# dbus for the host
DBUS_HOST_INTROSPECT=$(HOST_DBUS_DIR)/introspect.xml

HOST_DBUS_GEN_INTROSPECT = \
	$(HOST_DIR)/usr/bin/dbus-daemon --introspect > $(DBUS_HOST_INTROSPECT)

HOST_DBUS_POST_INSTALL_HOOKS += HOST_DBUS_GEN_INTROSPECT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
