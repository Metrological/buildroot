################################################################################
#
# Ninja
#
################################################################################

NINJA_VERSION = f0f36ad1c72f6100a8957f035769fda50b69919f
NINJA_SITE = $(call github,martine,ninja,$(NINJA_VERSION))

define HOST_NINJA_CONFIGURE_CMDS
endef

define HOST_NINJA_BUILD_CMDS
    (cd $(@D); ./configure.py --bootstrap)
endef

define HOST_NINJA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ninja $(HOST_DIR)/usr/bin/ninja
endef

$(eval $(host-generic-package))
