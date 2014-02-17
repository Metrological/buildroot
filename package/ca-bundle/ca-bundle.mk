################################################################################
#
# ca-bundle
#
################################################################################

CA_BUNDLE_VERSION = 1.0.0
CA_BUNDLE_SITE = $(TOPDIR)/package/ca-bundle/bin
CA_BUNDLE_SITE_METHOD = local
CA_BUNDLE_DEPENDENCIES = openssl

define CA_BUNDLE_INSTALL_TARGET_CMDS
	$(@D)/mk-ca-bundle.pl > $(@D)/ca-bundle.crt
	mkdir -p $(TARGET_DIR)/etc/ssl/certs
	mkdir -p $(TARGET_DIR)/etc/ssl/CA/private
	cp $(@D)/ca-bundle.crt $(TARGET_DIR)/etc/ssl/certs/
	(cd $(TARGET_DIR)/etc/ssl/certs; \
		ln -sf ca-bundle.crt ca-certificates.crt; \
	)
	(cd $(TARGET_DIR)/etc/ssl; \
		ln -sf certs/ca-bundle.crt cert.pem; \
	)
endef

$(eval $(generic-package))
