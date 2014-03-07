################################################################################
#
# gst1-flucodecpack
#
################################################################################

GST1_FLUCODECPACK_VERSION = 2.0.0
GST1_FLUCODECPACK_SITE = ../gst-flucodecpack/1.0
GST1_FLUCODECPACK_SITE_METHOD = local
GST1_FLUCODECPACK_LICENSE = PROPRIETARY
GST1_FLUCODECPACK_REDISTRIBUTE = NO

GST1_FLUCODECPACK_DEPENDENCIES += libcurl

define GST1_FLUCODECPACK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/gstreamer-1.0; \
	$(INSTALL) -m 755 $(@D)/fluaacdec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluaacdec.so; \
	$(INSTALL) -m 755 $(@D)/fluac3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluac3dec.so; \
	$(INSTALL) -m 755 $(@D)/fluadpcm.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluadpcm.so; \
	$(INSTALL) -m 755 $(@D)/fluasfdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluasfdemux.so; \
	$(INSTALL) -m 755 $(@D)/fluilbc.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluilbc.so; \
	$(INSTALL) -m 755 $(@D)/flump3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstflump3dec.so; \
	$(INSTALL) -m 755 $(@D)/flussdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstflussdemux.so; \
	$(INSTALL) -m 755 $(@D)/fluwmadec.bin $(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstfluwmadec.so
endef

$(eval $(generic-package))
