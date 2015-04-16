#!/bin/sh
export XDG_RUNTIME_DIR=/root/shm/wayland
mkdir -p $XDG_RUNTIME_DIR
chmod 0700 $XDG_RUNTIME_DIR

export ATHOL_SHELL=/usr/lib/libWPEAtholShell.so

# The PREFIX env var can be useful when debugging athol with gdbserver.
WPE_SHELL_URL=$1 $PREFIX athol
