################################################################################
#
# libusrsctp
#
################################################################################

LIBUSRSCTP_VERSION = cc07d5dc919cd98887198eb3ff21d983f229472b
LIBUSRSCTP_SITE = $(call github,ossy-szeged,sctp-refimpl,$(LIBUSRSCTP_VERSION))
LIBUSRSCTP_INSTALL_STAGING = YES
LIBUSRSCTP_AUTORECONF = YES
LIBUSRSCTP_LICENSE = New BSD License

define LIBUSRSCTP_CREATE_M4_DIR
	mkdir -p $(@D)/m4
	touch $(@D)/README
	touch $(@D)/NEWS
	touch $(@D)/AUTHORS
	touch $(@D)/ChangeLog
endef

LIBUSRSCTP_POST_PATCH_HOOKS += LIBUSRSCTP_CREATE_M4_DIR

$(eval $(autotools-package))
