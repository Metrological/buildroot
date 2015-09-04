GSTREAMER1_COMMON_VERSION = 44a351788c83205f179b26af04f0eeaafb3b0d95
GSTREAMER1_COMMON_SOURCE = common-$(GSTREAMER1_COMMON_VERSION).tar.gz
GSTREAMER1_COMMON_SITE = http://cgit.freedesktop.org/gstreamer/common/snapshot/

GSTREAMER1_VERSION = 1.4.5

define GSTREAMER1_COMMON_DOWNLOAD
	$(call DOWNLOAD,$(GSTREAMER1_COMMON_SITE)$(GSTREAMER1_COMMON_SOURCE),$(GSTREAMER1_COMMON_SOURCE))
endef

define GSTREAMER1_COMMON_EXTRACT
	$(INFLATE.gz) $(DL_DIR)/$(GSTREAMER1_COMMON_SOURCE) | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 \
		-C $(@D)/common $(TAR_OPTIONS) -
	mkdir -p $(@D)/m4
	touch $(@D)/ABOUT-NLS
	touch $(@D)/config.rpath
endef

define GSTREAMER1_FIX_AUTOPOINT
	cd $(@D) && PATH=$(HOST_PATH) autopoint --force
endef

define GSTREAMER1_REMOVE_LA_FILES
	rm -f $(TARGET_DIR)/usr/lib/libgst*.la $(TARGET_DIR)/usr/lib/gstreamer-1.0/*.la
	rm -f $(TARGET_DIR)/usr/lib/libgst*.a $(TARGET_DIR)/usr/lib/gstreamer-1.0/*.a
endef

include package/gstreamer1/*/*.mk
