OMXPLAYER_VERSION = fcfb7911af3b81c84e1da920018fb9e2ae24d57e
OMXPLAYER_SITE = git://github.com/huceke/omxplayer.git
OMXPLAYER_SITE_METHOD = git
OMXPLAYER_DEPENDENCIES = ffmpeg freetype boost pcre rpi-userland

OMXPLAYER_CONFIG_ENV = \
	BUILDROOT=$(TOPDIR) \
	SDKSTAGE=$(STAGING_DIR) \
	TARGETFS=$(TARGET_DIR) \
	TOOLCHAIN=$(HOST_DIR)/usr/ \
	HOST=arm-raspberrypi-linux-gnueabi \
	SYSROOT=$(HOST_DIR)/usr/arm-buildroot-linux-gnueabi/sysroot \
	LD="$(TARGET_LD)" \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	OBJDUMP=$(HOST_DIR)/usr/bin/$(TARGET_CROSS)objdump \
	RANLIB=$(HOST_DIR)/usr/bin/$(TARGET_CROSS)ranlib \
	STRIP=$(HOST_DIR)/usr/bin/$(TARGET_CROSS)strip \
	AR=$(HOST_DIR)/usr/bin/$(TARGET_CROSS)ar \
	CXXCP="$(CXX) -E" \
	PATH=$(HOST_DIR)/usr/bin:$(PATH) \
	CFLAGS="$(TARGET_CFLAGS) -Wno-psabi -mno-apcs-stack-check -O3 -mstructure-size-boundary=32 -mno-sched-prolog" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	INCLUDES="-isystem$(STAGING_DIR)/usr/include -isystem$(STAGING_DIR)/usr/include/interface/vcos/pthreads -isystem$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -isystem$(STAGING_DIR)/usr/include/freetype2"
	

define OMXPLAYER_CONFIGURE_CMDS
	$(OMXPLAYER_CONFIG_ENV) $(MAKE) -C $(@D) clean
endef

define OMXPLAYER_BUILD_CMDS
	$(OMXPLAYER_CONFIG_ENV) $(MAKE) -C $(@D)
endef

define OMXPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/omxplayer.bin $(TARGET_DIR)/usr/bin/omxplayer.bin
	$(INSTALL) -m 755 $(@D)/omxplayer $(TARGET_DIR)/usr/bin/omxplayer
	mkdir -p $(TARGET_DIR)/usr/share/fonts/
	$(INSTALL) -m 644 $(@D)/fonts/FreeSans.ttf $(TARGET_DIR)/usr/share/fonts/
endef

define OMXPLAYER_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/bin/omxplayer.bin
	-rm $(TARGET_DIR)/usr/bin/omxplayer
	-rm $(TARGET_DIR)/usr/share/fonts/FreeSans.ttf
endef

$(eval $(generic-package))
