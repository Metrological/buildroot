XBMC_VERSION = 7f24c5655aed37e2b27540d7b8077ed9d6dccc9a
XBMC_SITE = $(call github,xbmc,xbmc,$(XBMC_VERSION))
include $(sort $(wildcard package/xbmc/*/*.mk))
