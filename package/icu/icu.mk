################################################################################
#
# icu
#
################################################################################

ICU_VERSION_MAJOR = 51
ICU_VERSION = $(ICU_VERSION_MAJOR).2
ICU_SOURCE = icu4c-$(subst .,_,$(ICU_VERSION))-src.tgz
ICU_SITE = http://download.icu-project.org/files/icu4c/$(ICU_VERSION)
ICU_LICENSE = ICU License
ICU_LICENSE_FILES = license.html

ICU_DEPENDENCIES = host-icu
ICU_INSTALL_STAGING = YES
ICU_CONFIG_SCRIPTS = icu-config
ICU_CONF_OPT = --with-cross-build=$(HOST_ICU_DIR)/source --disable-samples \
		--disable-tests
HOST_ICU_CONF_OPT = \
	--disable-samples \
	--disable-tests \
	--disable-extras \
	--disable-icuio \
	--disable-layout \
	--disable-renaming
ICU_CONF_ENV += CPPFLAGS="$(ICU_CPPFLAGS)"
ICU_MAKE = $(MAKE1)
ICU_SUBDIR = source

# ICU_EXTRA_CPPFLAGS  = -DICU_DATA_DIR=\\\"\/source\/data\/in\\\"

ifeq ($(BR2_ICU_ONLY_COLLATION), y)
ICU_CPPFLAGS += -DUCONFIG_ONLY_COLLATION=1
endif

ifeq ($(BR2_ICU_NO_COLLATION), y)
ICU_CPPFLAGS += -DUCONFIG_NO_COLLATION=1
endif

ifeq ($(BR2_ICU_NO_LEGACY_COLLATION), y)
ICU_CPPFLAGS += -DUCONFIG_NO_LEGACY_CONVERSION=1
endif

ifeq ($(BR2_ICU_NO_BREAK_ITERATION), y)
ICU_CPPFLAGS += -DUCONFIG_NO_BREAK_ITERATION=1
endif

ifeq ($(BR2_ICU_NO_FORMATTING), y)
ICU_CPPFLAGS += -DUCONFIG_NO_FORMATTING=1
endif

ifeq ($(BR2_ICU_NO_TRANSLITERATION), y)
ICU_CPPFLAGS += -DUCONFIG_NO_TRANSLITERATION=1
endif

ifeq ($(BR2_ICU_NO_REGULAR_EXPRESSIONS), y)
ICU_CPPFLAGS += -DUCONFIG_NO_REGULAR_EXPRESSIONS=1
endif

ifeq ($(BR2_ICU_NO_FILE_IO), y)
ICU_CPPFLAGS += -DUCONFIG_NO_FILE_IO=1
endif

define ICU_MINIMIZE
	cp package/icu/icudt$(ICU_VERSION_MAJOR)l.dat $(@D)/source/data/in/
endef

ifeq ($(BR2_PACKAGE_ICU_MINIMIZED),y)
ICU_POST_EXTRACT_HOOKS += ICU_MINIMIZE
endif


$(eval $(autotools-package))
$(eval $(host-autotools-package))
