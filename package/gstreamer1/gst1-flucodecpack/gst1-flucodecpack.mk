################################################################################
#
# gst1-flucodecpack
#
################################################################################

GST1_FLUCODECPACK_VERSION = 2.0.1
GST1_FLUCODECPACK_SUBDIR = 1.0
GST1_FLUCODECPACK_SITE = ../gst-flucodecpack/$(GST1_FLUCODECPACK_SUBDIR)
GST1_FLUCODECPACK_SITE_METHOD = local
GST1_FLUCODECPACK_LICENSE = PROPRIETARY
GST1_FLUCODECPACK_REDISTRIBUTE = NO

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SMOOTHSTREAMING),)
GST1_FLUCODECPACK_DEPENDENCIES += libcurl
define GST1_FLUCODECPACK_INSTALL_SMOOTHSTREAMING
	$(INSTALL) -m 755 $(@D)/flussdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstflussdemux.so
endef
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FAAD),)
define GST1_FLUCODECPACK_INSTALL_AAC
	$(INSTALL) -m 755 $(@D)/fluaacdec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluaacdec.so
endef
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_MAD),)
define GST1_FLUCODECPACK_INSTALL_MP3
	$(INSTALL) -m 755 $(@D)/flump3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstflump3dec.so
endef
endif

#ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_ASFDEMUX)$(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBMMS),)
#define GST1_FLUCODECPACK_INSTALL_ASF
#	$(INSTALL) -m 755 $(@D)/fluilbc.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluilbc.so; \
#	$(INSTALL) -m 755 $(@D)/fluwmadec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluwmadec.so; \
#	$(INSTALL) -m 755 $(@D)/fluasfdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluasfdemux.so
#endef
#endif

define GST1_FLUCODECPACK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/gstreamer-1.0; \
	$(INSTALL) -m 755 $(@D)/fluac3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluac3dec.so
#	$(INSTALL) -m 755 $(@D)/fluadpcm.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluadpcm.so
	$(GST1_FLUCODECPACK_INSTALL_MP3)
	$(GST1_FLUCODECPACK_INSTALL_AAC)
	$(GST1_FLUCODECPACK_INSTALL_ASF)
	$(GST1_FLUCODECPACK_INSTALL_SMOOTHSTREAMING)
endef

$(eval $(generic-package))
