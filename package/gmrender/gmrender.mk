################################################################################
#
# gmrender
#
################################################################################

GMRENDER_VERSION = 45346446a25c353152c8a68ae64bb5deb6c855a3
GMRENDER_SITE = $(call github,hzeller,gmrender-resurrect,$(GMRENDER_VERSION))

GMRENDER_DEPENDENCIES = host-pkgconf libupnp gstreamer1 gst1-plugins-base

GMRENDER_AUTORECONF = YES

$(eval $(autotools-package))
