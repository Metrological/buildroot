################################################################################
#
# autoeas
#
################################################################################

AUTOEAS_VERSION = $(INTELCE_VERSION).4
AUTOEAS_SITE = $(INTELCE_SITE)/autoeas/
AUTOEAS_SITE_METHOD = local
AUTOEAS_LICENSE = PROPRIETARY
AUTOEAS_REDISTRIBUTE = NO

AUTOEAS_DEPENDENCIES = host-autoeas

AUTOEAS_INSTALL_STAGING = YES

define HOST_AUTOEAS_BUILD_CMDS
	$(INSTALL) -m 755 $(INTELCE_SITE)/libsven/src/sven_modules.c $(@D)/src/
	cp -R $(INTELCE_SITE)/libsven/src/{eas,include}/ $(@D)/src/

	$(HOST_MAKE_ENV) $(MAKE) CC=$(HOSTCC) -C $(@D)/src/
endef

define HOST_AUTOEAS_INSTALL_CMDS
	$(INSTALL) -m 755 $(@D)/src/sven_csr $(HOST_DIR)/usr/bin/
endef

define AUTOEAS_BUILD_CMDS
	mkdir -p $(@D)/src/include/eas/ 

	( \
	cd $(@D)/src/; \
	$(HOST_DIR)/usr/bin/sven_csr VALIDATE; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_AUDIO > include/eas/gen1_audio.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_TSP > include/eas/gen1_tsp.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_VCAP > include/eas/gen1_vcap.h; \
	$(HOST_DIR)/usr/bin/sven_csr TBE_AVI > include/eas/tbe_avi.h; \
	$(HOST_DIR)/usr/bin/sven_csr TBE_AVO > include/eas/tbe_avo.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_H264 > include/eas/gen1_h264vd.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_ADI > include/eas/gen1_adi.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1PLUS_OMAR > include/eas/gen1_omar.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1PLUS_OMAR_CW > include/eas/gen1_omar_cw.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_TSDEMUX > include/eas/gen1_tsd.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_VDC > include/eas/gen1_vdc.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_MPG2VD > include/eas/gen1_mpg2vd.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_EXPBUS > include/eas/gen1_expbus.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_UEE > include/eas/gen1_uee.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_I2C > include/eas/gen1_i2c.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_UART > include/eas/gen1_uart.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_GFX > include/eas/gen1_gfx.h; \
	$(HOST_DIR)/usr/bin/sven_csr SW_VIDREND > include/eas/sw_vidrend.h; \
	$(HOST_DIR)/usr/bin/sven_csr SW_BUFMON > include/eas/sw_bufmon.h; \
	$(HOST_DIR)/usr/bin/sven_csr SW_VIDSINK > include/eas/sw_vidsink.h; \
	$(HOST_DIR)/usr/bin/sven_csr SW_REMUX > include/eas/sw_remux.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_MCU > include/eas/gen1_mcu.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_XAB_VID > include/eas/gen1_xab_vid.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_XAB_APER > include/eas/gen1_xab_aper.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN1_XAB_XPORT > include/eas/gen1_xab_xport.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN5_TSI > include/eas/gen5_tsi.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN5_DPE > include/eas/gen5_dpe.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_AUD_DSP0 > include/eas/gen3_aud_dsp0.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_AUD_DSP1 > include/eas/gen3_aud_dsp1.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_AUD_IO > include/eas/gen3_aud_io.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_GFX > include/eas/gen3_gfx.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_DFX > include/eas/gen3_dfx.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_CRU > include/eas/gen3_cru.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_DPE > include/eas/gen3_dpe.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_HDMI_TX > include/eas/gen3_hdmi_tx.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_SEC > include/eas/gen3_sec.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_TVE > include/eas/gen3_tve.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_VDC > include/eas/gen3_vdc.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_MFD > include/eas/gen3_mfd.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_TSI > include/eas/gen3_tsi.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_MSPOD > include/eas/gen3_mspod.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_TSOUT > include/eas/gen3_tsout.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_GPIO > include/eas/gen3_gpio.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN3_DEMUX > include/eas/gen3_demux.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN4_MEU > include/eas/gen4_meu.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN4_AUD_IO > include/eas/gen4_aud_io.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN4_DPE > include/eas/gen4_dpe.h; \
	$(HOST_DIR)/usr/bin/sven_csr GEN4_HDVCAP > include/eas/gen4_hdvcap.h; \
	$(HOST_DIR)/usr/bin/sven_csr CE4100_CRU > include/eas/gen41_cru.h; \
	$(HOST_DIR)/usr/bin/sven_csr CE4200_CRU > include/eas/gen42_cru.h; \
	$(HOST_DIR)/usr/bin/sven_csr SW_APP > include/eas/sw_app_events.h; \
	)
endef

define AUTOEAS_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/intelce/eas/
	$(INSTALL) -m 755 $(@D)/src/include/eas/*.h $(STAGING_DIR)/usr/include/intelce/eas/
endef

define AUTOEAS_INSTALL_TARGET_CMDS
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
