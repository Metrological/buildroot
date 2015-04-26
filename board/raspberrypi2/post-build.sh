#!/bin/bash

rm -f $TARGET_DIR/usr/bin/{icuinfo,derb,genbrk,gencfu,gencnval,gendict,genrb,makeconv,pkgdata,uconv}
rm -f $TARGET_DIR/usr/bin/fc-{cache,cat,list,match,pattern,query,scan,validate}
rm -f $TARGET_DIR/usr/bin/udevadm
rm -f $TARGET_DIR/usr/bin/xml{lint,catalog}
rm -f $TARGET_DIR/usr/bin/xsltproc
rm -f $TARGET_DIR/usr/bin/glib-compile-{schemas,resources}
rm -f $TARGET_DIR/usr/bin/g{dbus,dbus-codegen,io-querymodules,settings,resource,application}
rm -f $TARGET_DIR/usr/bin/pcre{test,grep}
rm -f $TARGET_DIR/usr/bin/faad
rm -f $TARGET_DIR/usr/bin/sqlite3
rm -f $TARGET_DIR/usr/bin/{sexp,pkcs1}-conv
rm -f $TARGET_DIR/usr/bin/nettle-{lfib-stream,hash}
rm -f $TARGET_DIR/usr/bin/mtdev-test
rm -f $TARGET_DIR/usr/sbin/icupkg
rm -f $TARGET_DIR/usr/sbin/gen{sprep,norm2,cmn,ccode}
rm -rf $TARGET_DIR/usr/share/{glib-2.0,fontconfig,xml,icu}
rm -rf $TARGET_DIR/usr/lib/*.sh
rm -rf $TARGET_DIR/usr/lib/*.py
rm -rf $TARGET_DIR/usr/lib/libffi-*
rm -rf $TARGET_DIR/usr/lib/libxslt-plugins
rm -rf $TARGET_DIR/usr/lib/icu
