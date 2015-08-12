################################################################################
#
# bcm-refsw
#
################################################################################
ifeq ($(BR2_BCM_REFSW_VERSION_V12), y)
	BCM_REFSW_SITE = file://../bcm-refsw
	BCM_REFSW_VERSION = 20121210
	BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
	BCM_REFSW_EXTRA_DOWNLOADS = refsw_wayland.tar.gz
else ifeq ($(BR2_BCM_REFSW_VERSION_V13), y)
	BCM_REFSW_SITE = file://../bcm-refsw
	BCM_REFSW_VERSION = 20131218
	BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
	BCM_REFSW_EXTRA_DOWNLOADS = refsw_wayland.tar.gz
else ifeq ($(BR2_BCM_REFSW_VERSION_V14), y)
	BCM_REFSW_SITE = file://../bcm-refsw
	BCM_REFSW_VERSION = 20141217
	BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
	BCM_REFSW_EXTRA_DOWNLOADS = refsw_wayland.tar.gz
else ifeq ($(BR2_BCM_REFSW_VERSION_V15), y)
	BCM_REFSW_SITE = file://../bcm-refsw
	BCM_REFSW_VERSION = 20150326
	BCM_REFSW_SOURCE = refsw_release_unified_$(BCM_REFSW_VERSION).src.tar.xz
	BCM_REFSW_EXTRA_DOWNLOADS = refsw_wayland.tar.gz
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
	B_REFSW_VERBOSE=y \
	NEXUS_HEADERS=y \
	TOOLCHAIN_ROOT=$(HOST_DIR)/usr/bin/ \
	SC_PLATFORM=bcm$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM})nexus

ifeq ($(BR2_PACKAGE_BCM_REFSW_PLATFORM_REV), D0)
BCM_MAKE_ENV += \
	NEXUS_USE_7449_VMS_SFF=y \
	NEXUS_FRONTEND_3128=y \
	NEXUS_PLATFORM_7449_CABLE=y \
	NEXUS_SYSTEM_CABLE=y \
	CHIP_REV_NOT_SUPPORTED=0 \
	SNMP_SUPPORT=n \
	STREAMING_SUPPORT=n \
	CABLE_SUPPORT=y \
	CDL_SUPPORT=n
endif

ifeq ($(BR2_BCMREFSW_WAYLAND_SUPPORT_EGL), y)
BCM_REFSW_DEPENDENCIES += wayland
BCM_WAYLAND_SUPPORT = -lwayland-client -lwayland-egl
else ifeq ($(BR2_BCMREFSW_WAYLAND_SUPPORT_NXPL), y)
BCM_REFSW_DEPENDENCIES += wayland
else ifeq ($(BR2_BCMREFSW_WAYLAND_SUPPORT_NEXUS), y)
BCM_REFSW_DEPENDENCIES += wayland
endif

ifeq ($(BR2_BCM_REFSW_DEBUG_LEVEL_OFF), y)
BCM_MAKE_ENV += B_REFSW_DEBUG=n
else 

ifeq ($(BR2_BCM_REFSW_DEBUG_LEVEL_ERROR), y)
BCM_MAKE_ENV += B_REFSW_DEBUG_LEVEL=err
else
BCM_MAKE_ENV += B_REFSW_DEBUG_LEVEL=wrn
endif
endif

ifneq ($(BCM_REFSW_VERSION),20121210)
BCM_OUTPUT = /obj.$(call qstrip,${BR2_PACKAGE_BCM_REFSW_PLATFORM})/
else
BCM_OUTPUT = /
endif

ifeq ($(BR2_BCMREFSW_VIDEODRIVER_V3D),y)
    BCM_NEXUS_EGL_PACKAGE=v3d
else ifeq ($(BR2_BCMREFSW_VIDEODRIVER_VC5),y)
    BCM_NEXUS_EGL_PACKAGE=vc5
endif

