#############################################################
#
# dejavu fonts
#
#############################################################

DEJAVU_FONTS_SITE = http://downloads.sourceforge.net/project/dejavu/dejavu/2.34
DEJAVU_FONTS_VERSION = 2.34
DEJAVU_FONTS_SOURCE = dejavu-fonts-ttf-$(DEJAVU_FONTS_VERSION).tar.bz2

ifeq ($(BR2_PACKAGE_DEJAVU_FONTS_MINIMIZED),y)
define DEJAVU_FONTS_INSTALL_TARGET_CMDS
    $(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/truetype/dejavu && \
    $(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/truetype/dejavu $(@D)/ttf/DejaVuSerif.ttf
endef
else
define DEJAVU_FONTS_INSTALL_TARGET_CMDS
    $(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/truetype/dejavu && \
    $(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/truetype/dejavu $(@D)/ttf/*.ttf
endef
endif

define DEJAVU_FONTS_UNINSTAL_TARGET_CMDS
    rm -rf $(TARGET_DIR)/usr/share/fonts/truetype/dejavu
endef

$(eval $(generic-package))
