################################################################################
#
# bcm-refsw
#
################################################################################
ifeq ($(BR2_BCM_REFSW_VERSION_V12), y)
    BCM_REFSW_SITE = file://../bcm-refsw
    BCM_REFSW_VERSION = 20121210
    BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
else ifeq ($(BR2_BCM_REFSW_VERSION_V13), y)
    BCM_REFSW_SITE = file://../bcm-refsw
    BCM_REFSW_VERSION = 20131218
    BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
else
    BCM_REFSW_SITE = file:///
    BCM_REFSW_VERSION = CUSTOM
    BCM_REFSW_SOURCE = $(call qstrip,${BR2_BCMREFSW_CUSTOM_LOCATION})
endif

BCM_REFSW_DEPENDENCIES = linux host-pkgconf
BCM_REFSW_LICENSE = PROPRIETARY
BCM_REFSW_INSTALL_STAGING = YES
BCM_REFSW_INSTALL_TARGET = YES
BCM_MAKE_ENV = \
	NEXUS_TOP=${BCM_REFSW_DIR}/nexus \
	PLATFORM=$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM}) \
	NEXUS_PLATFORM=$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM}) \
	LINUX=${LINUX_DIR} \
	BCHP_VER=$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM_REV}) \
	NEXUS_HEADERS=y \
	TOOLCHAIN_ROOT=$(HOST_DIR)/usr/bin/ \
	SC_PLATFORM=bcm$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM})nexus

ifeq ($(BR2_ENABLE_DEBUG),y)
BCM_MAKE_ENV += B_REFSW_DEBUG=y
else
BCM_MAKE_ENV += B_REFSW_DEBUG=n
endif

ifneq ($(BCM_REFSW_VERSION),20121210)
BCM_OUTPUT = "/obj.$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM})/"
else
BCM_OUTPUT = "/"
endif

BCM_MAKEFLAGS  = CROSS_COMPILE="${TARGET_CROSS}"
BCM_MAKEFLAGS += TOOLCHAIN_DIR="${HOST_DIR}/usr/bin"
BCM_MAKEFLAGS += B_REFSW_ARCH=mipsel-linux
BCM_MAKEFLAGS += PATH=${HOST_DIR}/usr/bin:${PATH}
BCM_MAKEFLAGS += PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(STAGING_DIR)/usr/share/pkgconfig"
BCM_MAKEFLAGS += HOST_DIR="${HOST_DIR}"
BCM_MAKEFLAGS += APPLIBS_TOP=${BCM_APPS_DIR}

define BCM_REFSW_EXTRACT_CMDS
	xz -d -c $(DL_DIR)/$(BCM_REFSW_SOURCE) \
		| $(TAR) --strip-components=0 -C $(@D) -xf -
endef

define BCM_REFSW_BUILD_CMDS
	$(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/nexus/build all
	$(BCM_MAKE_ENV) NEXUS_MODE=client $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/nexus/build all
	$(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/v3d -f V3DDriver.mk
	$(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/platform/nexus -f platform_nexus.mk
	$(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/applications/khronos/v3d/nexus/cube
endef

define BCM_REFSW_INSTALL_LIBS
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnexus.so $1/usr/lib/libnexus.so
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnexus_client.so $1/usr/lib/libnexus_client.so
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libv3ddriver.so $1/usr/lib/libv3ddriver.so
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnxpl.so $1/usr/lib/libnxpl.so
endef

define BCM_REFSW_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES2
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/EGL
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/refsw
	$(INSTALL) -m 644 package/bcm-refsw/egl.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 644 package/bcm-refsw/glesv2.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 644 $(@D)$(BCM_OUTPUT)nexus/bin/include/*.h $(STAGING_DIR)/usr/include/refsw/
	$(INSTALL) -m 644 $(@D)/rockford/middleware/platform/nexus/*.h $(STAGING_DIR)/usr/include/refsw/
	$(INSTALL) -m 644 $(@D)/rockford/middleware/v3d/interface/khronos/include/GLES/*.h $(STAGING_DIR)/usr/include/GLES/
	$(INSTALL) -m 644 $(@D)/rockford/middleware/v3d/interface/khronos/include/GLES2/*.h $(STAGING_DIR)/usr/include/GLES2/
	$(INSTALL) -m 644 $(@D)/rockford/middleware/v3d/interface/khronos/include/EGL/*.h $(STAGING_DIR)/usr/include/EGL/
	$(INSTALL) -m 644 -D $(@D)/rockford/middleware/v3d/interface/khronos/include/KHR/khrplatform.h $(STAGING_DIR)/usr/include/KHR/khrplatform.h
	$(call BCM_REFSW_INSTALL_LIBS,$(STAGING_DIR))
endef

define BCM_REFSW_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(@D)$(BCM_OUTPUT)nexus/bin/bcmdriver.ko $(TARGET_DIR)/lib/modules/bcmdriver.ko
	$(call BCM_REFSW_INSTALL_LIBS,$(TARGET_DIR))
endef

$(eval $(generic-package))
