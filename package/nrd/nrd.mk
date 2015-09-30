################################################################################
#
# NRD
#
################################################################################

NRD_VERSION = 179d5bf82a976188dec2c721093bf10a6c6816b9
NRD_SITE = git@github.com:Metrological/nrd.git
NRD_SITE_METHOD = git
NRD_LICENSE = PROPRIETARY
NRD_DEPENDENCIES = freetype icu jpeg libpng libmng webp expat openssl c-ares libcurl harfbuzz

NRD_INSTALL_STAGING = YES

NRD_RUNTIMEDATA_LOCATION = /var/lib/netflix

ifeq ($(BR2_PACKAGE_NRD_BROWSER_PLUGIN_MODE),y)
NRD_DEPENDENCIES += nrdwrapper
NRD_EXTRA_CXXFLAGS += -D_BROWSER_PLUGIN_
endif

ifeq ($(BR2_PACKAGE_DDPSTUB),y)
NRD_DEPENDENCIES += stubs
endif

# also add verbosity to a debug build
ifeq ($(BR2_ENABLE_DEBUG),y)
NRD_EXTRA_CFLAGS   += -v
NRD_EXTRA_CXXFLAGS += -v
NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DEBUG=1
NRD_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS_DEBUG="$(TARGET_CFLAGS) $(NRD_EXTRA_CFLAGS)" -DCMAKE_CXX_FLAGS_DEBUG="$(TARGET_CXXFLAGS) $(NRD_EXTRA_CXXFLAGS)"
else
NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DEBUG=0
NRD_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS_RELEASE="$(TARGET_CFLAGS) $(NRD_EXTRA_CFLAGS)" -DCMAKE_CXX_FLAGS_RELEASE="$(TARGET_CXXFLAGS) $(NRD_EXTRA_CXXFLAGS)"
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=rpi
else
ifeq ($(BR2_PACKAGE_INTELCE),y)
NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=intelce
NRD_EXTRA_CXXFLAGS += -DINTELCE
else
NRD_CMAKE_FLAGS += -DGIBBON_PLATFORM=posix
endif
endif

NRD_EXTRA_CFLAGS   += -I$(STAGING_DIR)/usr/include/harfbuzz/ -I$(STAGING_DIR)/usr/include/freetype2/
NRD_EXTRA_CXXFLAGS += -I$(STAGING_DIR)/usr/include/harfbuzz/ -I$(STAGING_DIR)/usr/include/freetype2/

# harfbuzz should be build with graphite support
ifeq ($(findstring y,$(BR2_PACKAGE_NRD)), y)
ifneq ($(findstring y,$(BR2_PACKAGE_GRAPHITE2)),y)
$(error graphite2 not selected. Harfbuzz should be build with graphite2 support.)
endif
endif

NRD_CMAKE_FLAGS += -DGIBBON_GRAPHICS=$(BR2_PACKAGE_NRD_GRAPHICS)

ifeq ($(findstring y,$(BR2_PACKAGE_NRD_GRAPHICS_GLES2)$(BR2_PACKAGE_NRD_GRAPHICS_METROLOGICAL)),y)
NRD_DEPENDENCIES   += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_ES))
NRD_EXTRA_CFLAGS   += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags glesv2)
NRD_EXTRA_CXXFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags  glesv2)
NRD_EXTRA_LDFLAGS  += $(shell $(PKG_CONFIG_HOST_BINARY) --libs glesv2)
endif

ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_GLES2_EGL),y)
NRD_DEPENDENCIES   += $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))
NRD_EXTRA_CFLAGS   += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)
NRD_EXTRA_CXXFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --cflags  egl)
NRD_EXTRA_LDFLAGS  += $(shell $(PKG_CONFIG_HOST_BINARY) --libs egl)
endif

ifeq ($(BR2_PACKAGE_NRD_GRAPHICS_DIRECTFB),y)
NRD_DEPENDENCIES += alsa-lib portaudio webp ffmpeg tremor directfb
endif

ifeq ($(BR2_PACKAGE_NRD_NICE_THREADS),y)
NRD_CMAKE_FLAGS += -DGIBBON_NICE_THREADS=1
endif

