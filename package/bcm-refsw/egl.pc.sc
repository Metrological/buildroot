prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: egl
Description: Broadcom implementation of EGL
Version: 1
Libs: -L${libdir} -lrt -lnexus -lnxpl -lv3ddriver -lbipc
Cflags: -I${includedir} -I${includedir}/refsw -DNEXUS_SURFACE_COMPOSITION
