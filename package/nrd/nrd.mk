################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = master
NRD_SITE = git@github.com:Metrological/netflix.git
NRD_SITE_METHOD = git
NRD_LICENSE = PROPRIETARY
NRD_DEPENDENCIES = freetype icu jpeg libpng libmng webp harfbuzz expat openssl c-ares libcurl graphite2 ffmpeg
NRD_RUNTIMEDATA_LOCATION = /var/lib/netflix
NRD_INSTALL_STAGING = NO
NRD_CMAKE_FLAGS = -DBUILD_DPI_DIRECTORY=$(@D)/partner/dpi

################################################################################
# OPTIONS: Display
################################################################################
ifeq ($(findstring y,$(BR2_PACKAGE_NRD_GRAPHICS_GLES2)$(BR2_PACKAGE_NRD_GRAPHICS_RPI)),y)
	NRD_DEPENDENCIES += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_ES))
endif

ifeq ($(findstring y,$(BR2_PACKAGE_NRD_GRAPHICS_GLES2_EGL)$(BR2_PACKAGE_NRD_GRAPHICS_RPI)),y)
	NRD_DEPENDENCIES += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))
endif

ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_DIRECTFB),y)
	NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=directfb
	NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=posix
	NRD_DEPENDENCIES += alsa-lib portaudio webp ffmpeg tremor directfb
else ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_GLES2),y)
	NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=gles2
	NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=posix
else ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_GLES2_EGL),y)
	NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=gles2-egl
	NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=posix
else ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_RPI),y)
	NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=rpi-egl
	NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=rpi
else
	NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=null
	NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=posix
endif

################################################################################
# OPTIONS: Playback
################################################################################
ifeq ($(BR2_PACKAGE_NRD_PLAYER_SKELETON),y)
	NRD_CMAKE_FLAGS += -DDPI_IMPLEMENTATION=skeleton
else ifeq ($(BR2_PACKAGE_NRD_PLAYER_REFERENCE),y)
	NRD_CMAKE_FLAGS += -DDPI_IMPLEMENTATION=reference
else ifeq ($(BR2_PACKAGE_NRD_PLAYER_RPI),y)
	NRD_CMAKE_FLAGS += -DDPI_IMPLEMENTATION=reference
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_VIDEO_DECODER=openmax-il
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_VIDEO_RENDERER=openmax-il
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_AUDIO_DECODER=ffmpeg
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_AUDIO_RENDERER=openmax-il
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_AUDIO_MIXER=none
endif

ifeq ($(BR2_PACKAGE_DDPSTUB),y)
	NRD_DEPENDENCIES += stubs
endif

################################################################################
# OPTIONS: DRM
################################################################################
ifeq ($(BR2_PACKAGE_NRD_PLAYREADY25),y)
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_DRM=playready2.5-ss-tee
	NRD_PLAYREADY_CONFIG = $(INSTALL) -m 644  $(TOPDIR)/package/nrd/playready.cmake $(@D)/partner/dpi/reference;
else ifeq ($(BR2_PACKAGE_NRD_DXDRM),y)
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_DRM=none
else
	NRD_CMAKE_FLAGS += -DDPI_REFERENCE_DRM=none
endif

################################################################################
# OPTIONS: Input
################################################################################
ifeq ($(BR2_PACKAGE_NRD_INPUT_NULL),y)
	NRD_CMAKE_FLAGS += -DGIBBON_INPUT=null
else ifeq ($(BR2_PACKAGE_NRD_INPUT_DEVINPUT),y)
	NRD_CMAKE_FLAGS += -DGIBBON_INPUT=devinput
else
	NRD_CMAKE_FLAGS += -DGIBBON_INPUT=null
endif

################################################################################
# OPTIONS: Application Settings
################################################################################
ifeq ($(BR2_PACKAGE_NRD_IPV6_SUPPORT),y)
	NRD_CMAKE_FLAGS += -DNRDP_HAS_IPV6=1
else
	NRD_CMAKE_FLAGS += -DNRDP_HAS_IPV6=0
endif

ifeq ($(BR2_PACKAGE_NRD_NICE_THREADS),y)
	NRD_CMAKE_FLAGS += -DGIBBON_NICE_THREADS=1
endif

ifeq ($(BR2_PACKAGE_NRD_APPLICATION),y)
	NRD_CMAKE_FLAGS += -DGIBBON_MODE=executable
