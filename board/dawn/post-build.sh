#!/bin/sh

TARGET_DIR=$1
IMAGES_DIR=$1/../images
BOARD_DIR="$(dirname $0)"

rm -rf $TARGET_DIR/etc/init.d/S40network
