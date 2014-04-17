################################################################################
#
# gssdp
#
################################################################################

GSSDP_VERSION:=0.14.7
GSSDP_SOURCE:=gssdp-$(GSSDP_VERSION).tar.xz
GSSDP_SITE:=http://ftp.gnome.org/pub/GNOME/sources/gssdp/0.14/
GSSDP_INSTALL_STAGING = YES
GSSDP_INSTALL_TARGET = YES

GSSDP_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY)

GSSDP_DEPENDENCIES = host-pkgconf host-libglib2 libsoup

$(eval $(autotools-package))
