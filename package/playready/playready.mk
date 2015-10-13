################################################################################
#
# NRD
#
################################################################################

PLAYREADY_VERSION = master
PLAYREADY_SITE = git@github.com:Metrological/playready.git
PLAYREADY_SITE_METHOD = git
PLAYREADY_LICENSE = PROPRIETARY
PLAYREADY_DEPENDENCIES = 
PLAYREADY_INSTALL_STAGING = YES
PLAYREADY_INSTALL_TARGET = NO
PLAYREADY_CMAKE_FLAGS  = -DCMAKE_BUILD_TYPE=Release
PLAYREADY_CMAKE_FLAGS += -DCMAKE_C_FLAGS_RELEASE="-std=c99 -D_GNU_SOURCE"

################################################################################
# CONFIGURE:
################################################################################
PLAYREADY_CONFIGURE_CMDS = 									\
	mkdir $(@D)/output;									\
	cd $(@D)/output; 									\
	$(TARGET_MAKE_ENV) 									\
	BUILDROOT_TOOL_PREFIX="$(GNU_TARGET_NAME)-" 						\
	cmake 											\
		-DCMAKE_INSTALL_PREFIX=$(@D)/output						\
		-DCMAKE_SYSROOT=$(STAGING_DIR) 							\
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake 	\
		$(PLAYREADY_CMAKE_FLAGS) 							\
		$(@D)/src

################################################################################
# BUILD:
################################################################################
PLAYREADY_BUILD_CMDS = cd $(@D)/output ; $(TARGET_MAKE_ENV) make 

################################################################################
# STAGING:
################################################################################
define PLAYREADY_INSTALL_STAGING_CMDS
	make -C $(@D)/output install
        #$(INSTALL) -m 755 $(@D)/output/libplayready-2.5-ss-tee.a $(STAGING_DIR)/usr/lib
endef

################################################################################
# TARGET:
################################################################################

$(eval $(cmake-package))
