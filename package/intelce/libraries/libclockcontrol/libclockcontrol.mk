################################################################################
#
# libclock-control
#
################################################################################

LIBCLOCKCONTROL_VERSION = $(INTELCE_VERSION).0
LIBCLOCKCONTROL_SITE = $(INTELCE_SITE)/libclock-control/
LIBCLOCKCONTROL_SITE_METHOD = local
LIBCLOCKCONTROL_LICENSE = PROPRIETARY
LIBCLOCKCONTROL_REDISTRIBUTE = NO

LIBCLOCKCONTROL_DEPENDENCIES = libosal libpal libplatformconfig libsystemutils

LIBCLOCKCONTROL_INSTALL_STAGING = YES

LIBCLOCKCONTROL_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(@D)/src/include/

LIBCLOCKCONTROL_LDFLAGS = \
	$(TARGET_LDFLAGS) \
	-L$(STAGING_DIR)/usr/lib/intelce/

define LIBCLOCKCONTROL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CPPFLAGS="$(TARGET_CPPFLAGS)" CFLAGS="$(LIBCLOCKCONTROL_CFLAGS)" LDFLAGS="$(LIBCLOCKCONTROL_LDFLAGS)" AR="$(TARGET_CROSS)ar" RANLIB="$(TARGET_CROSS)ranlib" -C $(@D)/src/
endef

define LIBCLOCKCONTROL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/{*.a,*.so} $(STAGING_DIR)/usr/lib/intelce/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/libclock-control/
	$(INSTALL) -m 755 $(@D)/src/include/*.h $(STAGING_DIR)/usr/include/intelce/libclock-control/
endef

define LIBCLOCKCONTROL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/intelce/
	$(INSTALL) -m 755 $(@D)/src/*.so $(TARGET_DIR)/usr/lib/intelce/
endef

$(eval $(generic-package))
