################################################################################
#
# gupnp-av
#
################################################################################

GUPNP_AV_VERSION = 0.12.5
GUPNP_AV_SOURCE = gupnp-av-$(GUPNP_AV_VERSION).tar.xz
GUPNP_AV_SITE = http://ftp.gnome.org/pub/GNOME/sources/gupnp-av/0.12/
GUPNP_AV_INSTALL_STAGING = YES
GUPNP_AV_INSTALL_TARGET = YES

GUPNP_AV_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY)

GUPNP_AV_DEPENDENCIES = gupnp

$(eval $(autotools-package))
