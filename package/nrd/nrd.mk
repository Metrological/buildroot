################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = master
NRD_SITE_METHOD = git
NRD_SITE = git@github.com:Metrological/nrd.git
NRD_DEPENDENCIES = alsa-lib libjpeg libpng libmng freetype webp expat openssl c-ares portaudio directfb ffmpeg

NRD_INSTALL_STAGING = YES

NRD_LIBC_VERSION = "-D__UCLIBC__MAJOR=9 -D__UCLIBC_MINOR__=33 -D__UCLIBC_SUBLEVEL__=2"
#NRD_LIBC_VERSION = "-D__GLIBC__=1 -D__GLIBC_MINOR__=3"

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
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake	\
		-DSMALL_FLAGS:STRING="-s -O3" -DSMALL_CFLAGS:STRING="" -DSMALL_CXXFLAGS:STRING="-fvisibility=hidden -fvisibility-inlines-hidden" -DNRDAPP_TOOLS="manufSSgenerator" -DDPI_REFERENCE_DRM="none"

NRD_BUILD_CMDS = cd $(@D)/output ; make 

$(eval $(cmake-package))
