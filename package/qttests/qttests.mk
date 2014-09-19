QTTESTS_DEPENDENCIES = qt5base

QTTESTS_VERSION = 1f2b86b2c37965ca526b7e5733c89f9b5e779a9a
QTTESTS_SITE = $(call github,magomez,qttests,$(QTTESTS_VERSION))

define QTTESTS_CONFIGURE_CMDS
        (cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define QTTESTS_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTTESTS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/stencil/stencil $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/eglimage/eglimage-renderer/eglimage-renderer $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/eglimage/eglimage-viewer/eglimage-viewer $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
