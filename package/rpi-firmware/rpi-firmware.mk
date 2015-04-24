################################################################################
#
# rpi-firmware
#
################################################################################

RPI_FIRMWARE_VERSION = 46433ccc968d4f65568a1ad8679a05a46b7db51f
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3c
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_WIFI),y)
define RPI_FIRMWARE_INSTALL_TARGET_WIFI
	grep -q 'wlan0' $(TARGET_DIR)/etc/network/interfaces || \
		echo -e '\nauto wlan0\niface wlan0 inet dhcp\nwpa-roam /etc/wpa_supplicant.conf\npre-up killall wpa_supplicant; wpa_supplicant -c /etc/wpa_supplicant.conf -i wlan0 -B -P /var/run/wpa_supplican' >> $(TARGET_DIR)/etc/network/interfaces
endef
endif

ifneq ($(BR2_TARGET_GENERIC_GETTY_PORT),)
define RPI_FIRMWARE_UPDATE_TTY
	sed -i s/tty1/$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT))/ \
		$(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef
endif

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
define RPI_FIRMWARE_USE_RAMDISK
	mkdir -p $(TARGET_DIR)/root
	grep -q '^/dev/mmcblk0p2' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk0p2 /root ext4 defaults 0 0' >> $(TARGET_DIR)/etc/fstab
endef
endif

define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
	$(INSTALL) -D -m 0644 package/rpi-firmware/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
	$(RPI_FIRMWARE_UPDATE_TTY)
	grep -q 'eth0' $(TARGET_DIR)/etc/network/interfaces || \
		echo -e '\nauto eth0\niface eth0 inet dhcp\npre-up sleep 2' >> $(TARGET_DIR)/etc/network/interfaces
	$(RPI_FIRMWARE_INSTALL_TARGET_WIFI)
	mkdir -p $(TARGET_DIR)/boot
	grep -q '^/dev/mmcblk0p1' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> $(TARGET_DIR)/etc/fstab
	$(RPI_FIRMWARE_USE_RAMDISK)
endef

$(eval $(generic-package))
