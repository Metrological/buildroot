################################################################################
#
# libicepm
#
################################################################################

LIBICEPM_VERSION = $(INTELCE_VERSION).0
LIBICEPM_SITE = $(INTELCE_SITE)/libicepm/
LIBICEPM_SITE_METHOD = local
LIBICEPM_LICENSE = PROPRIETARY
LIBICEPM_REDISTRIBUTE = NO

LIBICEPM_DEPENDENCIES = libosal libpal libplatformconfig libsystemutils

LIBICEPM_INSTALL_STAGING = YES

LIBICEPM_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/

LIBICEPM_LDFLAGS = \
        $(TARGET_LDFLAGS) \
        -L$(STAGING_DIR)/usr/lib/intelce/

define LIBICEPM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBICEPM_CFLAGS)" LDFLAGS="$(LIBICEPM_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBICEPM_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libicepm/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libicepm/
endef

define LIBICEPM_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/intelce/
endef

$(eval $(generic-package))
