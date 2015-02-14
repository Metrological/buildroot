################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.32
EVTEST_SOURCE = evtest-$(EVTEST_VERSION).tar.bz2
# no official upstream tarball
EVTEST_SITE = http://pkgs.fedoraproject.org/repo/pkgs/evtest/evtest-1.32.tar.bz2/66077d03b5ea5703d8ef7bc346b39646/
EVTEST_LICENSE = GPLv2
EVTEST_LICENSE_FILES = COPYING
EVTEST_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_EVTEST_CAPTURE),y)
EVTEST_DEPENDENCIES += libxml2
else
# evtest-capture will unconditionally be built/installed if libxml2 is present
define EVTEST_REMOVE_EVTEST_CAPTURE
	rm -rf $(TARGET_DIR)/usr/bin/evtest-capture \
	       $(TARGET_DIR)/usr/share/evtest \
	       $(TARGET_DIR)/usr/share/man/man1/evtest-capture.1
endef

EVTEST_POST_INSTALL_TARGET_HOOKS += EVTEST_REMOVE_EVTEST_CAPTURE
endif

$(eval $(autotools-package))
