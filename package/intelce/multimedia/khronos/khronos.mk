################################################################################
#
# khronos
#
################################################################################

KHRONOS_VERSION = 21.1
KHRONOS_SITE = $(INTELCE_SITE)/khronos/
KHRONOS_SITE_METHOD = local
KHRONOS_LICENSE = PROPRIETARY
KHRONOS_REDISTRIBUTE = NO

KHRONOS_DEPENDENCIES = host-bison linux-headers linux libgdl libgma
#tofrodos dos2unix

KHRONOS_INSTALL_STAGING = YES

PVR_BUILD_OPTIONS+= \
	BUILD=release \
	COMP_VER=21.1-1 \
	REQUIREDKERNELVERSION=$(BR2_LINUX_KERNEL_VERSION) \
	EURASIAROOT=$(@D)/src/eurasia \
	KERNELDIR=$(LINUX_DIR) \
	TOOLCHAIN=$(shell dirname $(TARGET_CC)) \
	SYSTEM=sgx_intel_ce \
	CROSS_COMPILE=$(TARGET_CROSS) \
	BUILD_DEST=$(STAGING_DIR)/usr/ \
	INTEL_D3_CHANGES=1 \
	INTEL_D3_PAD=1 \
	INTEL_D3_FLUSH=1 \
	INTEL_D3_DISABLE_TEXTURE_STREAM=1 \
	INTEL_D3_P_CHANGES=1 \
	INTEL_D3_CACHED_CBUF=1 \
	INTEL_D3_PM=1 \
	SUPPORT_SGX535=1 \
	SGX535=1 \
	SGX_CORE_REV=121 \
	LDM_PLATFORM=1 \
	SUPPORT_SGX=1 \
	SUPPORT_XORG=0 \
	SUPPORT_DRI_DRM=0 \
	SUPPORT_OPENGLES1=0 \
\
	KARCH_CFLAGS="" \
	ARCH_CFLAGS="$(TARGET_CFLAGS)" \
\
	SYS_LIB_LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib/" \
	SYS_EXE_LDFLAGS="-Xlinker -rpath-link=$(STAGING_DIR)/usr/lib/" \
	LINUX_HEADERS_DIR="$(LINUX_HEADERS_DIR)"

define KHRONOS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src/eurasia/eurasiacon/build/linux/sgx_intel_ce/  \
	$(PVR_BUILD_OPTIONS)
endef

define KHRONOS_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/eurasia/eurasiacon/binary_sgx_intel_ce_release/{*.a,*.so} $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/
	$(INSTALL) -m 755 $(@D)/src/eurasia/eurasiacon/binary_sgx_intel_ce_release/*.h $(STAGING_DIR)/usr/include/intelce/khronos/
	$(INSTALL) -m 755 $(@D)/src/eurasia/pvr2d/pvr2d.h $(STAGING_DIR)/usr/include/intelce/khronos/
	$(INSTALL) -m 755 $(@D)/src/eurasia/eurasiacon/include/wsegl.h $(STAGING_DIR)/usr/include/intelce/khronos/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/EGL/
	$(INSTALL) -m 755 $(@D)/src/include/EGL/*.h $(STAGING_DIR)/usr/include/intelce/khronos/EGL/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/GLES/
	$(INSTALL) -m 755 $(@D)/src/include/GLES/*.h $(STAGING_DIR)/usr/include/intelce/khronos/GLES/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/GLES2/
	$(INSTALL) -m 755 $(@D)/src/include/GLES2/*.h $(STAGING_DIR)/usr/include/intelce/khronos/GLES2
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/KHR/
	$(INSTALL) -m 755 $(@D)/src/include/KHR/*.h $(STAGING_DIR)/usr/include/intelce/khronos/KHR/
	mkdir -p $(STAGING_DIR)/usr/include/intelce/khronos/VG/
	$(INSTALL) -m 755 $(@D)/src/include/VG/*.h $(STAGING_DIR)/usr/include/intelce/khronos/VG/
	$(INSTALL) -m 644 package/intelce/multimedia/khronos/files/*.pc $(STAGING_DIR)/usr/lib/pkgconfig/
endef

define KHRONOS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 $(@D)/src/eurasia/eurasiacon/binary_sgx_intel_ce_release/pvrsrvinit $(TARGET_DIR)/usr/bin/
	mkdir -p $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 $(@D)/src/eurasia/eurasiacon/binary_sgx_intel_ce_release/*.so $(TARGET_DIR)/usr/lib/
	mkdir -p $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 755 $(@D)/files/graphics.init $(TARGET_DIR)/etc/init.d/graphics
#	mkdir -p $(TARGET_DIR)/etc/
	$(INSTALL) -m 755 $(@D)/files/powervr.ini $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
