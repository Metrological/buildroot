################################################################################
#
# tversity-client
# 
################################################################################

TVERSITY_CLIENT_VERSION = 0.0.1
TVERSITY_CLIENT_SITE = ../tversity-client
TVERSITY_CLIENT_SITE_METHOD = local

TVERSITY_CLIENT_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-bad gst1-plugins-good gst1-plugins-ugly  libopenmax
TVERSITY_CLIENT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_TVERSITY_CLIENT_DEBUG),y)
  TVERSITY_CLIENT_CONF_OPT += -DCLOUD_DEBUG=1
endif

$(eval $(cmake-package))
