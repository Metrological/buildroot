################################################################################
#
# webkitgtk-shell
#
################################################################################

WEBKITGTK_SHELL_VERSION = 34b70e17ac6e3f0b92fee853b1c87e90bee55f39
WEBKITGTK_SHELL_SITE = $(call github,zdobersek,webkitgtk-shell,$(WEBKITGTK_SHELL_VERSION))
WEBKITGTK_SHELL_DEPENDENCIES = webkitgtk

WEBKITGTK_SHELL_AUTORECONF = YES

$(eval $(autotools-package))
