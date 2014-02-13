#!/bin/sh

real_path()
{
    __SOURCE__=$1
    while [ -h "${__SOURCE__}" ]; do
        __DIR__="$( cd -P "$( dirname "${__SOURCE__}" )" && pwd )"
        __SOURCE__="$(readlink "${__SOURCE__}")"
        [[ ${__SOURCE__} != /* ]] && __SOURCE__="${__DIR__}/${__SOURCE__}"
    done
    eval "cd -P "$( dirname "${__SOURCE__}" )" && pwd"
}

crosscompile_name()
{
    # ARCHITECTURE=arm-buildroot-linux-          gnu eabi
    # ARCHITECTURE=arm-buildroot-linux-   uclibc gnu eabi
    # ARCHITECTURE=arm-buildroot-linux-   uclibc gnu eabihf-
    # ARCHITECTURE=mipsel-buildroot-linux-uclibc

    if [ "x${BR2_TOOLCHAIN_BUILDROOT}" = "xy" ]
    then
        __TOOLCHAIN__="buildroot"
    elif [ "x${BR2_TOOLCHAIN_EXTERNAL} = "xy" ]
    then
        __TOOLCHAIN__="external"
    elif [ "x${BR2_TOOLCHAIN_CTNG} -eq "xy" ]
    then
        __TOOLCHAIN__="ctng"
    else
        __TOOLCHAIN__="unknown"
    fi

    if [ "x${BR2_ARM_EABI}" = "xy" ]
    then
        __ABI__="eabi"
    elif [ "x${BR2_ARM_EABIHF}" = "xy" ]
    then
        __ABI__="eabihf"
    else
        __ABI__=""
    fi

    if [ "x${BR2_arm}" = "xy" ]
    then
        __COMPILER__="gnu"
    else
        __COMPILER__=""
    fi

    echo "${BR2_ARCH}-${__TOOLCHAIN__}-linux-${BR2_TOOLCHAIN_BUILDROOT_LIBC}${__COMPILER__}${__ABI__}"
}

compile_flags()
{
    __ARCHFLAGS__=""

    if [ -n "${BR2_GCC_TARGET_ARCH}" ]
    then
        __ARCHFLAGS__="-march=${BR2_GCC_TARGET_ARCH}"
    fi
    if [ -n "${BR2_GCC_TARGET_CPU}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -mtune=${BR2_GCC_TARGET_CPU}"
    fi
    if [ -n "${BR2_GCC_TARGET_FPU}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -mfpu=${BR2_GCC_TARGET_FPU}"
    fi
    if [ -n "${BR2_GCC_TARGET_FLOAT_ABI}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -mfloat-abi=${BR2_GCC_TARGET_FLOAT_ABI}"
        if [ "x${BR2_GCC_TARGET_FLOAT_ABI}" = "xhard" ]
        then
            __ARCHFLAGS__=${__ARCHFLAGS__}" -mhard-float"
        fi
    fi
    if [ -n "${BR2_TARGET_OPTIMIZATION}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" ${BR2_TARGET_OPTIMIZATION}"
    fi

    if [ -n "${BR2_OPTIMIZE_0}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -O0"
    elif [ -n "${BR2_OPTIMIZE_1}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -O1"
    elif [ -n "${BR2_OPTIMIZE_2}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -O2"
    elif [ -n "${BR2_OPTIMIZE_3}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -O3"
    elif [ -n "${BR2_OPTIMIZE_S}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -Os"
    fi

    if [ -n "${BR2_TOOLCHAIN_BUILDROOT_LARGEFILE}" ]
    then
        __ARCHFLAGS__=${__ARCHFLAGS__}" -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
    fi

    if [ -n "${BR2_ENDIAN}" ] 
    then
        if [ "x${BR2_ENDIAN}" = "xLITTLE" ]
        then
            __ARCHFLAGS__=${__ARCHFLAGS__}" -DBSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE"
        elif [ "x${BR2_ENDIAN}" = "xBIG" ]
        then
            __ARCHFLAGS__=${__ARCHFLAGS__}" -DBSTD_CPU_ENDIAN=BSTD_ENDIAN_BIG"
        fi
    fi

    echo ${__ARCHFLAGS__}
}
# --------------------------------------------------------------------------------------------------------------------
# Determine the global settings and initialize the ERROR/WARNINGS..
# --------------------------------------------------------------------------------------------------------------------
__ERROR__=0
__WARNING__=0

PROJECTDIR=$(real_path $0)

# Read the current configuration setting for crosscompile information...
. ${PROJECTDIR}/.config 2>/dev/null

ARCHITECTURE=$(crosscompile_name)

echo "Buildroot:    "$PROJECTDIR
echo "Architecture: "$ARCHITECTURE

# --------------------------------------------------------------------------------------------------------------------
# Set the Crosscompiler tools:
# --------------------------------------------------------------------------------------------------------------------

AR="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-ar"
if [ ! -f ${AR} ] || [ ! -r ${AR} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Archiver tool!"
fi

AS="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-as"
if [ ! -f ${AS} ] || [ ! -r ${AS} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Assembler tool!"
fi

LD="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-ld"
if [ ! -f ${LD} ] || [ ! -r ${LD} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Linker tool!"
fi

NM="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-nm"
if [ ! -f ${NM} ] || [ ! -r ${NM} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Name Mangler tool!"
fi

CPP="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-cpp" 
if [ ! -f ${CPP} ] || [ ! -r ${CPP} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled C Preprocessor tool!"
fi

CC="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-gcc"
GCC="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-gcc"
if [ ! -f ${CC} ] || [ ! -r ${CC} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled C/C++ Compiler tool!"
fi

RANLIB="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-ranlib"
if [ ! -f ${RANLIB} ] || [ ! -r ${RANLIB} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Archive Indexer tool!"
fi

OBJCOPY="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-objcopy"
if [ ! -f ${OBJCOPY} ] || [ ! -r ${OBJCOPY} ]
then
    __ERROR__=$((__ERROR__ + 1));	
    echo
    echo -n "Error:        Missing cross compiled Object Copier and Translator tool!"
fi

CXX="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-g++"
if [ ! -f ${CXX} ] || [ ! -r ${CXX} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled G++ Compiler tool!"
fi

FC="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-gfortran"
if [ ! -f ${FC} ] || [ ! -r ${FC} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled Fortran Compiler tool!"
fi

READELF="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-readelf"
if [ ! -f ${READELF} ] || [ ! -r ${READELF} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled ELF Reader tool!"
fi

STRIP="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-strip"
if [ ! -f ${STRIP} ] || [ ! -r ${STRIP} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled Strip tool!"
fi

OBJDUMP="${PROJECTDIR}/output/host/usr/bin/${ARCHITECTURE}-objdump"
if [ ! -f ${OBJDUMP} ] || [ ! -r ${OBJDUMP} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled Object Dump tool!"
fi

PKG_CONFIG="${PROJECTDIR}/output/host/usr/bin/pkg-config"
if [ ! -f ${PKG_CONFIG} ] || [ ! -r ${PKG_CONFIG} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled Package COnfiguration tool!"
fi

PERLLIB="${PROJECTDIR}/output/host/usr/lib/perl"
if [ ! -f ${PKG_CONFIG} ] || [ ! -r ${PKG_CONFIG} ]
then
    __WARNING__=$((__WARNING__ + 1));	
    echo
    echo -n "Warning:      Missing cross compiled PERL libraries!"
fi

if [ __WARNING__ > 0 ] || [ __ERROR__ > 0 ]
then
    echo 
fi

# --------------------------------------------------------------------------------------------------------------------
# Define the Staging area:
# --------------------------------------------------------------------------------------------------------------------
STAGING_DIR="${PROJECTDIR}/output/host/usr/${ARCHITECTURE}/sysroot"

# --------------------------------------------------------------------------------------------------------------------
# Set the correct build flags:
# --------------------------------------------------------------------------------------------------------------------
__FLAGS__="$(compile_flags) -I. -I${STAGING_DIR}/usr/include/ -I${STAGING_DIR}/include"
__LINKER__="-L. -L${STAGING_DIR}/usr/lib -L${STAGING_DIR}/lib"
__PREDEFINES__=""

CFLAGS="-I${STAGING_DIR}/usr/include/refsw/"
DEFINES="-DNEXUS_PLATFORM=PACE_DMC7000KLG_CADB"
CXXFLAGS="-fsigned-char"

# --------------------------------------------------------------------------------------------------------------------
# Build the proper "ccmake" command and set it as an alias:
# --------------------------------------------------------------------------------------------------------------------
alias ccmake="PATH=\"${PROJECTDIR}/output/host/bin:${PROJECTDIR}/output/host/usr/bin:${PROJECTDIR}/output/host/usr/sbin/:${PATH}\" make -j9 AR=\"${AR}\" AS=\"${AS}\" LD=\"${LD}\" NM=\"${NM}\" CPP=\"${CPP}\" CC=\"${CC}\" GCC=\"${GCC}\" CXX=\"${CXX}\" FC=\"${FC}\" RANLIB=\"${RANLIB}\" READELF=\"${READELF}\" STRIP=\"${STRIP}\" OBJCOPY=\"${OBJCOPY}\" OBJDUMP=\"${OBJDUMP}\" PKG_CONFIG=\"${PKG_CONFIG}\" PERLLIB=\"${PERLLIB}\" STAGING_DIR=\"${STAGING_DIR}\" CPPFLAGS=\"${__PREDEFINES__}\" CXXFLAGS=\"${__FLAGS__}\" CFLAGS=\"${__FLAGS__}\" LDFLAGS=\"${__LINKER__}\" FCFLAGS=\"${FCFLAGS}\""
