################################################################################
#
# Ninja
#
################################################################################

NINJA_VERSION = c406d1c8adfedc1982e2c08ab95d581f65eb65de
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
