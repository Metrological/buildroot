################################################################################
#
# libusrsctp
#
################################################################################

LIBUSRSCTP_VERSION = cc07d5dc919cd98887198eb3ff21d983f229472b
LIBUSRSCTP_SITE = $(call github,ossy-szeged,sctp-refimpl,$(LIBUSRSCTP_VERSION))
LIBUSRSCTP_INSTALL_STAGING = YES
LIBUSRSCTP_LICENSE = New BSD License
LIBUSRSCTP_LICENSE_FILES = COPYRIGHT

LIBUSRSCTP_CONFIGURE_CMDS = \
	(cd $(@D); \
	./bootstrap; \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--program-prefix="" \
		--disable-gtk-doc \
		--disable-doc \
		--disable-docs \
		--disable-documentation \
		--with-xmlto=no \
		--with-fop=no \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		$(DISABLE_IPV6) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(QUIET) \
	)

$(eval $(autotools-package))
