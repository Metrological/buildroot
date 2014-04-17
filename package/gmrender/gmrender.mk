################################################################################
#
# gmrender
#
################################################################################

GMRENDER_VERSION = 61f5a8fe7291995fec73956c7425fdb564e3cb9f
GMRENDER_SITE = $(call github,hzeller,gmrender-resurrect,$(GMRENDER_VERSION))

GMRENDER_DEPENDENCIES = host-pkgconf libupnp gstreamer1 gst1-plugins-base

GMRENDER_AUTORECONF = YES

$(eval $(autotools-package))
