#!/bin/sh

TARGET_DIR=$1
IMAGES_DIR=$1/../images
BOARD_DIR="$(dirname $0)"

cp $BOARD_DIR/interfaces $TARGET_DIR/etc/network/