#
NRD_CMAKE_FLAGS += -DDPI_IMPLEMENTATION=$(BR2_PACKAGE_NRD_PLAYER)

NRD_CMAKE_FLAGS += -DDPI_REFERENCE_DRM=$(BR2_PACKAGE_NRD_DRM)

NRD_CMAKE_FLAGS += -DGIBBON_INPUT=$(BR2_PACKAGE_NRD_INPUT)

# jsc build mode
NRD_CMAKE_FLAGS += -DGIBBON_SCRIPT_JSC_DYNAMIC=$(BR2_PACKAGE_NRD_JSC_LIBRARY_TYPE)

# nrd main build mode
NRD_CMAKE_FLAGS += -DGIBBON_MODE=$(BR2_PACKAGE_NRD_MODE)

ifeq ($(BR2_PACKAGE_NRD_APPLICATION_EXECUTABLE),y)
#NRD_POST_INSTALL_STAGING_HOOKS += NRD_CREATE_AND_COPY_EXECUTABLE_STAGING_HOOK 
NRD_POST_INSTALL_TARGET_HOOKS += NRD_CREATE_AND_COPY_EXECUTABLE_TARGET_HOOK 
endif

ifeq ($(BR2_PACKAGE_NRD_JSC_DYNAMIC),y)
NRD_POST_INSTALL_STAGING_HOOKS += NRD_CREATE_AND_COPY_DYNAMIC_LIB_STAGING_HOOK 
NRD_POST_INSTALL_TARGET_HOOKS += NRD_CREATE_AND_COPY_DYNAMIC_LIB_TARGET_HOOK 
endif

ifeq ($(BR2_PACKAGE_NRD_JSC_STATIC),y)
NRD_POST_INSTALL_STAGING_HOOKS += NRD_CREATE_AND_COPY_STATIC_LIB_STAGING_HOOK 
#NRD_POST_INSTALL_TARGET_HOOKS += NRD_CREATE_AND_COPY_STATIC_LIB_TARGET_HOOK 
endif

NRD_HEADERS     = $(shell find $(@D)/output -name *.h | xargs dirname | sort -u)
NRD_REVMATCH    = $(shell echo $(@D)/output | rev)
NRD_REVSUBST    = $(shell echo $(STAGING_DIR)/usr/include/netflix/ | rev)
NRD_STATIC_LIBS	= $(shell find $(@D)/output -name *.a)
NRD_DYN_LIBS	= $(shell find $(@D)/output -name *.so*)

define NRD_INSTALL_STAGING_CMDS
	echo NRD_HEADERS $(NRD_HEADERS)
#	$(foreach nrd_path, $(NRD_HEADERS), \
		echo $(nrd_path)/\*\.h $(nrd_path) | rev | awk -v h="$(NRD_REVMATCH)" -v s="$(NRD_REVSUBST)" 'sub(h,s) {printf("%s\n", $$0);}' | rev | awk '{printf("mkdir -p %s && cp -r %s %s\n", $$2, $$1, $$2);}'
	)
endef

define NRD_CREATE_AND_COPY_EXECUTABLE_STAGING_HOOK
echo NRD_CREATE_AND_COPY_EXECUTABLE_STAGING_HOOK
endef

define NRD_CREATE_AND_COPY_DYNAMIC_LIB_STAGING_HOOK
echo NRD_CREATE_AND_COPY_DYNAMIC_LIB_STAGING_HOOK
echo $(NRD_DYN_LIBS)
#	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/libJavaScriptCore.so $(STAGING_DIR)/usr/lib/
endef

define NRD_CREATE_AND_COPY_STATIC_LIB_STAGING_HOOK
echo NRD_CREATE_AND_COPY_STATIC_LIB_STAGING_HOOK
echo $(NRD_STATIC_LIBS)

	echo "CREATE libnetflix-biglib.a" >> $(@D)/netflix-biglib.mri
	$(foreach nrd_lib, $(NRD_STATIC_LIBS), \
		echo "ADDLIB $(nrd_lib)" >> $(@D)/netflix-biglib.mri
	)
	echo "SAVE" >> $(@D)/netflix-biglib.mri
	echo "END" >> $(@D)/netflix-biglib.mri

	cd $(@D) && $(TARGET_CROSS)ar -M < $(@D)/netflix-biglib.mri
	$(INSTALL) -m 755 $(@D)/libnetflix-biglib.a $(STAGING_DIR)/usr/lib
