################################################################################
#
# libgtk3.0
#
################################################################################

LIBGTK3_VERSION_MAJOR = 3.11
LIBGTK3_VERSION_MINOR = 5
LIBGTK3_VERSION = $(LIBGTK3_VERSION_MAJOR).$(LIBGTK3_VERSION_MINOR)

LIBGTK3_SOURCE = gtk+-$(LIBGTK3_VERSION).tar.xz
LIBGTK3_SITE = http://ftp.gnome.org/pub/gnome/sources/gtk+/$(LIBGTK3_VERSION_MAJOR)
LIBGTK3_INSTALL_STAGING = YES
LIBGTK3_INSTALL_TARGET = YES

LIBGTK3_AUTORECONF = YES

LIBGTK3_CONF_ENV = \
	ac_cv_func_posix_getpwuid_r=yes \
	glib_cv_stack_grows=no \
	glib_cv_uscore=no \
	ac_cv_func_strtod=yes \
	ac_fsusage_space=yes \
	fu_cv_sys_stat_statfs2_bsize=yes \
	ac_cv_func_closedir_void=no \
	ac_cv_func_getloadavg=no \
	ac_cv_lib_util_getloadavg=no \
	ac_cv_lib_getloadavg_getloadavg=no \
	ac_cv_func_getgroups=yes \
	ac_cv_func_getgroups_works=yes \
	ac_cv_func_chown_works=yes \
	ac_cv_have_decl_euidaccess=no \
	ac_cv_func_euidaccess=no \
	ac_cv_have_decl_strnlen=yes \
	ac_cv_func_strnlen_working=yes \
	ac_cv_func_lstat_dereferences_slashed_symlink=yes \
	ac_cv_func_lstat_empty_string_bug=no \
	ac_cv_func_stat_empty_string_bug=no \
	vb_cv_func_rename_trailing_slash_bug=no \
	ac_cv_have_decl_nanosleep=yes \
	jm_cv_func_nanosleep_works=yes \
	gl_cv_func_working_utimes=yes \
	ac_cv_func_utime_null=yes \
	ac_cv_have_decl_strerror_r=yes \
	ac_cv_func_strerror_r_char_p=no \
	jm_cv_func_svid_putenv=yes \
	ac_cv_func_getcwd_null=yes \
	ac_cv_func_getdelim=yes \
	ac_cv_func_mkstemp=yes \
	utils_cv_func_mkstemp_limitations=no \
	utils_cv_func_mkdir_trailing_slash_bug=no \
	jm_cv_func_gettimeofday_clobber=no \
	gl_cv_func_working_readdir=yes \
	jm_ac_cv_func_link_follows_symlink=no \
	utils_cv_localtime_cache=no \
	ac_cv_struct_st_mtim_nsec=no \
	gl_cv_func_tzset_clobber=no \
	gl_cv_func_getcwd_null=yes \
	gl_cv_func_getcwd_path_max=yes \
	ac_cv_func_fnmatch_gnu=yes \
	am_getline_needs_run_time_check=no \
	am_cv_func_working_getline=yes \
	gl_cv_func_mkdir_trailing_slash_bug=no \
	gl_cv_func_mkstemp_limitations=no \
	ac_cv_func_working_mktime=yes \
	jm_cv_func_working_re_compile_pattern=yes \
	ac_use_included_regex=no gl_cv_c_restrict=no \
	ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_DIR)/usr/bin/gtk-update-icon-cache \
	ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_DIR)/usr/bin/gdk-pixbuf-csource \
	ac_cv_prog_F77=no \
	ac_cv_path_CUPS_CONFIG=no \
	GLIB_CFLAGS_FOR_BUILD="-I$(HOST_DIR)/usr/include/glib-2.0 -I$(HOST_DIR)/usr/lib/glib-2.0/include" \
	GLIB_LIBS_FOR_BUILD="-L$(HOST_DIR)/usr/lib -lglib-2.0"

LIBGTK3_CONF_OPT = \
	--disable-glibtest \
	--enable-gtk2-dependency=yes \
	--enable-explicit-deps=no \
	--disable-introspection \
	--disable-debug

