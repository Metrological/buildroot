################################################################################
#
# WPE
#
################################################################################

WPE_VERSION = 92a77a6f7d8727a541693f292dc73d9417b12d0f
WPE_SITE = $(call github,Metrological,WebKitForWayland,$(WPE_VERSION))

WPE_INSTALL_STAGING = YES
WPE_DEPENDENCIES = host-flex host-bison host-gperf host-ruby host-ninja \
	host-pkgconf zlib pcre libgles libegl cairo freetype fontconfig \
	harfbuzz icu libxml2 libxslt sqlite libsoup jpeg webp \
	wayland libxkbcommon

ifeq ($(BR2_WPE_GSTREAMER),y)
	WPE_DEPENDENCIES += \
		gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
else
	WPE_FLAGS += \
		-DENABLE_VIDEO=OFF -DENABLE_VIDEO_TRACK=OFF
endif

ifeq ($(BR2_PACKAGE_ATHOL),y)
#	WPE_FLAGS += -DUSE_SYSTEM_MALLOC=ON
	WPE_DEPENDENCIES += athol
	WPE_SHELL = Athol
else
	WPE_DEPENDENCIES += weston
	WPE_SHELL = Weston
endif
 
ifeq ($(BR2_ENABLE_DEBUG),y)
	BUILDTYPE = Debug
	WPE_BUILDDIR = $(@D)/debug
	WPE_FLAGS += \
		-DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" \
 		-DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
	BUILDTYPE = Release
	WPE_BUILDDIR = $(@D)/release
	WPE_FLAGS += \
		-DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
		-DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

ifeq ($(BR2_PACKAGE_WPE_USE_DXDRM_EME),y)
	WPE_FLAGS += -DENABLE_DXDRM=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_ENCRYPTED_MEDIA),y)
	WPE_FLAGS += -DENABLE_ENCRYPTED_MEDIA_V2=ON -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_MEDIA_SOURCE),y)
	WPE_FLAGS += -DENABLE_MEDIA_SOURCE=ON
endif

WPE_CONF_OPT = -DPORT=WPE -G Ninja \
	-DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
	$(WPE_FLAGS)

define WPE_BUILD_CMDS
	$(WPE_MAKE_ENV) $(HOST_DIR)/usr/bin/ninja -C $(WPE_BUILDDIR) libWebKit2.so WPE{Web,Network}Process WPE$(WPE_SHELL)Shell
endef

define WPE_INSTALL_STAGING_CMDS
	(cd $(WPE_BUILDDIR) && \
	cp bin/WPE{Network,Web}Process $(STAGING_DIR)/usr/bin/ && \
	cp -d lib/libWebKit* $(STAGING_DIR)/usr/lib/ && \
	cp lib/libWPE* $(STAGING_DIR)/usr/lib/ )
endef

define WPE_INSTALL_TARGET_CMDS
	(cd $(WPE_BUILDDIR) && \
	cp bin/WPE{Network,Web}Process $(TARGET_DIR)/usr/bin/ && \
	cp -d lib/libWebKit* $(TARGET_DIR)/usr/lib/ && \
	cp lib/libWPE* $(TARGET_DIR)/usr/lib/ && \
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/libWebKit2.so.0.0.1 )
endef

RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests

$(eval $(cmake-package))
