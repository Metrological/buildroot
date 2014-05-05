GSTREAMER1_COMMON_VERSION = b474fcc04cbb22ff65468b6b1040d65bdb1dde61
GSTREAMER1_COMMON_SOURCE = common-$(GSTREAMER1_COMMON_VERSION).tar.gz
GSTREAMER1_COMMON_SITE = http://cgit.freedesktop.org/gstreamer/common/snapshot/

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

include package/gstreamer1/*/*.mk
