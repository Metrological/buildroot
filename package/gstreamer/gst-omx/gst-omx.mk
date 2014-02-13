#############################################################
#
# gst-omx
#
#############################################################
GST_OMX_VERSION = 40bf004fe6bdaa12b262a9b9924d069c17143f8e
GST_OMX_SOURCE = gst-omx-$(GST_OMX_VERSION).tar.gz
GST_OMX_SITE = http://cgit.freedesktop.org/gstreamer/gst-omx/snapshot/
GST_OMX_INSTALL_STAGING = YES

GST_OMX_POST_DOWNLOAD_HOOKS += GSTREAMER_COMMON_DOWNLOAD
GST_OMX_POST_EXTRACT_HOOKS += GSTREAMER_COMMON_EXTRACT

GST_OMX_DEPENDENCIES = gstreamer gst-plugins-base

GST_OMX_CONF_OPT += \
	--enable-experimental \
	--disable-static

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
GST_OMX_DEPENDENCIES += gst-plugins-bad
GST_OMX_CONF_OPT += --with-omx-target=rpi
GST_OMX_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include/IL -I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -Wno-deprecated-declarations"
endif

define GST_OMX_UPDATE_CONF
	mkdir -p $(@D)/m4
	$(SED) 's/\/opt\/vc/\/usr/' $(@D)/config/rpi/gstomx.conf
endef

define GST_OMX_RUN_AUTOCONF
	(cd $(@D); \
		LIBTOOLIZE=$(LIBTOOLIZE) \
		ACLOCAL_FLAGS=$(ACLOCAL_FLAGS) \
		ACLOCAL="$(ACLOCAL)" \
		AUTOHEADER=$(AUTOHEADER) \
		AUTOCONF=$(AUTOCONF) \
		AUTOMAKE=$(AUTOMAKE) \
		AUTOM4TE=$(HOST_DIR)/usr/bin/autom4te \
		NOCONFIGURE=1 \
		./autogen.sh --nocheck)
endef

GST_OMX_PRE_CONFIGURE_HOOKS += GST_OMX_RUN_AUTOCONF
GST_OMX_POST_PATCH_HOOKS += GST_OMX_UPDATE_CONF

$(eval $(autotools-package))
