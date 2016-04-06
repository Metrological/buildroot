################################################################################
#
# bcm-refsw
#
################################################################################

BCM_REFSW_VERSION = a313e0d2dc9afa09c64a1c84750801d422b9759f
BCM_REFSW_SITE = git@github.com:Metrological/bcm-refsw.git
BCM_REFSW_SITE_METHOD = git
BCM_REFSW_DEPENDENCIES = linux host-pkgconf host-flex host-bison host-gperf
BCM_REFSW_LICENSE = PROPRIETARY
BCM_REFSW_INSTALL_STAGING = YES
BCM_REFSW_INSTALL_TARGET = YES

BCM_REFSW_PROVIDES = libegl libgles

ifeq ($(BR2_arm),y)
BCM_REFSW_PLATFORM = 97439
BCM_REFSW_PLATFORM_REV = B0
BCM_REFSW_PLATFORM_VC = vc5
BCM_REFSW_MAKE_ENV += NEXUS_ENDIAN=BSTD_ENDIAN_LITTLE
else ifeq ($(BR2_mipsel),y)
BCM_REFSW_PLATFORM = 97429
BCM_REFSW_PLATFORM_REV = B0
BCM_REFSW_PLATFORM_VC = v3d
BCM_REFSW_MAKE_ENV += NEXUS_ENDIAN=BSTD_ENDIAN_BIG
endif

BCM_REFSW_CONF_OPTS += \
	CROSS_COMPILE="${TARGET_CROSS}" \
	LINUX=${LINUX_DIR} \
	HOST_DIR="${HOST_DIR}"

BCM_REFSW_MAKE_ENV += \
	B_REFSW_ARCH=$(ARCH)-linux \
	B_REFSW_VERBOSE=y \
	B_REFSW_DEBUG_LEVEL=wrn \
	BCHP_VER=$(BCM_REFSW_PLATFORM_REV) \
	NEXUS_TOP="$(BCM_REFSW_DIR)/nexus" \
	NEXUS_PLATFORM=$(BCM_REFSW_PLATFORM) \
	NEXUS_USE_7439_SFF=y \
	NEXUS_HEADERS=y \
	NEXUS_EXTRA_CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	NEXUS_EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
	VCX=$(BCM_REFSW_PLATFORM_VC) \
	V3D_EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
	V3D_EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
	CLIENT=y

ifeq ($(BR2_BCMREFSW_PROXY_MODE),y)
BCM_REFSW_MAKE_ENV += NEXUS_MODE=proxy
else
BCM_REFSW_MAKE_ENV += NEXUS_MODE=client
BCM_CLIENTLIB = -lnxclient
endif

BCM_REFSW_VCX = $(BCM_REFSW_DIR)/rockford/middleware/${BCM_REFSW_PLATFORM_VC}
BCM_REFSW_OUTPUT = $(BCM_REFSW_DIR)/obj.${BCM_REFSW_PLATFORM}
BCM_REFSW_BIN = ${BCM_REFSW_OUTPUT}/nexus/bin

define BCM_REFSW_BUILD_NEXUS
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	$(BCM_REFSW_CONF_OPTS) \
	$(BCM_REFSW_MAKE_ENV) \
		$(MAKE) -C $(@D)/nexus/build all \
		$(BCM_REFSW_BUILD_ADDITIONS)
endef

define BCM_REFSW_BUILD_VCX
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	$(BCM_REFSW_CONF_OPTS) \
	$(BCM_REFSW_MAKE_ENV) \
		$(MAKE) -C ${BCM_REFSW_VCX}/driver -f V3DDriver.mk \
			OBJDIR=${BCM_REFSW_OUTPUT}/rockford/middleware/v3d/driver/obj_${BCM_REFSW_PLATFORM}_release \
			LIBDIR=${BCM_REFSW_BIN}
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	$(BCM_REFSW_CONF_OPTS) \
	$(BCM_REFSW_MAKE_ENV) \
		$(MAKE) -C ${BCM_REFSW_VCX}/platform/nexus -f platform_nexus.mk \
			OBJDIR=${BCM_REFSW_OUTPUT}/rockford/middleware/v3d/platform/obj_${BCM_REFSW_PLATFORM}_release \
			LIBDIR=${BCM_REFSW_BIN}
endef

define BCM_REFSW_BUILD_NXSERVER
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	$(BCM_REFSW_CONF_OPTS) \
	$(BCM_REFSW_MAKE_ENV) \
		$(MAKE) -C $(@D)/nexus/nxclient/server all \
			LIBDIR=${BCM_REFSW_BIN}
endef

ifeq ($(BR2_PACKAGE_BCM_REFSW_EGLCUBE),y)
define BCM_REFSW_BUILD_EGLCUBE
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	$(BCM_REFSW_CONF_OPTS) \
	$(BCM_REFSW_MAKE_ENV) \
		$(MAKE) -C $(@D)/rockford/applications/khronos/v3d/nexus/cube all \
			LIBDIR=${BCM_REFSW_BIN}
endef
endif

