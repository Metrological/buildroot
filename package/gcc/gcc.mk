################################################################################
#
# Common variables for the gcc-initial, gcc-intermediate and gcc-final
# packages.
#
################################################################################

#
# Version, site and source
#

GCC_VERSION = $(call qstrip,$(BR2_GCC_VERSION))

ifeq ($(BR2_GCC_VERSION_SNAP),y)
GCC_SNAP_DATE = $(call qstrip,$(BR2_GCC_SNAP_DATE))
endif

ifneq ($(GCC_SNAP_DATE),)
GCC_SITE = ftp://gcc.gnu.org/pub/gcc/snapshots/$(GCC_SNAP_DATE)/
else ifeq ($(findstring avr32,$(GCC_VERSION)),avr32)
GCC_SITE = ftp://www.at91.com/pub/buildroot/
else ifeq ($(BR2_arc),y)
GCC_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,gcc,$(GCC_VERSION))
GCC_SOURCE = gcc-$(GCC_VERSION).tar.gz
else ifeq ($(BR2_microblaze),y)
GCC_SITE = $(call github,Xilinx,gcc,$(GCC_VERSION))
GCC_SOURCE = gcc-$(GCC_VERSION).tar.gz
else
GCC_SITE = $(BR2_GNU_MIRROR:/=)/gcc/gcc-$(GCC_VERSION)
endif

GCC_SOURCE ?= gcc-$(GCC_VERSION).tar.bz2

ifeq ($(BR2_USE_LINARO_GCC),y)
LINARO_GCC_VERSION = $(call qstrip,$(BR2_LINARO_GCC_VERSION))
LINARO_RELEASE = $(call qstrip,$(BR2_LINARO_RELEASE))
GCC_SITE = https://launchpad.net/gcc-linaro/$(LINARO_GCC_VERSION)/$(LINARO_GCC_VERSION)-$(LINARO_RELEASE)/+download/
GCC_SOURCE = gcc-linaro-$(LINARO_GCC_VERSION)-$(LINARO_RELEASE).tar.xz
endif

#
# Xtensa special hook
#

define HOST_GCC_XTENSA_OVERLAY_EXTRACT
        tar xf $(BR2_XTENSA_OVERLAY_DIR)/xtensa_$(call qstrip,\
                $(BR2_XTENSA_CORE_NAME)).tar -C $(@D) --strip-components=1 gcc
endef

#
# Apply patches
#

ifeq ($(ARCH),powerpc)
ifneq ($(BR2_SOFT_FLOAT),)
define HOST_GCC_APPLY_POWERPC_PATCH
	support/scripts/apply-patches.sh $(@D) package/gcc/$(GCC_VERSION) powerpc-link-with-math-lib.patch.conditional
endef
endif
endif

ifeq ($(BR2_USE_LINARO_GCC),y)
define HOST_GCC_APPLY_PATCHES
	if test -d package/gcc/$(GCC_VERSION); then \
	  support/scripts/apply-patches.sh $(@D) package/gcc/$(GCC_VERSION)-linaro \*.patch ; \
	fi;
endef
else
define HOST_GCC_APPLY_PATCHES
	if test -d package/gcc/$(GCC_VERSION); then \
	  support/scripts/apply-patches.sh $(@D) package/gcc/$(GCC_VERSION) \*.patch ; \
	fi;
	$(HOST_GCC_APPLY_POWERPC_PATCH)
endef
endif

#
# Custom extract command to save disk space
#

define HOST_GCC_EXTRACT_CMDS
	$(call suitable-extractor,$(GCC_SOURCE)) $(DL_DIR)/$(GCC_SOURCE) | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(@D) \
		--exclude='libjava/*' \
		--exclude='libgo/*' \
		--exclude='gcc/testsuite/*' \
		--exclude='libstdc++-v3/testsuite/*' \
		$(TAR_OPTIONS) -
	mkdir -p $(@D)/libstdc++-v3/testsuite/
	echo "all:" > $(@D)/libstdc++-v3/testsuite/Makefile.in
	echo "install:" >> $(@D)/libstdc++-v3/testsuite/Makefile.in
endef

#
# Create 'build' directory and configure symlink
#

define HOST_GCC_CONFIGURE_SYMLINK
	mkdir -p $(@D)/build
	ln -sf ../configure $(@D)/build/configure
endef

#
# Common configuration options
#

HOST_GCC_COMMON_DEPENDENCIES = \
	host-binutils \
	host-gmp \
	host-mpfr \
	$(if $(BR2_BINFMT_FLAT),host-elf2flt)

HOST_GCC_COMMON_CONF_OPT = \
	--target=$(GNU_TARGET_NAME) \
	--with-sysroot=$(STAGING_DIR) \
	--disable-__cxa_atexit \
	--with-gnu-ld \
	--disable-libssp \
	--disable-multilib \
	--with-gmp=$(HOST_DIR)/usr \
	--with-mpfr=$(HOST_DIR)/usr

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
HOST_GCC_COMMON_CONF_ENV = \
	MAKEINFO=missing

# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43810
# Workaround until it's fixed in 4.5.4 or later
ifeq ($(ARCH),powerpc)
ifeq ($(findstring x4.5.,x$(GCC_VERSION)),x4.5.)
HOST_GCC_COMMON_CONF_OPT += --disable-target-optspace
endif
else
HOST_GCC_COMMON_CONF_OPT += --enable-target-optspace
endif

