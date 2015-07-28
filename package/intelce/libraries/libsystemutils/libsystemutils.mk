################################################################################
#
# libsystem-utils
#
################################################################################

LIBSYSTEMUTILS_VERSION = $(INTELCE_VERSION).0
LIBSYSTEMUTILS_SITE = $(INTELCE_SITE)/libsystem-utils/
LIBSYSTEMUTILS_SITE_METHOD = local
LIBSYSTEMUTILS_LICENSE = PROPRIETARY
LIBSYSTEMUTILS_REDISTRIBUTE = NO

LIBSYSTEMUTILS_DEPENDENCIES = libosal libpal libplatformconfig

LIBSYSTEMUTILS_INSTALL_STAGING = YES

LIBSYSTEMUTILS_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libpal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libplatform-config/

LIBSYSTEMUTILS_LDFLAGS = \
	$(TARGET_LDFLAGS)

define LIBSYSTEMUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBSYSTEMUTILS_CFLAGS)" LDFLAGS="$(LIBSYSTEMUTILS_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBSYSTEMUTILS_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libsystem-utils/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libsystem-utils/
endef

define LIBSYSTEMUTILS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
