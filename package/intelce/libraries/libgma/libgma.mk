################################################################################
#
# libgma
#
################################################################################

LIBGMA_VERSION = $(INTELCE_VERSION).0
LIBGMA_SITE = $(INTELCE_SITE)/libgma/
LIBGMA_SITE_METHOD = local
LIBGMA_LICENSE = PROPRIETARY
LIBGMA_REDISTRIBUTE = NO

#LIBGMA_DEPENDENCIES =

LIBGMA_INSTALL_STAGING = YES

LIBGMA_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/

define LIBGMA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBGMA_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBGMA_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgma/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libgma/
endef

define LIBGMA_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
