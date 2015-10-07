################################################################################
#
# gst1-plugins-bcm
#
################################################################################
GST1_PLUGINS_BCM_VERSION = 726bbcf894a59aefdeee0a9179eb4927d7907bb3
GST1_PLUGINS_BCM_SITE = git@github.com:Metrological/gstreamer-plugins-soc.git
GST1_PLUGINS_BCM_SITE_METHOD = git
GST1_PLUGINS_BCM_LICENSE = PROPRIETARY
GST1_PLUGINS_BCM_INSTALL_STAGING = YES
GST1_PLUGINS_BCM_DEPENDENCIES = gstreamer1 gst1-plugins-base mpg123 bcm-refsw libcurl

GST1_PLUGINS_BCM_AUTORECONF = YES

# WARNING: dirty bcm-refsw dependencies because of the creative bcm build system.
GST1_PLUGINS_BCM_NEXUS_TOP = ${BCM_REFSW_DIR}
GST1_PLUGINS_BCM_MAKE_OPT += \
  "CFLAGS = ${CFLAGS} \
            -std=c99 \
            -I${GST1_PLUGINS_BCM_NEXUS_TOP}/nexus/modules/audio/include \
            -I${GST1_PLUGINS_BCM_NEXUS_TOP}/obj.${BR2_PACKAGE_BCM_REFSW_PLATFORM}/nexus/bin/include \
            -I${GST1_PLUGINS_BCM_NEXUS_TOP}/BSEAV/api/include \
            -I${GST1_PLUGINS_BCM_NEXUS_TOP}/BSEAV/lib/media \
            -I${GST1_PLUGINS_BCM_NEXUS_TOP}/BSEAV/lib/bfile"

# Set default options found in rdk_build.sh
GST1_PLUGINS_BCM_CONF_OPT = \
	--enable-gstreamer1  \
	--enable-shared \
	--with-pic \
	--disable-static \
	--enable-systemclock

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_AUDFILTER),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-audfilter
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-audfilter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_AUDIODECODE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-audiodecode
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-audiodecode
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_AUDIOSINK),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-audiosink
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-audiosink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_AVI),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-avi
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_FLV),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-flv
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-flv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_GFXSINK),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-gfxsink
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-gfxsink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_AVI),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-avi
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_HTTPSRC),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-httpsrc
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-httpsrc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_IVFPARSE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-ivfparse
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-ivfparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_MATROSKA),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-matroska
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_MP3SWDECODE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-mp3swdecode
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-mp3swdecode
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_MP4DEMUX),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-mp4demux
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-mp4demux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_PCMSINK),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-pcmsink
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-pcmsink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_PESDEMUX),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-pesdemux
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-pesdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_PLAYBACK),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-playback
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-playback
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_QTDEMUX),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-qtdemux
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-qtdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_TRANSCODE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-transcode
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-transcode
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_TSDEMUX),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-tsdemux
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-tsdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_TSPARSE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-tsparse
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-tsparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_VIDEODECODE),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-videodecode
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-videodecode
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_VIDEOSINK),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-videosink
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-videosink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_VIDFILTER),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-vidfilter
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-vidfilter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BCM_PLUGIN_PLAYERSINKBIN),y)
GST1_PLUGINS_BCM_CONF_OPT += --enable-playersinkbin
else
GST1_PLUGINS_BCM_CONF_OPT += --disable-playersinkbin
endif


$(eval $(autotools-package))
