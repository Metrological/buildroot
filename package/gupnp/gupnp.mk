################################################################################
#
# gupnp
#
################################################################################

GUPNP_VERSION = 0.20.10
GUPNP_SOURCE = gupnp-$(GUPNP_VERSION).tar.xz
GUPNP_SITE = http://ftp.gnome.org/pub/GNOME/sources/gupnp/0.20/
GUPNP_INSTALL_STAGING = YES
GUPNP_INSTALL_TARGET = YES

GUPNP_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY)

GUPNP_DEPENDENCIES = libxml2 gssdp util-linux

$(eval $(autotools-package))
