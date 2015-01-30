#############################################################
#
# libmng (Multiple-image Network Graphic library)
#
#############################################################

LIBMNG_VERSION = 2.0.2
LIBMNG_SITE = http://heanet.dl.sourceforge.net/sourceforge/libmng
LIBMNG_SOURCE = libmng-$(LIBMNG_VERSION).tar.gz
LIBMNG_INSTALL_STAGING = YES
LIBMNG_DEPENDENCIES = jpeg zlib

$(eval $(autotools-package)) 