define BCM_REFSW_INSTALL_LIBS
	$(INSTALL) -D $(BCM_REFSW_BIN)/libnexus.so $1/usr/lib/libnexus.so
	$(INSTALL) -D $(BCM_REFSW_BIN)/libv3ddriver.so $1/usr/lib/libv3ddriver.so
	$(INSTALL) -D $(BCM_REFSW_BIN)/libnxpl.so $1/usr/lib/libnxpl.so

	if [ -f $(BCM_REFSW_BIN)/libnexus_client.so ] ; then \
		$(INSTALL) -D $(BCM_REFSW_BIN)/libnexus_client.so $1/usr/lib/libnxclient.so; \
	fi

	#if [ -f $(BCM_REFSW_BIN)/libnxclient.so ] ; then \
	#	$(INSTALL) -D $(BCM_REFSW_BIN)/libnxclient.so $1/usr/lib/libnxclient.so
	#fi

	cd $1/usr/lib && ln -sf libv3ddriver.so libEGL.so && ln -sf libv3ddriver.so libGLESv2.so
endef

ifeq ($(BCM_REFSW_PLATFORM_VC),vc5)
define BCM_REFSW_INSTALL_EXTRA
	$(INSTALL) -D -m 755 package/bcm-refsw/S11wakeup $1/etc/init.d/S11wakeup
	$(INSTALL) -m 644 -D $(BCM_REFSW_BIN)/wakeup_drv.ko $1/lib/modules/wakeup_drv.ko
endef
endif

define BCM_REFSW_INSTALL_STAGING_NXSERVER
	   $(INSTALL) -D $(BCM_REFSW_BIN)/libnxclient.so $1/usr/lib/libnxclient.so
endef

ifeq ($(BR2_PACKAGE_BCM_WESTON),y)
define BCM_REFSW_INSTALL_TARGET_NXSERVER_INIT
endef
else
define BCM_REFSW_INSTALL_TARGET_NXSERVER_INIT
	$(INSTALL) -D -m 755 package/bcm-refsw/S70nxserver $(TARGET_DIR)/etc/init.d/S70nxserver;
endef
endif

define BCM_REFSW_INSTALL_TARGET_NXSERVER
	$(INSTALL) -D $(BCM_REFSW_BIN)/libnxclient.so $1/usr/lib/libnxclient.so
	if [ "x$(BR2_PACKAGE_PLUGIN_NXRESOURCECENTER)" = "x" ]; then \
		$(INSTALL) -m 755 -D $(BCM_REFSW_BIN)/nxserver $1/usr/bin/nxserver; \
		$(BCM_REFSW_INSTALL_TARGET_NXSERVER_INIT) \
	fi
endef

define BCM_REFSW_BUILD_CMDS
	$(BCM_REFSW_BUILD_NEXUS)
	$(BCM_REFSW_BUILD_NXSERVER)
	$(BCM_REFSW_BUILD_VCX)
	$(BCM_REFSW_BUILD_EGLCUBE)
endef

define BCM_REFSW_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES2
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/EGL
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/refsw
	$(INSTALL) -m 644 package/bcm-refsw/egl.pc $(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -m 644 package/bcm-refsw/glesv2.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 644 $(BCM_REFSW_BIN)/include/*.h $(STAGING_DIR)/usr/include/refsw/
	$(INSTALL) -m 644 $(BCM_REFSW_DIR)/nexus/nxclient/server/*.h $(STAGING_DIR)/usr/include/refsw/
	$(INSTALL) -m 644 $(BCM_REFSW_BIN)/include/platform_app.inc $(STAGING_DIR)/usr/include/
	$(INSTALL) -m 644 ${BCM_REFSW_VCX}/platform/nexus/*.h $(STAGING_DIR)/usr/include/refsw/
	$(INSTALL) -m 644 ${BCM_REFSW_VCX}/driver/interface/khronos/include/GLES/*.h $(STAGING_DIR)/usr/include/GLES/
	$(INSTALL) -m 644 ${BCM_REFSW_VCX}/driver/interface/khronos/include/GLES2/*.h $(STAGING_DIR)/usr/include/GLES2/
	$(INSTALL) -m 644 ${BCM_REFSW_VCX}/driver/interface/khronos/include/EGL/*.h $(STAGING_DIR)/usr/include/EGL/
	$(INSTALL) -m 644 -D ${BCM_REFSW_VCX}/driver/interface/khronos/include/KHR/khrplatform.h $(STAGING_DIR)/usr/include/KHR/khrplatform.h;
	$(INSTALL) -m 644 -D $(BCM_REFSW_BIN)/libnxserver.a $(STAGING_DIR)/usr/lib/libnxserver.a
	$(call BCM_REFSW_INSTALL_LIBS,$(STAGING_DIR))
	$(call BCM_REFSW_INSTALL_STAGING_NXSERVER,$(STAGING_DIR))
endef

define BCM_REFSW_INSTALL_TARGET_CMDS
	$(INSTALL) -m 750 -D $(BCM_REFSW_BIN)/nexus $(TARGET_DIR)/sbin/nexus

	$(INSTALL) -m 644 -D $(BCM_REFSW_BIN)/bcmdriver.ko $(TARGET_DIR)/lib/modules/bcmdriver.ko; \
	$(INSTALL) -m 644 -D $(BCM_REFSW_BIN)/nexus.ko $(TARGET_DIR)/lib/modules/nexus.ko; \
	$(INSTALL) -D -m 755 package/bcm-refsw/S11nexus $(TARGET_DIR)/etc/init.d/S11nexus; \

	$(call BCM_REFSW_INSTALL_EXTRA,$(TARGET_DIR))
	$(call BCM_REFSW_INSTALL_LIBS,$(TARGET_DIR))
	$(call BCM_REFSW_INSTALL_TARGET_NXSERVER,$(TARGET_DIR))
	$(call BCM_REFSW_INSTALL_TARGET_EGLCUBE,$(TARGET_DIR))
endef

$(eval $(generic-package))
