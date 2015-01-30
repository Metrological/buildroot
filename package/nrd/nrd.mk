################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = master
NRD_SITE_METHOD = git
NRD_SITE = git@github.com:Metrological/nrd.git

NRD_INSTALL_STAGING = YES

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
BUILDTYPE=Release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

NRD_CONF_OPT = -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
 $(FLAGS)

NRD_CONFIGURE_CMDS = 		\
	mkdir $(@D)/output;	\
	cd $(@D)/output;	\
	VERBOSE=1 cmake $(@D)/netflix  \
		-DCMAKE_VERBOSE_MAKEFILE=ON \
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake	\
		-DSMALL_FLAGS:STRING="-s -O3" -DSMALL_CFLAGS:STRING="" -DSMALL_CXXFLAGS:STRING="-fvisibility=hidden -fvisibility-inlines-hidden" -DNRDAPP_TOOLS="manufSSgenerator" -DDPI_REFERENCE_DRM="none"

$(eval $(cmake-package))
