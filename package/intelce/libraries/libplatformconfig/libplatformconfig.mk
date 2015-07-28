################################################################################
#
# libplatform-config
#
################################################################################

LIBPLATFORMCONFIG_VERSION = $(INTELCE_VERSION).0
LIBPLATFORMCONFIG_SITE = $(INTELCE_SITE)/libplatform-config/
LIBPLATFORMCONFIG_SITE_METHOD = local
LIBPLATFORMCONFIG_LICENSE = PROPRIETARY
LIBPLATFORMCONFIG_REDISTRIBUTE = NO

#LIBPLATFORMCONFIG_DEPENDENCIES =

LIBPLATFORMCONFIG_INSTALL_STAGING = YES

LIBPLATFORMCONFIG_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/

define LIBPLATFORMCONFIG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBPLATFORMCONFIG_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBPLATFORMCONFIG_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libplatform-config/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libplatform-config/
endef

define LIBPLATFORMCONFIG_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
