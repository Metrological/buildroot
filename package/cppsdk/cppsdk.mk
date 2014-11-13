################################################################################
#
# cppsdk
#
################################################################################

# CPPSDK_VERSION = 00a5981f771edc475aa5568f1cdd660d6aae2189
CPPSDK_VERSION = master
CPPSDK_SITE_METHOD = git
CPPSDK_SITE = git@github.com:Metrological/cppsdk.git
CPPSDK_INSTALL_STAGING = YES
CPPSDK_INSTALL_TARGET = YES

CPPSDK_CONF_OPT += \
  -DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake

ifeq ($(BR2_PACKAGE_CPPSDK_GENERICS),n)
CPPSDK_CONF_OPT += \
	-DCPPSDK_INCLUDE_GENERICS=false
endif

ifeq ($(BR2_PACKAGE_CPPSDK_WEBSOCKET),n)
CPPSDK_CONF_OPT += \
	-DCPPSDK_INCLUDE_WEBSOCKET=false
endif

ifeq ($(BR2_PACKAGE_CPPSDK_TRACING),n)
CPPSDK_CONF_OPT += \
	-DCPPSDK_INCLUDE_TRACING=false
endif

ifeq ($(BR2_PACKAGE_CPPSDK_DEVICES),n)
CPPSDK_CONF_OPT += \
	-DCPPSDK_INCLUDE_DEVICES=false
endif

$(eval $(cmake-package))



