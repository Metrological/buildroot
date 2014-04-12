################################################################################
#
# webkitgtk-shell
#
################################################################################

WEBKITGTK_SHELL_VERSION = 916590f6617d04c01fc387e901ffc8ad1c16dc84
WEBKITGTK_SHELL_SITE = $(call github,zdobersek,webkitgtk-shell,$(WEBKITGTK_SHELL_VERSION))
WEBKITGTK_SHELL_DEPENDENCIES = webkitgtk

WEBKITGTK_SHELL_AUTORECONF = YES

$(eval $(autotools-package))
