################################################################################
#
# libhdmihdcp
#
################################################################################

LIBHDMIHDCP_VERSION = $(INTELCE_VERSION).0
LIBHDMIHDCP_SITE = $(INTELCE_SITE)/libhdmi-hdcp/
LIBHDMIHDCP_SITE_METHOD = local
LIBHDMIHDCP_LICENSE = PROPRIETARY
LIBHDMIHDCP_REDISTRIBUTE = NO

LIBHDMIHDCP_DEPENDENCIES = openssl libosal libpal libsec libflash

LIBHDMIHDCP_INSTALL_STAGING = YES

LIBHDMIHDCP_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/libflash/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libpal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libsec/

LIBHDMIHDCP_LDFLAGS = \
	$(TARGET_LDFLAGS)

define LIBHDMIHDCP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBHDMIHDCP_CFLAGS)" LDFLAGS="$(LIBHDMIHDCP_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBHDMIHDCP_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libhdmi-hdcp/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libhdmi-hdcp/
endef

define LIBHDMIHDCP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
