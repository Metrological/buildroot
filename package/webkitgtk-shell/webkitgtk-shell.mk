################################################################################
#
# webkitgtk-shell
#
################################################################################

WEBKITGTK_SHELL_VERSION = 85e10fbb2a9ee5ae34a78cb8f30c6515b518b07e
WEBKITGTK_SHELL_SITE = $(call github,Metrological,webkitgtk-shell,$(WEBKITGTK_SHELL_VERSION))
WEBKITGTK_SHELL_DEPENDENCIES = webkitgtk

WEBKITGTK_SHELL_AUTORECONF = YES

$(eval $(autotools-package))
