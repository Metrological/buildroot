################################################################################
#
# graphite2
#
################################################################################

GRAPHITE2_VERSION = 1.2.4
GRAPHITE2_SOURCE  = graphite2-1.2.4.tgz
GRAPHITE2_SITE    = http://projects.palaso.org/attachments/download/407/
GRAPHITE2_LICENSE = LGPLv2.1

GRAPHITE2_INSTALL_STAGING = YES

ifeq ($(BR2_ENABLE_DEBUG),y)
GRAPHITE_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Debug 
GRAPHITE_CMAKE_FLAGS += -DCMAKE_C_FLAGS_DEBUG="$(TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS_DEBUG="$(TARGET_CXXFLAGS)" 
else
GRAPHITE_CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Release 
GRAPHITE_CMAKE_FLAGS += -DCMAKE_C_FLAGS_RELEASE="$(TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS_RELEASE="$(TARGET_CXXFLAGS)" 
endif

define GRAPHITE2_CONFIGURE_CMDS
	cd $(@D); \
	$(TARGET_MAKE_ENV) \
	BUILDROOT_TOOL_PREFIX="$(GNU_TARGET_NAME)-" \
	cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_SYSROOT=$(STAGING_DIR) \
	-DCMAKE_CXX_COMPILER="$(TARGET_CXX_NOCCACHE)" \
	-DCMAKE_C_COMPILER="$(TARGET_CC_NOCCACHE)" \
	$(@D) \
	$(GRAPHITE_CMAKE_FLAGS) 
endef

GRAPHITE2_POST_INSTALL_TARGET_HOOKS += GRAPHITE2_TARGET_CLEANUP

#define GRAPHITE2_BUILD_CMDS
#endef

define GRAPHITE2_TARGET_CLEANUP
rm $(TARGET_DIR)/usr/lib/pkgconfig/graphite2.pc
rm $(TARGET_DIR)/usr/lib/libgraphite2.la
rm -rf $(TARGET_DIR)/usr/include/graphite2
rm -rf $(TARGET_DIR)/usr/share/graphite2
endef

$(eval $(cmake-package))
