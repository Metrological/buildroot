GSTREAMER1_COMMON_VERSION = bcb1518c08c889dd7eda06936fc26cad85fac755
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

include package/gstreamer1/*/*.mk
