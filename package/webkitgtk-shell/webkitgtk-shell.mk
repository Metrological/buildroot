################################################################################
#
# webkitgtk-shell
#
################################################################################

WEBKITGTK_SHELL_VERSION = 2bb51068e5697b3b4e494968f78cfc1ce790424d
WEBKITGTK_SHELL_SITE = $(call github,Metrological,webkitgtk-shell,$(WEBKITGTK_SHELL_VERSION))
WEBKITGTK_SHELL_DEPENDENCIES = webkitgtk

WEBKITGTK_SHELL_AUTORECONF = YES

$(eval $(autotools-package))
