################################################################################
#
# libidl
#
################################################################################

LIBIDL_VERSION = $(INTELCE_VERSION).0
LIBIDL_SITE = $(INTELCE_SITE)/libidl/
LIBIDL_SITE_METHOD = local
LIBIDL_LICENSE = PROPRIETARY
LIBIDL_REDISTRIBUTE = NO

LIBIDL_DEPENDENCIES = libosal 

LIBIDL_INSTALL_STAGING = YES

LIBIDL_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(@D)/src/gpio/ \
	-I$(@D)/src/i2c/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/ 

define LIBIDL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBIDL_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/gpio/
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBIDL_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/i2c/
endef

define LIBIDL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/gpio/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/i2c/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libidl/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libidl/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libidl/i2c/
	$(INSTALL) -m 755 $(@D)/src/i2c/*.h $(STAGING_DIR)/usr/include/intelce/libidl/i2c/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libidl/gpio/
	$(INSTALL) -m 755 $(@D)/src/gpio/*.h $(STAGING_DIR)/usr/include/intelce/libidl/gpio/
endef

define LIBIDL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/gpio/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/i2c/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