LIBGTK3_DEPENDENCIES = host-pkgconf libglib2 host-libgtk3 cairo pango atk gdk-pixbuf

ifeq ($(BR2_PACKAGE_WAYLAND),y)
	LIBGTK3_CONF_OPT += \
		--with-gdktarget=wayland \
		--enable-wayland-backend \
 		--disable-x11-backend
	LIBGTK3_DEPENDENCIES += wayland weston
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	LIBGTK3_CONF_OPT += \
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--with-gdktarget=x11 \
		--disable-wayland-backend \
 		--enable-x11-backend
	LIBGTK3_DEPENDENCIES += xlib_libXcomposite fontconfig xlib_libX11 \
		xlib_libXext xlib_libXrender

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
	LIBGTK3_CONF_OPT += --enable-xinerama
	LIBGTK3_DEPENDENCIES += xlib_libXinerama
else
	LIBGTK3_CONF_OPT += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
	LIBGTK3_CONF_OPT += --with-xinput=yes
	LIBGTK3_DEPENDENCIES += xlib_libXi
else
	LIBGTK3_CONF_OPT += --with-xinput=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
	LIBGTK3_DEPENDENCIES += xlib_libXrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
	LIBGTK3_DEPENDENCIES += xlib_libXcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
	LIBGTK3_DEPENDENCIES += xlib_libXfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
	LIBGTK3_DEPENDENCIES += xlib_libXcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
	LIBGTK3_DEPENDENCIES += xlib_libXdamage
endif

else
	LIBGTK3_CONF_OPT += --without-x
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBGTK3_DEPENDENCIES += libpng
else
LIBGTK3_CONF_OPT += --without-libpng
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBGTK3_DEPENDENCIES += jpeg
else
LIBGTK3_CONF_OPT += --without-libjpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBGTK3_DEPENDENCIES += tiff
else
LIBGTK3_CONF_OPT += --without-libtiff
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
LIBGTK3_DEPENDENCIES += cups
else
LIBGTK3_CONF_OPT += --disable-cups
endif

define LIBGTK3_COPY_EXTRACT_STRINGS
	cp $(HOST_DIR)/usr/bin/gtk-extract-strings $(@D)/gtk/extract-strings
endef

LIBGTK3_POST_CONFIGURE_HOOKS += LIBGTK3_COPY_EXTRACT_STRINGS

# We do not build a full version of libgtk3 for the host, because that
# requires compiling Cairo, Pango, ATK and X.org for the
# host. Therefore, we patch it to remove dependencies, and we hack the
# build to only build gdk-pixbuf-from-source and
# gtk-update-icon-cache, which are the host tools needed to build Gtk
# for the target.

HOST_LIBGTK3_DEPENDENCIES = host-libglib2 host-libpng host-gdk-pixbuf
HOST_LIBGTK3_AUTORECONF = YES
HOST_LIBGTK3_CONF_OPT = \
	--disable-static \
	--disable-glibtest \
	--without-libtiff \
	--without-libjpeg \
	--disable-introspection \
	--with-gdktarget=none \
	--enable-none-backend \
	--disable-x11-backend \
	--disable-cups \
	--disable-debug \
	--without-x

define HOST_LIBGTK3_PATCH_REDUCE_DEPENDENCIES_HOOK
	support/scripts/apply-patches.sh $(@D) $(PKGDIR) host/*.patch
endef

HOST_LIBGTK3_POST_PATCH_HOOKS += HOST_LIBGTK3_PATCH_REDUCE_DEPENDENCIES_HOOK

define HOST_LIBGTK3_BUILD_CMDS
	$(HOST_MAKE_ENV) make -C $(@D)/gtk gtk-update-icon-cache
	$(HOST_MAKE_ENV) make -C $(@D)/gtk extract-strings
endef

define HOST_LIBGTK3_INSTALL_CMDS
	cp $(@D)/gtk/gtk-update-icon-cache $(HOST_DIR)/usr/bin
	cp $(@D)/gtk/extract-strings $(HOST_DIR)/usr/bin/gtk-extract-strings
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
