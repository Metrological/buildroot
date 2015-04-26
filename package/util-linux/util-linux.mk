################################################################################
#
# util-linux
#
################################################################################

UTIL_LINUX_VERSION = $(UTIL_LINUX_VERSION_MAJOR).2
UTIL_LINUX_VERSION_MAJOR = 2.23
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.xz
UTIL_LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_VERSION_MAJOR)

# README.licensing claims that some files are GPLv2-only, but this is not true.
# Some files are GPLv3+ but only in tests.
UTIL_LINUX_LICENSE = GPLv2+, BSD-4c, libblkid and libmount LGPLv2.1+, libuuid BSD-3c
UTIL_LINUX_LICENSE_FILES = README.licensing Documentation/licenses/COPYING.GPLv2 Documentation/licenses/COPYING.UCB Documentation/licenses/COPYING.LGPLv2.1 Documentation/licenses/COPYING.BSD-3

UTIL_LINUX_AUTORECONF = YES
UTIL_LINUX_INSTALL_STAGING = YES
UTIL_LINUX_DEPENDENCIES = host-pkgconf
UTIL_LINUX_CONF_ENV = scanf_cv_type_modifier=no
UTIL_LINUX_CONF_OPT += --disable-rpath --disable-makeinstall-chown --disable-bash-completion

# We don't want the host-busybox dependency to be added automatically
HOST_UTIL_LINUX_DEPENDENCIES = host-pkgconf

# If both util-linux and busybox are selected, make certain util-linux
# wins the fight over who gets to have their utils actually installed
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
UTIL_LINUX_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
UTIL_LINUX_DEPENDENCIES += ncurses
else
UTIL_LINUX_CONF_OPT += --without-ncurses
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
UTIL_LINUX_DEPENDENCIES += gettext
UTIL_LINUX_MAKE_OPT += LIBS=-lintl
endif

# Used by cramfs utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB),zlib)

# Used by login-utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_LINUX_PAM),linux-pam)

# Disable/Enable utilities
UTIL_LINUX_CONF_OPT += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_AGETTY),--enable-agetty,--disable-agetty) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_ARCH),--enable-arch,--disable-arch) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CRAMFS),--enable-cramfs,--disable-cramfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_DDATE),--enable-ddate,--disable-ddate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_EJECT),--enable-eject,--disable-eject) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FALLOCATE),--enable-fallocate,--disable-fallocate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FSCK),--enable-fsck,--disable-fsck) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_KILL),--enable-kill,--disable-kill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBUUID),--enable-libuuid,--disable-libuuid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOGIN_UTILS),--enable-last --enable-login --enable-su --enable-sulogin,--disable-last --disable-login --disable-su --disable-sulogin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MESG),--enable-mesg,--disable-mesg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNT),--enable-mount,--disable-mount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PARTX),,--disable-partx) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PIVOT_ROOT),--enable-pivot_root,--disable-pivot_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RAW),--enable-raw,--disable-raw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RENAME),--enable-rename,--disable-rename) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RESET),--enable-reset,--disable-reset) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SCHEDUTILS),--enable-schedutils,--disable-schedutils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SWITCH_ROOT),--enable-switch_root,--disable-switch_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UNSHARE),--enable-unshare,--disable-unshare) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UTMPDUMP),--enable-utmpdump,--disable-utmpdump) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UUIDD),--enable-uuidd,--disable-uuidd) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WALL),--enable-wall,--disable-wall) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WRITE),--enable-write,--disable-write)

# In the host version of util-linux, we so far only require libuuid,
# and none of the util-linux utilities, so we disable all of them.
HOST_UTIL_LINUX_CONF_OPT += \
	--enable-libuuid \
	--disable-agetty --disable-cramfs --disable-fallocate \
	--disable-fsck --disable-libblkid --disable-libmount \
	--disable-login --disable-mount --disable-partx \
	--disable-pivot_root --disable-rename --disable-schedutils \
	--disable-su --disable-switch_root --disable-unshare \
	--disable-uuidd --disable-wall --without-ncurses

# Avoid building the tools if they are disabled since we can't install on
# a per-directory basis.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_BINARIES),)
define UTIL_LINUX_DISABLE_TOOLS
	$(SED) '/schedutils/d' -e '/text-utils/d' -e '/term-utils/d' \
		-e '/login-utils/d' -e '/mount-deprecated/d' \
		-e '/sys-utils/d' -e '/misc-utils/d' -e '/disk-utils/d' \
		-e '/fdisks/d' $(@D)/Makefile.am
endef
UTIL_LINUX_PRE_PATCH_HOOKS += UTIL_LINUX_DISABLE_TOOLS
endif

# Install PAM configuration files
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LOGIN_UTILS),y)
define UTIL_LINUX_INSTALL_PAMFILES
	$(INSTALL) -m 0644 package/util-linux/login.pam \
		$(TARGET_DIR)/etc/pam.d/login
	$(INSTALL) -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su
	$(INSTALL) -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su-l
endef
endif

UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_INSTALL_PAMFILES

# Install agetty->getty symlink to avoid breakage when there's no busybox
ifeq ($(BR2_PACKAGE_UTIL_LINUX_AGETTY),y)
ifeq ($(BR2_PACKAGE_BUSYBOX),)
define UTIL_LINUX_GETTY_SYMLINK
	ln -sf agetty $(TARGET_DIR)/sbin/getty
endef
endif
endif

UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_GETTY_SYMLINK

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# MKINSTALLDIRS comes from tweaked m4/nls.m4, but autoreconf uses staging
# one, so it disappears
UTIL_LINUX_INSTALL_STAGING_OPT += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
UTIL_LINUX_INSTALL_TARGET_OPT += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
HOST_UTIL_LINUX_INSTALL_OPT += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
