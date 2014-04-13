################################################################################
#
# webkitgtk-shell
#
################################################################################

WEBKITGTK_SHELL_VERSION = b9644da61bf3844fde1a6ff160a75174b7b24a17
WEBKITGTK_SHELL_SITE = $(call github,zdobersek,webkitgtk-shell,$(WEBKITGTK_SHELL_VERSION))
WEBKITGTK_SHELL_DEPENDENCIES = webkitgtk

WEBKITGTK_SHELL_AUTORECONF = YES

$(eval $(autotools-package))
