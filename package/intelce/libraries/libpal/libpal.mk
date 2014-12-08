################################################################################
#
# libpal
#
################################################################################

LIBPAL_VERSION = $(INTELCE_VERSION).0
LIBPAL_SITE = $(INTELCE_SITE)/libpal/
LIBPAL_SITE_METHOD = local
LIBPAL_LICENSE = PROPRIETARY
LIBPAL_REDISTRIBUTE = NO

LIBPAL_DEPENDENCIES = libosal

LIBPAL_INSTALL_STAGING = YES

LIBPAL_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(INTELCE_SITE)/libsven/src/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/

define LIBPAL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBPAL_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBPAL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libpal/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libpal/
endef

define LIBPAL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
