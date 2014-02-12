################################################################################
#
# rpi-nixbrowser
#
################################################################################

RPI_NIXBROWSER_VERSION = 0.0.1
RPI_NIXBROWSER_SITE = $(TOPDIR)/package/rpi-nixbrowser/src
RPI_NIXBROWSER_SITE_METHOD = local
RPI_NIXBROWSER_DEPENDENCIES += webkitnix

$(eval $(cmake-package))
