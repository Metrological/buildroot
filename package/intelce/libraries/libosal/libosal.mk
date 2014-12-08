################################################################################
#
# libosal
#
################################################################################

LIBOSAL_VERSION = $(INTELCE_VERSION).0
LIBOSAL_SITE = $(INTELCE_SITE)/libosal/
LIBOSAL_SITE_METHOD = local
LIBOSAL_LICENSE = PROPRIETARY
LIBOSAL_REDISTRIBUTE = NO

#LIBOSAL_DEPENDENCIES =

LIBOSAL_INSTALL_STAGING = YES

LIBOSAL_CFLAGS = \
	$(TARGET_CFLAGS) \
	-D_GNU_SOURCE \
	-I$(@D)/src/include/

define LIBOSAL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBOSAL_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBOSAL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libosal/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libosal/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libosal/os/
	$(INSTALL) -m 755 $(@D)/src/include/os/*.h $(STAGING_DIR)/usr/include/intelce/libosal/os/
endef

define LIBOSAL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
