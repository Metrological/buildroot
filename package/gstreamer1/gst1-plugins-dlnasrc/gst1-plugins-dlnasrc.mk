################################################################################
#
# gst1-plugins-dlnasrc
#
################################################################################

GST1_PLUGINS_DLNASRC_VERSION = 2f0b88a55f677b5c1719787e2eeb1100315ed99a
GST1_PLUGINS_DLNASRC_SITE = $(call github,cablelabs,gst-plugins-dlnasrc,$(GST1_PLUGINS_DLNASRC_VERSION))

GST1_PLUGINS_DLNASRC_DEPENDENCIES = host-pkgconf libsoup gstreamer1 gst1-plugins-base gst1-plugins-good

GST1_PLUGINS_DLNASRC_AUTORECONF = YES

GST1_PLUGINS_DLNASRC_CONF_OPT = \
	--disable-examples

$(eval $(autotools-package))
