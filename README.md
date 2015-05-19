Buildroot
=========

This buildroot fork will produce a very light-weight and trimmed down toolchain, rootfs and kernel for the multiple targets, including the Raspberry Pi 2. Mainly focused on enabling all HTML5 features WebKit in multiple ports.

Dependencies
------------

You will need to install some packages on your host machine, for e.g. on Ubuntu 12.04:

	sudo apt-get install build-essential git subversion cvs unzip whois ncurses-dev bc mercurial

For host machines with kernel 3.8 or higher (e.g. Ubuntu 13.04) you can use the experimental F2FS filesystem:

	sudo apt-get install build-essential git subversion cvs unzip whois ncurses-dev bc mercurial f2fs-tools

When creating a VM please allocate a minimal of 30GB disk space.

Building
--------

	git clone git://github.com/metrological/buildroot.git

or

	git clone https://github.com/metrological/buildroot.git

followed by

	cd buildroot
Select a browser distribution for **Qt5WebKit** (qtbrowser)

	make rpi2_qt5webkit_defconfig

or for **WebKit Wayland** (wpe)

	make rpi2_wpe_defconfig

If you want to add additional packages

	make menuconfig

Start the **build** (NOTICE: Don't use the **-j** switch, it's set to auto-detect)

	make

Deploying on a Raspberry PI 2
-----------------------------

You will need to create two partitions on your sdcard and copy files to the appropriate partitons.

The first (boot) is a small *W95 FAT32 (LBA)* partition of about 100 MB in size.

**Notice** you will need to replace *sdx* in the following commands with the actual device node for your sdcard.

	# run the following as root
	mkfs.vfat -F 32 -n boot /dev/sdx1
	mkdir -p /media/boot
	mount /dev/sdx1 /media/boot

You will need to copy all the files in *output/images/rpi-firmware* and the kernel from *output/images/zImage* to your *boot* partition.

	# run the following as root
	cp output/images/rpi-firmware/* /media/boot
	cp output/images/zImage /media/boot
	sync
	umount /media/boot

The second (rootfs) can be as big in size as you prefer, but with a 200 MB minimum. It should be formatted as *ext4*.

	# run the following as root
	mkfs.ext4 -L rootfs /dev/sdx2
	mkdir -p /media/rootfs
	mount /dev/sdx2 /media/rootfs

You will need to extract *output/images/rootfs.tar* to the partition, as **root**.

	# run the following as root
	tar -xvpsf output/images/rootfs.tar -C /media/rootfs # replace with your mount directory
	sync
	umount /media/rootfs

Login
-----

You can login to the system using *ssh*. The default password is set to **root**. It is configurable with make menuconfig.

	ssh root@192.168.1.100 # replace with your ip address

Forum for the Raspberry PI
--------------------------

Please goto http://www.raspberrypi.org/phpBB3/viewtopic.php?f=38&t=43087

Contribute
----------

**Would you like to join our team?** Drop your details at recruitment@metrological.com or fork this repository and send us your *Pull Requests*.

Proprietary Packages
--------------------

For the proprietary packages, e.g. Gstreamer Codec Pack and PlayReady support, please contact us at sales@metrological.com