# gcc 4.6.x quadmath requires wchar
ifneq ($(BR2_TOOLCHAIN_BUILDROOT_WCHAR),y)
HOST_GCC_COMMON_CONF_OPT += --disable-libquadmath
endif

ifeq ($(BR2_GCC_USE_OLD_ABI_BY_DEFAULT),y)
HOST_GCC_COMMON_CONF_OPT += --with-default-libstdcxx-abi=gcc4-compatible
endif

ifeq ($(BR2_GCC_ENABLE_TLS),y)
HOST_GCC_COMMON_CONF_OPT += --enable-tls
else
HOST_GCC_COMMON_CONF_OPT += --disable-tls
endif

ifeq ($(shell expr $(BR2_UCLIBC_VERSION_STRING) \<= 0.9.32.0), 1)
   HOST_GCC_COMMON_CONF_OPT += --disable-libsanitizer 
endif

ifeq ($(BR2_GCC_ENABLE_LIBMUDFLAP),y)
HOST_GCC_COMMON_CONF_OPT += --enable-libmudflap
else
HOST_GCC_COMMON_CONF_OPT += --disable-libmudflap
endif

ifeq ($(BR2_PTHREADS_NONE),y)
HOST_GCC_COMMON_CONF_OPT += \
	--disable-threads \
	--disable-libitm \
	--disable-libatomic
else
HOST_GCC_COMMON_CONF_OPT += --enable-threads
endif

ifeq ($(BR2_GCC_NEEDS_MPC),y)
HOST_GCC_COMMON_DEPENDENCIES += host-mpc
HOST_GCC_COMMON_CONF_OPT += --with-mpc=$(HOST_DIR)/usr
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
HOST_GCC_COMMON_CONF_OPT += --enable-lto
else
HOST_GCC_COMMON_CONF_OPT += --disable-lto
endif

ifeq ($(BR2_GCC_NEEDS_ISL),y)
HOST_GCC_COMMON_DEPENDENCIES += host-isl
HOST_GCC_COMMON_CONF_OPT += --with-isl=$(HOST_DIR)/usr
endif

ifeq ($(BR2_GCC_NEEDS_CLOOG),y)
HOST_GCC_COMMON_DEPENDENCIES += host-cloog
HOST_GCC_COMMON_CONF_OPT += --with-cloog=$(HOST_DIR)/usr --enable-cloog-backend=isl
endif

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_5),)
HOST_GCC_COMMON_DEPENDENCIES += host-cloog
HOST_GCC_COMMON_CONF_OPTS += --with-cloog=$(HOST_DIR)/usr
endif

ifeq ($(BR2_arc),y)
HOST_GCC_COMMON_DEPENDENCIES += host-flex host-bison
endif

ifeq ($(BR2_PACKAGE_HOST_FLEX),y)
HOST_GCC_COMMON_DEPENDENCIES += host-flex 
endif

ifeq ($(BR2_PACKAGE_HOST_BISON),y)
HOST_GCC_COMMON_DEPENDENCIES += host-bison
endif

ifeq ($(BR2_SOFT_FLOAT),y)
# only mips*-*-*, arm*-*-* and sparc*-*-* accept --with-float
# powerpc seems to be needing it as well
ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_powerpc)$(BR2_sparc),y)
HOST_GCC_COMMON_CONF_OPT += --with-float=soft
endif
endif

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_GCC_COMMON_CONF_OPT += --disable-decimal-float
endif

# Determine arch/tune/abi/cpu options
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ARCH)),)
HOST_GCC_COMMON_CONF_OPT += --with-arch=$(BR2_GCC_TARGET_ARCH)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_TUNE)),)
HOST_GCC_COMMON_CONF_OPT += --with-tune=$(BR2_GCC_TARGET_TUNE)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ABI)),)
HOST_GCC_COMMON_CONF_OPT += --with-abi=$(BR2_GCC_TARGET_ABI)
endif
# GCC doesn't support --with-cpu for bfin
ifeq ($(BR2_bfin),)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU)),)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
HOST_GCC_COMMON_CONF_OPT += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
else
HOST_GCC_COMMON_CONF_OPT += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU))
endif
endif
endif

GCC_TARGET_FPU = $(call qstrip,$(BR2_GCC_TARGET_FPU))
ifneq ($(GCC_TARGET_FPU),)
HOST_GCC_COMMON_CONF_OPT += --with-fpu=$(GCC_TARGET_FPU)
endif

GCC_TARGET_FLOAT_ABI = $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
ifneq ($(GCC_TARGET_FLOAT_ABI),)
HOST_GCC_COMMON_CONF_OPT += --with-float=$(GCC_TARGET_FLOAT_ABI)
endif

GCC_TARGET_MODE = $(call qstrip,$(BR2_GCC_TARGET_MODE))
ifneq ($(GCC_TARGET_MODE),)
HOST_GCC_COMMON_CONF_OPT += --with-mode=$(GCC_TARGET_MODE)
endif

# Branding works on >= 4.3
ifneq ($(findstring x4.2.,x$(GCC_VERSION)),x4.2.)
HOST_GCC_COMMON_CONF_OPT += \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/"
endif

# Enable proper double/long double for SPE ABI
ifeq ($(BR2_powerpc_SPE),y)
HOST_GCC_COMMON_CONF_OPT += \
	--enable-e500_double \
	--with-long-double-128
endif

include $(sort $(wildcard package/gcc/*/*.mk))
