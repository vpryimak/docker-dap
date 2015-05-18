#!/bin/sh

BUILD_DIR=~/dap-build
CATALINA_BASE=~/tomcat
LOGS_DIR=$CATALINA_BASE/logs
WORK_DIR=$CATALINA_BASE/work
TEMP_DIR=$CATALINA_BASE/temp
WEBAPPS_DIR=$CATALINA_BASE/webapps
TOMCAT_SCRIPT=~/scripts/tomcat.sh
PLUGIN_DIR=~/dap-plugins

$TOMCAT_SCRIPT stop

echo "removing tomcat working folders..."

rm -rf $LOGS_DIR
rm -rf $WORK_DIR
rm -rf $TEMP_DIR
rm -rf $WEBAPPS_DIR

if [ -d "$LOGS_DIR" ]; then
    echo $LOGS_DIR has not been deleted
    return -1
fi

if [ -d "$WORK_DIR" ]; then
    echo $WORK_DIR has not been deleted
    return -1
fi

if [ -d "$TEMP_DIR" ]; then
    echo $TEMP_DIR has not been deleted
    return -1
fi

if [ -d "$WEBAPPS_DIR" ]; then
    echo $WEBAPPS_DIR has not been deleted
    return -1
fi

echo "creating tomcat working folders..."

mkdir $LOGS_DIR
mkdir $WORK_DIR
mkdir $TEMP_DIR
mkdir $WEBAPPS_DIR

echo "copying war file to webapps..."

cp $BUILD_DIR/*.war $WEBAPPS_DIR/dap.war
cp $BUILD_DIR/dap-plugins/**/target/*.zip $PLUGIN_DIR

$TOMCAT_SCRIPT start