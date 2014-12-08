################################################################################
#
# libsven
#
################################################################################

LIBSVEN_VERSION = $(INTELCE_VERSION).4
LIBSVEN_SITE = $(INTELCE_SITE)/libsven/
LIBSVEN_SITE_METHOD = local
LIBSVEN_LICENSE = PROPRIETARY
LIBSVEN_REDISTRIBUTE = NO

LIBSVEN_DEPENDENCIES = autoeas libosal libpal libplatformconfig

LIBSVEN_INSTALL_STAGING = YES

LIBSVEN_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libpal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libplatform-config/

LIBSVEN_LDFLAGS = \
	$(TARGET_LDFLAGS) \
	-L$(STAGING_DIR)/usr/lib/intelce/

define LIBSVEN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBSVEN_CFLAGS)" LDFLAGS="$(LIBSVEN_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBSVEN_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libsven/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libsven/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libsven/eas/ce31xx/
	$(INSTALL) -m 755 $(@D)/src/eas/ce31xx/*.h $(STAGING_DIR)/usr/include/intelce/libsven/eas/ce31xx/
endef

define LIBSVEN_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
