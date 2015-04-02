################################################################################
#
# horizonui
#
################################################################################

# There's no source to work with.
HORIZONUI_SOURCE =
HORIZONUI_VERSION = 20150401

define HORIZONUI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 package/horizonui/horizonui $(TARGET_DIR)/usr/bin/horizonui
	$(INSTALL) -D -m 755 package/horizonui/S90horizonui $(TARGET_DIR)/etc/init.d/S90horizonui
endef

$(eval $(generic-package))
