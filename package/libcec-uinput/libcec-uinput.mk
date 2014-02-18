################################################################################
#
# libcec-uinput
#
################################################################################

LIBCEC_UINPUT_VERSION = 219b93720a97223be36e32cb7d1fca2310a01a1a
LIBCEC_UINPUT_SITE = $(call github,bramp,libcec-daemon,$(LIBCEC_UINPUT_VERSION))
LIBCEC_UINPUT_INSTALL_STAGING = YES
LIBCEC_UINPUT_INSTALL_TARGET = YES
LIBCEC_UINPUT_LICENSE = BSD
LIBCEC_UINPUT_LICENSE_FILES = LICENCE

LIBCEC_UINPUT_DEPENDENCIES = libcec boost log4cplus

define LIBCEC_UINPUT_CONFIGURE_CMDS
endef

define LIBCEC_UINPUT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		LDFLAGS="-lcec -ldl -lboost_program_options -llog4cplus -lbcm_host -lvcos -lvchiq_arm"
endef

define LIBCEC_UINPUT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/libcec-daemon $(TARGET_DIR)/usr/bin/cecd
	$(INSTALL) -D -m 755 package/libcec-uinput/S70cecd $(TARGET_DIR)/etc/init.d/S70cecd
endef

$(eval $(generic-package))