else ifeq ($(BR2_PACKAGE_NRD_DYNAMICLIB),y)
	NRD_CMAKE_FLAGS += -DGIBBON_MODE=shared
	NRD_RELOCATION_OPTION = -fPIC
	NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DYNAMIC=0
else ifeq ($(BR2_PACKAGE_NRD_STATICLIB),y)
	NRD_CMAKE_FLAGS += -DGIBBON_MODE=static
	NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DYNAMIC=0
endif

################################################################################
# OPTIONS: Compiler settings
################################################################################
ifeq ($(BR2_PACKAGE_NRD_DEBUG_BUILD),y)
NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DEBUG=1
NRD_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS_DEBUG="$(NRD_RELOCATION_OPTION) $(TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS_DEBUG="$(NRD_RELOCATION_OPTION) $(TARGET_CXXFLAGS)"
else
NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DEBUG=0
NRD_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS_RELEASE="$(NRD_RELOCATION_OPTION) $(TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS_RELEASE="$(NRD_RELOCATION_OPTION) $(TARGET_CXXFLAGS)"
endif

################################################################################
# CONFIGURE:
################################################################################
NRD_CONFIGURE_CMDS = 										\
	$(NRD_PLAYREADY_CONFIG)									\
	mkdir $(@D)/output;									\
	cd $(@D)/output; 									\
	$(TARGET_MAKE_ENV) 									\
	BUILDROOT_TOOL_PREFIX="$(GNU_TARGET_NAME)-" 						\
	cmake 											\
		-DCMAKE_SYSROOT=$(STAGING_DIR) 							\
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake 	\
		-DSMALL_FLAGS:STRING="-s -O3" 							\
		-DSMALL_CFLAGS:STRING="" 							\
		-DSMALL_CXXFLAGS:STRING="-fvisibility=hidden -fvisibility-inlines-hidden"	\
		-DNRDP_TOOLS="manufSSgenerator"							\
		$(NRD_CMAKE_FLAGS) 								\
		$(@D)/netflix 

################################################################################
# BUILD:
################################################################################
NRD_BUILD_CMDS = cd $(@D)/output ; $(TARGET_MAKE_ENV) make 

