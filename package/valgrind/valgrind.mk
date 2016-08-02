################################################################################
#
# valgrind
#
################################################################################

VALGRIND_VERSION = 3.11.0
VALGRIND_SITE = http://valgrind.org/downloads
VALGRIND_SOURCE = valgrind-$(VALGRIND_VERSION).tar.bz2
VALGRIND_LICENSE = GPLv2 GFDLv1.2
VALGRIND_LICENSE_FILES = COPYING COPYING.DOCS
VALGRIND_AUTORECONF = YES

VALGRIND_CONF_OPTS += \
		--disable-tls \
                --target=$(GNU_TARGET_NAME) \
                --host=$(GNU_TARGET_NAME) \
                --build=$(GNU_HOST_NAME)

define VALGRIND_INSTALL_UCLIBC_SUPP
	$(INSTALL) -D -m 0644 package/valgrind/uclibc.supp $(TARGET_DIR)/usr/lib/valgrind/uclibc.supp
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_INSTALL_UCLIBC_SUPP

ifeq ($(BR2_PACKAGE_VALGRIND_MEMCHECK),)
define VALGRIND_REMOVE_MEMCHECK
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*memcheck*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_MEMCHECK
endif

ifeq ($(BR2_PACKAGE_VALGRIND_CACHEGRIND),)
define VALGRIND_REMOVE_CACHEGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*cachegrind*
	for i in cg_annotate cg_diff cg_merge; do \
		rm -f $(TARGET_DIR)/usr/bin/$$i ; \
	done
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_CACHEGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_CALLGRIND),)
define VALGRIND_REMOVE_CALLGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*callgrind*
	for i in callgrind_annotate callgrind_control ; do \
		rm -f $(TARGET_DIR)/usr/bin/$$i ; \
	done
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_CALLGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_HELGRIND),)
define VALGRIND_REMOVE_HELGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*helgrind*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_HELGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_DRD),)
define VALGRIND_REMOVE_DRD
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*drd*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_DRD
endif

ifeq ($(BR2_PACKAGE_VALGRIND_MASSIF),)
define VALGRIND_REMOVE_MASSIF
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*massif*
	rm -f $(TARGET_DIR)/usr/bin/ms_script
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_MASSIF
endif

ifeq ($(BR2_PACKAGE_VALGRIND_DHAT),)
define VALGRIND_REMOVE_DHAT
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*dhat*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_DHAT
endif

ifeq ($(BR2_PACKAGE_VALGRIND_SGCHECK),)
define VALGRIND_REMOVE_SGCHECK
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*sgcheck*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_SGCHECK
endif

ifeq ($(BR2_PACKAGE_VALGRIND_BBV),)
define VALGRIND_REMOVE_BBV
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*bbv*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_BBV
endif

ifeq ($(BR2_PACKAGE_VALGRIND_LACKEY),)
define VALGRIND_REMOVE_LACKEY
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*lackey*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_LACKEY
endif

ifeq ($(BR2_PACKAGE_VALGRIND_NULGRIND),)
define VALGRIND_REMOVE_NULGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*none*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_NULGRIND
endif

define VALGRIND_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	CFLAGS="$(TARGET_CFLAGS)" \
	CPPFLAGS="$(TARGET_CPPFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(VALGRIND_CONF_OPTS) \
	)
endef

$(eval $(autotools-package))
