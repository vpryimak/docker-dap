#!/bin/sh

BUILD_DIR=~/dap-build
PLUGIN_DIR=~/dap-plugins

echo "removing build dir..."
rm -rf $BUILD_DIR
rm -rf $PLUGIN_DIR

if [ -d "$BUILD_DIR" ]; then
    echo $BUILD_DIR has not been deleted
    return -1
fi

if [ -d "$PLUGIN_DIR" ]; then
    echo $PLUGIN_DIR has not been deleted
    return -1
fi

echo "creating build dir..."
mkdir $BUILD_DIR
mkdir $PLUGIN_DIR

