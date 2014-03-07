################################################################################
#
# gst-flucodecpack
#
################################################################################

GST_FLUCODECPACK_VERSION = 2.0.0
GST_FLUCODECPACK_SITE = ../gst-flucodecpack/0.10
GST_FLUCODECPACK_SITE_METHOD = local
GST_FLUCODECPACK_LICENSE = PROPRIETARY
GST_FLUCODECPACK_REDISTRIBUTE = NO

GST_FLUCODECPACK_DEPENDENCIES += libcurl

define GST_FLUCODECPACK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/gstreamer-0.10; \
	$(INSTALL) -m 755 $(@D)/fludownloader.bin $(TARGET_DIR)/usr/lib/libfludownloader.so.0.0.0; \
	$(INSTALL) -m 755 $(@D)/fluaacdec.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluaacdec.so; \
	$(INSTALL) -m 755 $(@D)/fluac3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluac3dec.so; \
	$(INSTALL) -m 755 $(@D)/fluadpcm.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluadpcm.so; \
	$(INSTALL) -m 755 $(@D)/fluasfdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluasfdemux.so; \
	$(INSTALL) -m 755 $(@D)/fluilbc.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluilbc.so; \
	$(INSTALL) -m 755 $(@D)/flump3dec.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstflump3dec.so; \
	$(INSTALL) -m 755 $(@D)/flumpegdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstflumpegdemux.so; \
	$(INSTALL) -m 755 $(@D)/flussdemux.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstflussdemux.so; \
	$(INSTALL) -m 755 $(@D)/fluwmadec.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfluwmadec.so; \
	(cd $(TARGET_DIR)/usr/lib/; \
		ln -sfn libfludownloader.so.0.0.0 libfludownloader.so.0; \
		ln -sfn libfludownloader.so.0 libfludownloader.so; \
	)
endef

$(eval $(generic-package))
