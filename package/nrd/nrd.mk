################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = master
NRD_SITE_METHOD = git
NRD_SITE = git@github.com:Metrological/nrd.git
NRD_DEPENDENCIES = alsa-lib libjpeg libpng libmng freetype webp expat openssl c-ares portaudio directfb ffmpeg tremor

ifeq ($(BR2_PACKAGE_DDPSTUB),y)
NRD_DEPENDENCIES += stubs
endif

NRD_INSTALL_STAGING = NO

ifeq ($(BR2_ENABLE_DEBUG),y)
  NRD_CMAKE_FLAGS= -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
  NRD_CMAKE_FLAGS= -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

ifeq ($(BR2_NRD_GRAPHICS_DIRECTFB),y)
NRD_GRAPHICS=directfb
else ifeq ($(BR2_NRD_GRAPHICS_GLES2),y)
NRD_GRAPHICS=gles2
else ifeq ($(BR2_NRD_GRAPHICS_GLES2_EGL),y)
NRD_GRAPHICS=gles2-egl
else 
NRD_GRAPHICS=null
endif

NRD_INPUT=devinput

NRD_CONFIGURE_CMDS = 		\
	mkdir $(@D)/output;	\
	cd $(@D)/output;	\
	$(TARGET_MAKE_ENV) BUILDROOT_TOOL_PREFIX="$(GNU_TARGET_NAME)-" cmake $(@D)/netflix	\
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake	\
		$(NRD_CMAKE_FLAGS)								\
                -DGIBBON_GRAPHICS=$(NRD_GRAPHICS)						\
		-DGIBBON_INPUT=$(NRD_INPUT)							\
		-DSMALL_FLAGS:STRING="-s -O3" -DSMALL_CFLAGS:STRING="" -DSMALL_CXXFLAGS:STRING="-fvisibility=hidden -fvisibility-inlines-hidden" -DNRDAPP_TOOLS="manufSSgenerator" -DDPI_REFERENCE_DRM="none"

NRD_BUILD_CMDS = cd $(@D)/output ; $(TARGET_MAKE_ENV) make 

define NRD_INSTALL_TARGET_CMDS
	cp $(@D)/output/src/platform/gibbon/libJavaScriptCore.so $(TARGET_DIR)/usr/lib
	cp $(@D)/output/src/platform/gibbon/libWTF.so $(TARGET_DIR)/usr/lib
	cp $(@D)/output/src/platform/gibbon/netflix $(TARGET_DIR)/usr/bin
	cp $(@D)/output/src/platform/gibbon/manufss $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))
