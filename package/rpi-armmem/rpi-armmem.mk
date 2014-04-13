################################################################################
#
# rpi-armmem
#
################################################################################

RPI_ARMMEM_VERSION = 8a1fbee635a5c531b78fc90516cdcb6af71859fa
RPI_ARMMEM_SITE = $(call github,bavison,arm-mem,$(RPI_ARMMEM_VERSION))

define RPI_ARMMEM_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) libarmmem.so
endef

define RPI_ARMMEM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libarmmem.so $(TARGET_DIR)/usr/lib/libarmmem.so
	echo "/usr/lib/libarmmem.so" > $(TARGET_DIR)/etc/ld.so.preload
endef

$(eval $(generic-package))