ifeq ($(BR2_PACKAGE_PLUGIN_SURFACECOMPOSITOR),y)
BCM_COMPOSITIONDEFINE=-DNEXUS_SURFACE_COMPOSITION
else ifeq ($(BR2_PACKAGE_DAWN_SDK),y)
BCM_COMPOSITIONDEFINE=-DNEXUS_SURFACE_COMPOSITION
else
BCM_COMPOSITIONDEFINE=
endif

ifeq ($(BR2_BCMREFSW_PROXY_MODE),y)
BCM_MAKE_ENV += NEXUS_MODE=proxy
else
BCM_MAKE_ENV += NEXUS_MODE=client
BCM_CLIENTLIB = -lnxclient
endif

BCM_MAKEFLAGS  = CROSS_COMPILE="${TARGET_CROSS}"
BCM_REFSW_DEPENDENCIES += wayland
BCM_MAKEFLAGS += TOOLCHAIN_DIR="${HOST_DIR}/usr/bin"
BCM_MAKEFLAGS += B_REFSW_ARCH=$(call qstrip,${BR2_ARCH})-linux
BCM_MAKEFLAGS += PATH=${HOST_DIR}/usr/bin:${PATH}
BCM_MAKEFLAGS += PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(STAGING_DIR)/usr/share/pkgconfig"
BCM_MAKEFLAGS += HOST_DIR="${HOST_DIR}"
BCM_MAKEFLAGS += APPLIBS_TOP=${BCM_APPS_DIR}
BCM_MAKEFLAGS += VCX=${BCM_NEXUS_EGL_PACKAGE}

define BCM_REFSW_EXTRACT_CMDS
    xz -d -c $(DL_DIR)/$(BCM_REFSW_SOURCE) \
        | $(TAR) --strip-components=0 -C $(@D) -xf -
    $(TAR) --strip-components=0 -C $(@D) -xf $(DL_DIR)/refsw_wayland.tar.gz
endef

define BCM_REFSW_BUILD_CMDS
	$(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/nexus/build all
	
    if [ $(BR2_BCM_REFSW_VERSION_V15) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/v3d/driver -f V3DDriver.mk; \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/v3d/platform/nexus -f platform_nexus.mk; \
	else \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/v3d -f V3DDriver.mk; \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/middleware/platform/nexus -f platform_nexus.mk; \
    fi
	
    $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/rockford/applications/khronos/v3d/nexus/cube

    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_EGL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/protocol all; \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-egl build; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NXPL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/protocol all; \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/nxpl-wayland build ; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NEXUS) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-nxclient build ; \
    fi
endef
   
define BCM_REFSW_INSTALL_LIBS
	if [ -f $(@D)$(BCM_OUTPUT)nexus/bin/libnexus_client.so ] ; then \
		$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnexus_client.so $1/usr/lib/libnxclient.so; \
	fi
	if [ -f $(@D)$(BCM_OUTPUT)nexus/bin/libnxclient.so ] ; then \
		$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnxclient.so $1/usr/lib/libnxclient.so; \
	fi

	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnexus.so $1/usr/lib/libnexus.so
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libv3ddriver.so $1/usr/lib/libv3ddriver.so
	$(INSTALL) -D $(@D)$(BCM_OUTPUT)nexus/bin/libnxpl.so $1/usr/lib/libnxpl.so

	# Some packages search for the common names
	rm -rf $1/usr/lib/libEGL.so $1/usr/lib/libGLESv2.so $1/usr/lib/libOpenVG.so
	cd $1/usr/lib && \
		ln -sf libv3ddriver.so libEGL.so && \
		ln -sf libv3ddriver.so libGLESv2.so && \
		ln -sf libv3ddriver.so libOpenVG.so

    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_EGL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-egl install ; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NXPL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/nxpl-wayland install ; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NEXUS) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-nxclient install ; \
    fi
endef

