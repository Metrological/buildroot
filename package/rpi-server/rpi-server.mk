################################################################################
#
# rpi-server
#
################################################################################

RPI_SERVER_VERSION = 0.0.1
RPI_SERVER_SITE = ../rpi-server
RPI_SERVER_SITE_METHOD = local
RPI_SERVER_LICENSE = PROPRIETARY

define RPI_SERVER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home/applications/rpi-server
	cp -Rf $(@D)/* $(TARGET_DIR)/home/applications/rpi-server/
	(cd $(TARGET_DIR)/home/applications/rpi-server && mkdir -p node_modules && \
		$(TARGET_CONFIGURE_OPTS) \
		LD="$(TARGET_CXX)" \
		npm_config_arch=$(NODEJS_CPU) \
		npm_config_nodedir=$(BUILD_DIR)/nodejs-$(NODEJS_VERSION) \
		$(HOST_DIR)/usr/bin/npm install \
	)
	$(INSTALL) -D -m 755 package/rpi-server/S70rpi-server $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
