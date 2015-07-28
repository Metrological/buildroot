################################################################################
#
# bison
#
################################################################################

ifeq ($(BR2_PACKAGE_INTELCE),y)
BISON_VERSION = 2.4.3
BISON_SOURCE = bison-$(BISON_VERSION).tar.gz
else
BISON_VERSION = 3.0.2
BISON_SOURCE = bison-$(BISON_VERSION).tar.xz
endif

BISON_SITE = $(BR2_GNU_MIRROR)/bison

BISON_LICENSE = GPLv3+
BISON_LICENSE_FILES = COPYING
BISON_CONF_ENV = ac_cv_path_M4=/usr/bin/m4
BISON_DEPENDENCIES = m4 host-gettext
BISON_AUTORECONF = YES

define BISON_DISABLE_EXAMPLES
	echo 'all install:' > $(@D)/examples/Makefile
endef

BISON_POST_CONFIGURE_HOOKS += BISON_DISABLE_EXAMPLES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
