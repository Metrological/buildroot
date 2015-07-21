################################################################################
#
# gst1-omx
#
################################################################################

GST1_OMX_VERSION = d2df0fb032c36b366a08a1355c4f4c816eb53447
GST1_OMX_SOURCE = gst-omx-$(GST1_OMX_VERSION).tar.gz
GST1_OMX_SITE = http://cgit.freedesktop.org/gstreamer/gst-omx/snapshot/

GST1_OMX_LICENSE = LGPLv2.1
GST1_OMX_LICENSE_FILES = COPYING

GST1_OMX_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-bad libopenmax

GST1_OMX_AUTORECONF = YES

GST1_OMX_POST_DOWNLOAD_HOOKS += GSTREAMER1_COMMON_DOWNLOAD
GST1_OMX_POST_EXTRACT_HOOKS += GSTREAMER1_COMMON_EXTRACT

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GL),y)
GST1_OMX_DEPENDENCIES += gst1-plugins-bad
endif

GST1_OMX_CONF_OPT = \
	--disable-examples

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
GST1_OMX_CONF_OPT += \
	--with-omx-target=rpi
GST1_OMX_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) \
		-I$(STAGING_DIR)/usr/include/IL \
		-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
		-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif

ifeq ($(BR2_PACKAGE_BELLAGIO),y)
GST1_OMX_CONF_OPT += \
	--with-omx-target=bellagio
GST1_OMX_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) \
		-DOMX_VERSION_MAJOR=1 \
		-DOMX_VERSION_MINOR=1 \
		-DOMX_VERSION_REVISION=2 \
		-DOMX_VERSION_STEP=0"
endif

$(eval $(autotools-package))
