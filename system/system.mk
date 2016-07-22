TARGET_GENERIC_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
TARGET_GENERIC_TIMESERVER= $(call qstrip,$(BR2_TARGET_GENERIC_TIMESERVER))
TARGET_GENERIC_ISSUE = $(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
TARGET_GENERIC_ROOT_PASSWD = $(call qstrip,$(BR2_TARGET_GENERIC_ROOT_PASSWD))
TARGET_GENERIC_PASSWD_METHOD = $(call qstrip,$(BR2_TARGET_GENERIC_PASSWD_METHOD))
TARGET_GENERIC_GETTY_PORT = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT))
TARGET_GENERIC_GETTY_BAUDRATE = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE))
TARGET_GENERIC_GETTY_TERM = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_TERM))
TARGET_GENERIC_GETTY_OPTIONS = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_OPTIONS))
TARGET_SPECIFIC_INTERFACES = $(call qstrip,$(BR2_TARGET_SPECIFIC_INTERFACES))

target-generic-securetty:
	grep -q '^$(TARGET_GENERIC_GETTY_PORT)$$' $(TARGET_DIR)/etc/securetty || \
		echo '$(TARGET_GENERIC_GETTY_PORT)' >> $(TARGET_DIR)/etc/securetty

target-generic-cabundle:
	mkdir -p $(TARGET_DIR)/etc/ssl/certs/
	$(WGET) -O $(TARGET_DIR)/etc/ssl/certs/ca-certificates.crt http://curl.haxx.se/ca/cacert.pem

ifeq ($(BR2_TARGET_GENERIC_CABUNDLE),y)
TARGETS += target-generic-cabundle
endif

target-generic-hostname:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts

target-generic-issue:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue

ifneq ($(TARGET_GENERIC_ROOT_PASSWD),)
target-root-passwd: host-mkpasswd
endif
target-root-passwd:
	[ -n "$(TARGET_GENERIC_ROOT_PASSWD)" ] && \
		TARGET_GENERIC_ROOT_PASSWD_HASH=$$($(MKPASSWD) -m "$(TARGET_GENERIC_PASSWD_METHOD)" "$(TARGET_GENERIC_ROOT_PASSWD)"); \
	$(SED) "s,^root:[^:]*:,root:$$TARGET_GENERIC_ROOT_PASSWD_HASH:," $(TARGET_DIR)/etc/shadow

target-generic-getty-busybox:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(TARGET_GENERIC_GETTY_PORT)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY_OPTIONS) $(TARGET_GENERIC_GETTY_PORT) $(TARGET_GENERIC_GETTY_BAUDRATE) $(TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab

# In sysvinit inittab, the "id" must not be longer than 4 bytes, so we
# skip the "tty" part and keep only the remaining.
target-generic-getty-sysvinit:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(shell echo $(TARGET_GENERIC_GETTY_PORT) | tail -c+4)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY_OPTIONS) $(TARGET_GENERIC_GETTY_PORT) $(TARGET_GENERIC_GETTY_BAUDRATE) $(TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab

# Find commented line, if any, and remove leading '#'s
target-generic-do-remount-rw:
	$(SED) '/^#.*# REMOUNT_ROOTFS_RW$$/s~^#\+~~' $(TARGET_DIR)/etc/inittab

# Find uncommented line, if any, and add a leading '#'
target-generic-dont-remount-rw:
	$(SED) '/^[^#].*# REMOUNT_ROOTFS_RW$$/s~^~#~' $(TARGET_DIR)/etc/inittab

# install a time server to set the proper time once an interface comes up..
target-generic-install-timeserver:
	cp -f $(TARGET_SKELETON)/etc/network/if-up.d/rdate $(TARGET_DIR)/etc/network/if-up.d/rdate
	$(SED) 's/__NTP_SERVER__/$(TARGET_GENERIC_TIMESERVER)/g' $(TARGET_DIR)/etc/network/if-up.d/rdate
target-generic-remove-timeserver:
	$(RM) $(TARGET_DIR)/etc/network/if-up.d/rdate

target-specific-install-interfaces:
	cp -f $(TOPDIR)/$(TARGET_SPECIFIC_INTERFACES) $(TARGET_DIR)/etc/network/interfaces

ifneq ($(TARGET_SPECIFIC_INTERFACES)x,x)
TARGETS += target-specific-install-interfaces
endif

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
TARGETS += target-generic-securetty
endif

ifneq ($(TARGET_GENERIC_HOSTNAME),)
TARGETS += target-generic-hostname
endif

ifneq ($(TARGET_GENERIC_ISSUE),)
TARGETS += target-generic-issue
endif

ifeq ($(BR2_ROOTFS_SKELETON_DEFAULT),y)
TARGETS += target-root-passwd 

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
TARGETS += target-generic-getty-$(if $(BR2_PACKAGE_SYSVINIT),sysvinit,busybox)
endif

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
TARGETS += target-generic-do-remount-rw
else
TARGETS += target-generic-dont-remount-rw
endif

ifneq ($(TARGET_GENERIC_TIMESERVER),)
TARGETS += target-generic-install-timeserver
else
TARGETS += target-generic-remove-timeserver
endif
endif
