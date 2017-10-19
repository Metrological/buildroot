################################################################################
#
# binutils
#
################################################################################

# Version is set when using buildroot toolchain.
# If not, we do like other packages
BINUTILS_VERSION = $(call qstrip,$(BR2_BINUTILS_VERSION))
ifeq ($(BINUTILS_VERSION),)
ifeq ($(BR2_avr32),y)
# avr32 uses a special version
BINUTILS_VERSION = 2.18-avr32-1.0.1
else
BINUTILS_VERSION = 2.21
endif
endif

ifeq ($(BINUTILS_VERSION),2.23)
BINUTILS_SOURCE = binutils-$(BINUTILS_VERSION).tar.gz
endif

ifeq ($(ARCH),avr32)
BINUTILS_SITE = ftp://www.at91.com/pub/buildroot
endif
ifeq ($(BR2_arc),y)
BINUTILS_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,binutils,$(BINUTILS_VERSION))
BINUTILS_SOURCE = binutils-$(BINUTILS_VERSION).tar.gz
BINUTILS_FROM_GIT = y
endif
ifeq ($(BR2_microblaze),y)
BINUTILS_SITE = $(call github,Xilinx,binutils,$(BINUTILS_VERSION))
BINUTILS_SOURCE = binutils-$(BINUTILS_VERSION).tar.gz
BINUTILS_FROM_GIT = y
endif
BINUTILS_SITE ?= $(BR2_GNU_MIRROR)/binutils
ifeq ($(BINUTILS_VERSION),2.28.1)
BINUTILS_SOURCE ?= binutils-$(BINUTILS_VERSION).tar.xz
else ifeq ($(BINUTILS_VERSION),2.29)
BINUTILS_SOURCE ?= binutils-$(BINUTILS_VERSION).tar.xz
else
BINUTILS_SOURCE ?= binutils-$(BINUTILS_VERSION).tar.bz2
endif
BINUTILS_EXTRA_CONFIG_OPTIONS = $(call qstrip,$(BR2_BINUTILS_EXTRA_CONFIG_OPTIONS))
BINUTILS_INSTALL_STAGING = YES
BINUTILS_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
HOST_BINUTILS_DEPENDENCIES = host-flex host-bison
BINUTILS_LICENSE = GPLv3+, libiberty LGPLv2.1+
BINUTILS_LICENSE_FILES = COPYING3 COPYING.LIB

ifeq ($(BINUTILS_FROM_GIT),y)
BINUTILS_DEPENDENCIES += host-texinfo host-flex host-bison
HOST_BINUTILS_DEPENDENCIES += host-texinfo
endif

# We need to specify host & target to avoid breaking ARM EABI
# they also contain the gdb sources, but gdb shouldn't be built, so we
# disable it.
BINUTILS_DISABLE_GDB_CONF_OPTS = \
	--disable-sim \
	--disable-gdb

# We need to specify host & target to avoid breaking ARM EABI
BINUTILS_CONF_OPT = \
	--disable-multilib  \
	--disable-werror \
	--host=$(GNU_TARGET_NAME) \
	--target=$(GNU_TARGET_NAME) \
	--enable-install-libiberty \
	--enable-build-warnings=no \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

# Install binutils after busybox to prefer full-blown utilities
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
BINUTILS_DEPENDENCIES += busybox
endif

# "host" binutils should actually be "cross"
# We just keep the convention of "host utility" for now
HOST_BINUTILS_CONF_OPT = \
	--disable-multilib \
	--disable-werror \
	--target=$(GNU_TARGET_NAME) \
	--enable-gold \
	--disable-shared \
	--enable-static \
	--with-sysroot=$(STAGING_DIR) \
	--enable-poison-system-directories \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

# We just want libbfd and libiberty, not the full-blown binutils in staging
define BINUTILS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/bfd DESTDIR=$(STAGING_DIR) install
	$(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef

# If we don't want full binutils on target
ifneq ($(BR2_PACKAGE_BINUTILS_TARGET),y)
define BINUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(TARGET_DIR) install
	$(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef
endif

XTENSA_CORE_NAME = $(call qstrip, $(BR2_XTENSA_CORE_NAME))
ifneq ($(XTENSA_CORE_NAME),)
define BINUTILS_XTENSA_PRE_PATCH
	tar xf $(BR2_XTENSA_OVERLAY_DIR)/xtensa_$(XTENSA_CORE_NAME).tar \
		-C $(@D) --strip-components=1 binutils
endef
BINUTILS_PRE_PATCH_HOOKS += BINUTILS_XTENSA_PRE_PATCH
HOST_BINUTILS_PRE_PATCH_HOOKS += BINUTILS_XTENSA_PRE_PATCH
endif

ifeq ($(BR2_BINUTILS_ENABLE_LTO),y)
HOST_BINUTILS_CONF_OPTS += --enable-plugins --enable-lto
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
