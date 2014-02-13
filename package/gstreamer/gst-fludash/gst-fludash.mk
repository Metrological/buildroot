#############################################################
#
# gst-fludash
#
#############################################################
GST_FLUDASH_VERSION = 1.0.1
GST_FLUDASH_SITE = $(TOPDIR)/package/multimedia/gst-fludash/libs
GST_FLUDASH_SITE_METHOD = local
GST_FLUDASH_LICENSE = PROPRIETARY
GST_FLUDASH_REDISTRIBUTE = NO

GST_FLUDASH_DEPENDENCIES += gst-flucodecpack libxml2

define GST_FLUDASH_INSTALL_TARGET_CMDS
	if [ ! -f $(@D)/fludash.bin ]; then \
		cat $(@D)/README; \
	else \
		mkdir -p $(TARGET_DIR)/usr/lib/gstreamer-0.10; \
		if [ -f $(@D)/fludash-dxdrm.bin ]; then \
			$(INSTALL) -m 755 $(@D)/fludash-dxdrm.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfludash.so; \
		else \
			$(INSTALL) -m 755 $(@D)/fludash.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfludash.so; \
		fi \
	fi
endef

$(eval $(generic-package))
