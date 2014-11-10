################################################################################
#
# libflash
#
################################################################################

LIBFLASH_VERSION = $(INTELCE_VERSION).0
LIBFLASH_SITE = $(INTELCE_SITE)/libflash/
LIBFLASH_SITE_METHOD = local
LIBFLASH_LICENSE = PROPRIETARY
LIBFLASH_REDISTRIBUTE = NO

LIBFLASH_DEPENDENCIES = libosal

LIBFLASH_INSTALL_STAGING = YES

LIBFLASH_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/

LIBFLASH_LDFLAGS = \
	$(TARGET_LDFLAGS) \
	-L$(@D)/lib/ \
	-L$(STAGING_DIR)/usr/lib/intelce/

define LIBFLASH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBFLASH_CFLAGS)" LDFLAGS="$(LIBFLASH_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBFLASH_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libflash/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libflash/
endef

define LIBFLASH_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/intelce/
endef

$(eval $(generic-package))