################################################################################
# STAGING:
################################################################################
define NRD_STAGING_SET_DEFINITION
        mkdir -p $(STAGING_DIR)/usr/include/nrd
        mkdir -p $(STAGING_DIR)/usr/include/nrd/nrd
        mkdir -p $(STAGING_DIR)/usr/include/nrd/nrdbase
        mkdir -p $(STAGING_DIR)/usr/include/nrd/nrdase
        mkdir -p $(STAGING_DIR)/usr/include/nrd/nrdnet
        mkdir -p $(STAGING_DIR)/usr/include/nrd/nrdapp
        mkdir -p $(STAGING_DIR)/usr/include/nrd/external
        cp -R $(@D)/output/include/nrdapp/config.h $(STAGING_DIR)/usr/include/nrd
	ln -s ./nrd/ $(STAGING_DIR)/usr/include/gibbon
	ln -s ../config.h $(STAGING_DIR)/usr/include/nrd/nrd/config.h
	ln -s ../config.h $(STAGING_DIR)/usr/include/nrd/nrdbase/config.h
	ln -s ../config.h $(STAGING_DIR)/usr/include/nrd/nrdapp/config.h
	ln -s ../config.h $(STAGING_DIR)/usr/include/nrd/nrdnet/config.h
        cp -R $(@D)/netflix/nrdlib/src/base/*.h $(STAGING_DIR)/usr/include/nrd/nrdbase
        cp -R $(@D)/netflix/3rdparty/mongoose/*.h $(STAGING_DIR)/usr/include/nrd/nrdapp
        cp -R $(@D)/netflix/src/platform/gibbon/*.h $(STAGING_DIR)/usr/include/nrd/nrdapp
        cp -R $(@D)/netflix/src/nrdapp/Core/*.h $(STAGING_DIR)/usr/include/nrd/nrdapp
        cp -R $(@D)/netflix/nrdlib/src/nrd/Core/*.h $(STAGING_DIR)/usr/include/nrd/nrd
        cp -R $(@D)/netflix/nrdlib/src/nrd/NBP/*.h $(STAGING_DIR)/usr/include/nrd/nrd
        cp -R $(@D)/netflix/nrdlib/src/nrd/Dpi/*.h $(STAGING_DIR)/usr/include/nrd/nrd
        cp -R $(@D)/netflix/nrdlib/src/ase/common/*.h $(STAGING_DIR)/usr/include/nrd/nrdase
        cp -R $(@D)/netflix/nrdlib/src/net/util/*.h $(STAGING_DIR)/usr/include/nrd/nrdnet
        cp -R $(@D)/netflix/nrdlib/src/net/httplib/*.h $(STAGING_DIR)/usr/include/nrd/nrdnet
        cp -R $(@D)/netflix/nrdlib/src/net/websocket/*.h $(STAGING_DIR)/usr/include/nrd/nrdnet
        cp -R $(@D)/netflix/nrdlib/src/net/resourcemanager/*.h $(STAGING_DIR)/usr/include/nrd/nrdnet
        cp -R $(@D)/netflix/nrdlib/src/net/certstatus/*.h $(STAGING_DIR)/usr/include/nrd/nrdnet
        cp -R $(@D)/netflix/src/platform/gibbon/bridge/*.h $(STAGING_DIR)/usr/include/nrd/nrdapp
        cp -R $(@D)/partner/dpi/metrological/external/* $(STAGING_DIR)/usr/include/nrd/external
        cp -R $(@D)/partner/graphics/metrological/external/* $(STAGING_DIR)/usr/include/nrd/external
        cp -R $(@D)/partner/input/metrological/external/* $(STAGING_DIR)/usr/include/nrd/external
endef

ifeq ($(BR2_PACKAGE_NRD_DYNAMICLIB),y)
NRD_INSTALL_STAGING = YES
define NRD_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/libnetflix.so $(STAGING_DIR)/usr/lib
	$(NRD_STAGING_SET_DEFINITION)
endef
else ifeq ($(BR2_PACKAGE_NRD_STATICLIB),y)
NRD_INSTALL_STAGING = YES
define NRD_INSTALL_STAGING_CMDS
	cp -R $(TOPDIR)/package/nrd/files/netflix-biglib.mri $(@D)
	cd $(@D) && $(TARGET_CROSS)ar -M < $(@D)/netflix-biglib.mri
	cp -R $(@D)/libnetflix-biglib.a $(STAGING_DIR)/usr/lib
	$(NRD_STAGING_SET_DEFINITION)
endef
endif

################################################################################
# TARGET:
################################################################################
define NRD_TARGET_SET_DEFINITION
	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	cat $(@D)/output/src/platform/gibbon/data/etc/conf/common.xml | awk -v h="etc" -v s="$(NRD_RUNTIMEDATA_LOCATION)/etc" '{sub(h,s)}1' > $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/common.xml
	cat $(@D)/output/src/platform/gibbon/data/etc/conf/gibbon.xml | awk -v h="etc" -v s="$(NRD_RUNTIMEDATA_LOCATION)/etc" '{sub(h,s)}1' > $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/gibbon.xml
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/etc/conf/graphics.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/etc/conf/oem.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/etc/conf/platform.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/certs/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/etc/certs/ui_ca.pem $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/certs/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/keys/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/etc/keys/appboot.key $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/keys/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/fonts/* $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/
	$(INSTALL) -m 444 $(@D)/netflix/src/platform/gibbon/resources/gibbon/fonts/LastResort.ttf $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/

	# minimum set of resources to have some dynamic content
	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/js/PartnerBridge.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/js/NetflixBridge.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/js/error.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/js/boot.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/js/splash.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Logo_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Background_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Shadow_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 444 $(@D)/output/src/platform/gibbon/data/resources/img/Spinner_Splash.mng $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/

	# fixes
	mkdir -p $(TARGET_DIR)/root/data/gibbon
	cd $(TARGET_DIR) && ln -s $(NRD_RUNTIMEDATA_LOCATION)/fonts/ root/data/fonts
endef

ifeq ($(BR2_PACKAGE_NRD_APPLICATION),y)
define NRD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/libJavaScriptCore.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/netflix $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/manufss $(TARGET_DIR)/usr/bin
	$(NRD_TARGET_SET_DEFINITION)
endef
else ifeq ($(BR2_PACKAGE_NRD_DYNAMICLIB),y)
define NRD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/libnetflix.so $(TARGET_DIR)/usr/lib
	$(NRD_TARGET_SET_DEFINITION)
endef
else ifeq ($(BR2_PACKAGE_NRD_STATICLIB),y)
define NRD_INSTALL_TARGET_CMDS
	$(NRD_TARGET_SET_DEFINITION)
endef
endif

$(eval $(cmake-package))
