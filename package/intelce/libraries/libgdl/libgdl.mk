################################################################################
#
# libgdl
#
################################################################################

LIBGDL_VERSION = $(INTELCE_VERSION).4
LIBGDL_SITE = $(INTELCE_SITE)/libgdl/
LIBGDL_SITE_METHOD = local
LIBGDL_LICENSE = PROPRIETARY
LIBGDL_REDISTRIBUTE = NO

LIBGDL_DEPENDENCIES = openssl libosal libpal libplatformconfig libsystemutils libicepm libsven libclockcontrol libsec libflash libhdmihdcp libidl

LIBGDL_INSTALL_STAGING = YES

LIBGDL_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/ \
	-I$(@D)/src/gdl/include/ \
	-I$(STAGING_DIR)/usr/include/intelce/libclock-control/ \
	-I$(STAGING_DIR)/usr/include/intelce/libhdmi-hdcp/ \
	-I$(STAGING_DIR)/usr/include/intelce/libicepm/ \
	-I$(STAGING_DIR)/usr/include/intelce/libidl/ \
	-I$(STAGING_DIR)/usr/include/intelce/libplatform-config/ \
	-I$(STAGING_DIR)/usr/include/intelce/libosal/ \
	-I$(STAGING_DIR)/usr/include/intelce/libsystem-utils/

LIBGDL_LDFLAGS = \
	$(TARGET_LDFLAGS) \
	-L$(STAGING_DIR)/usr/lib/intelce/

define LIBGDL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBGDL_CFLAGS)" LDFLAGS="$(LIBGDL_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_RANLIB)" -C $(@D)/src/disputil/

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBGDL_CFLAGS)" LDFLAGS="$(LIBGDL_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_RANLIB)" -C $(@D)/src/gdl/

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBGDL_CFLAGS)" LDFLAGS="$(LIBGDL_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_RANLIB)" -C $(@D)/src/pd/
endef

define LIBGDL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/gdl/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/disputil/*.a $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/pd/pd_hdmi/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/pd/pd_null/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/gdl/
	$(INSTALL) -m 755 $(@D)/src/gdl/include/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/gdl/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/pd/pd_hdmi/
	$(INSTALL) -m 755 $(@D)/src/pd/pd_hdmi/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/pd/pd_hdmi/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/pd/inttvenc/
	$(INSTALL) -m 755 $(@D)/src/pd/inttvenc/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/pd/inttvenc/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/hals/hdmi/
	$(INSTALL) -m 755 $(@D)/src/hals/hdmi/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/hals/hdmi/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libgdl/hals/inttvenc/
	$(INSTALL) -m 755 $(@D)/src/hals/inttvenc/*.h $(STAGING_DIR)/usr/include/intelce/libgdl/hals/inttvenc/
endef

define LIBGDL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/gdl/*.so $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/pd/pd_hdmi/*.so $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/pd/pd_null/*.so $(TARGET_DIR)/usr/lib/intelce/
endef

$(eval $(generic-package))