endef

NRD_RUNTIMEDATA_LOCATION=/var/lib/netflix

define NRD_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	# fix paths
#	$(INSTALL) $(@D)/output/src/platform/gibbon/data/etc/conf/common.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	cat $(@D)/output/src/platform/gibbon/data/etc/conf/common | awk -v h="etc" -v s="$(NRD_RUNTIMEDATA_LOCATION)/etc" '{sub(h,s)}1' > $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/gibbon.xml
	# fix paths
#	$(INSTALL) $(@D)/output/src/platform/gibbon/data/etc/conf/gibbon.xml
	cat $(@D)/output/src/platform/gibbon/data/etc/conf/gibbon.xml | awk -v h="etc" -v s="$(NRD_RUNTIMEDATA_LOCATION)/etc" '{sub(h,s)}1' > $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/gibbon.xml
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/conf/graphics.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
#	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/conf/input.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/conf/oem.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/conf/platform.xml $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/conf/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/certs/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/certs/ui_ca.pem $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/certs/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/keys/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/etc/keys/appboot.key $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/etc/keys/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/fonts/* $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/resources/gibbon/fonts/LastResort.ttf $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/fonts/

	# minimum set of resources to have some dynamic content
	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/js/PartnerBridge.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/js/NetflixBridge.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/js/error.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/js/boot.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/js/splash.js $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/js/

	mkdir -p $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Logo_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Background_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/img/Netflix_Shadow_Splash.png $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/
	$(INSTALL) -m 755 $(@D)/output/src/platform/gibbon/data/resources/img/Spinner_Splash.mng $(TARGET_DIR)$(NRD_RUNTIMEDATA_LOCATION)/resources/img/

	# fixes
	mkdir -p $(TARGET_DIR)/root/data/gibbon
	cd $(TARGET_DIR) && ln -s $(NRD_RUNTIMEDATA_LOCATION)/fonts/ root/data/fonts
endef

define NRD_CREATE_AND_COPY_EXECUTABLE_TARGET_HOOK
	$(INSTALL) -m 555 $(@D)/output/src/platform/gibbon/netflix $(TARGET_DIR)/usr/bin/
endef

define NRD_CREATE_AND_COPY_DYNAMIC_LIB_TARGET_HOOK
echo NRD_CREATE_AND_COPY_DYNAMIC_LIB_TARGET_HOOK
endef

define NRD_CREATE_AND_COPY_STATIC_LIB_TARGET_HOOK
echo NRD_CREATE_AND_COPY_STATIC_LIB_TARGET_HOOK
endef

#TODO: define uninstall

NRD_CONFIGURE_CMDS = \
	mkdir $(@D)/output; \
	cd $(@D)/output; \
	$(TARGET_MAKE_ENV) \
	BUILDROOT_TOOL_PREFIX="$(GNU_TARGET_NAME)-" \
	OBJCOPY="$(TARGET_CROSS)objcopy" \
	STRIP="$(TARGET_CROSS)strip" \
	cmake -DNRDP_TOOLS:STRING=manufSSgenerator \
	-DCMAKE_SYSROOT=$(STAGING_DIR) \
	-DCMAKE_CXX_COMPILER="$(TARGET_CXX_NOCCACHE)" \
	-DCMAKE_C_COMPILER="$(TARGET_CC_NOCCACHE)" \
	-DCMAKE_OBJCOPY="$(TARGET_CROSS)objcopy" \
	-DCMAKE_STRIP="$(TARGET_CROSS)strip" \
	$(@D)/netflix \
	$(NRD_CMAKE_FLAGS)

define NRD_BUILD_CMDS
	( \
	cd $(@D)/output; \
	$(TARGET_MAKE_ENV) make \
	)
	#enable reconfigure to execute the 'same' custom cmake commands as a normal build
	if [ -f $(@D)/output/CMakeCache.txt ]; then \
		rm $(@D)/output/CMakeCache.txt; \
	fi
endef

$(eval $(cmake-package))