define BCM_REFSW_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/GLES2
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/EGL
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/VG
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/refsw
	sed 's/%NEXUS_COMPOSITION%/$(BCM_COMPOSITIONDEFINE)/g' package/bcm-refsw/egl.pc.in | \
        sed 's/%NEXUS_CLIENT%/$(BCM_CLIENTLIB)/g' | \
	sed 's/%WAYLAND_SUPPORT%/$(BCM_WAYLAND_SUPPORT)/g' >$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -m 644 package/bcm-refsw/glesv2.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 644 package/bcm-refsw/vg.pc $(STAGING_DIR)/usr/lib/pkgconfig/
	$(INSTALL) -m 644 $(@D)$(BCM_OUTPUT)nexus/bin/include/*.h $(STAGING_DIR)/usr/include/refsw/
	
	if [ $(BR2_BCM_REFSW_VERSION_V15) = y ] ; then \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/platform/nexus/*.h $(STAGING_DIR)/usr/include/refsw/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/driver/interface/khronos/include/GLES/*.h $(STAGING_DIR)/usr/include/GLES/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/driver/interface/khronos/include/GLES2/*.h $(STAGING_DIR)/usr/include/GLES2/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/driver/interface/khronos/include/EGL/*.h $(STAGING_DIR)/usr/include/EGL/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/driver/interface/khronos/include/VG/*.h $(STAGING_DIR)/usr/include/VG/; \
		$(INSTALL) -m 644 -D $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/driver/interface/khronos/include/KHR/khrplatform.h $(STAGING_DIR)/usr/include/KHR/khrplatform.h; \
	else \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/platform/nexus/*.h $(STAGING_DIR)/usr/include/refsw/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/interface/khronos/include/GLES/*.h $(STAGING_DIR)/usr/include/GLES/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/interface/khronos/include/GLES2/*.h $(STAGING_DIR)/usr/include/GLES2/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/interface/khronos/include/EGL/*.h $(STAGING_DIR)/usr/include/EGL/; \
		$(INSTALL) -m 644 $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/interface/khronos/include/VG/*.h $(STAGING_DIR)/usr/include/VG/; \
		$(INSTALL) -m 644 -D $(@D)/rockford/middleware/${BCM_NEXUS_EGL_PACKAGE}/interface/khronos/include/KHR/khrplatform.h $(STAGING_DIR)/usr/include/KHR/khrplatform.h; \
	fi 

	$(call BCM_REFSW_INSTALL_LIBS,$(STAGING_DIR))
	
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_EGL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-egl staging ; \
       $(INSTALL) -m 644 $(@D)/wayland/include/EGL/*.h $(STAGING_DIR)/usr/include/EGL/; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NXPL) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/nxpl-wayland staging ; \
    fi
    if [ $(BR2_BCMREFSW_WAYLAND_SUPPORT_NEXUS) = y ] ; then \
       $(BCM_MAKE_ENV) $(MAKE) $(BCM_MAKEFLAGS) -C $(@D)/wayland/wayland-nxclient staging ; \
    fi
endef

define BCM_REFSW_INSTALL_TARGET_CMDS
	$(INSTALL) -m 750 -D $(@D)$(BCM_OUTPUT)nexus/bin/nexus $(TARGET_DIR)/sbin/nexus
	if [ -f $(@D)$(BCM_OUTPUT)nexus/bin/bcmdriver.ko ] ; then \
		$(INSTALL) -m 644 -D $(@D)$(BCM_OUTPUT)nexus/bin/bcmdriver.ko $(TARGET_DIR)/lib/modules/bcmdriver.ko; \
	else \
		$(INSTALL) -m 644 -D $(@D)$(BCM_OUTPUT)nexus/bin/nexus.ko $(TARGET_DIR)/lib/modules/nexus.ko; \
		$(INSTALL) -D -m 755 package/bcm-refsw/S11nexus $(TARGET_DIR)/etc/init.d/S11nexus; \
	fi
	$(call BCM_REFSW_INSTALL_LIBS,$(TARGET_DIR))
endef

$(eval $(generic-package))
