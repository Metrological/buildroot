################################################################################
#
# gst1-plugins-dtcpip
#
################################################################################

GST1_PLUGINS_DTCPIP_VERSION = 294aac28d4a90fbf7adcd0c1e9c956acada1e036
GST1_PLUGINS_DTCPIP_SITE = $(call github,cablelabs,gst-plugins-dtcpip,$(GST1_PLUGINS_DTCPIP_VERSION))

GST1_PLUGINS_DTCPIP_DEPENDENCIES = host-pkgconf gstreamer1 gst1-plugins-base gst1-plugins-good

GST1_PLUGINS_DTCPIP_AUTORECONF = YES

GST1_PLUGINS_DTCPIP_CONF_OPT = \
	--disable-examples

$(eval $(autotools-package))
