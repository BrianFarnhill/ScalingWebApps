#!/bin/bash

rm -rf build/release

mkdir build/release
mkdir build/release/cfn
mkdir build/release/web
mkdir build/release/loadtest

cp src/cfn/*.yaml build/release/cfn

# Create the application version for the start of the main web app
cd src/web/start
zip -r ../../../build/release/web/start.zip ./
cd ../../../

# Create an app package for the locust load testers
cd src/loadtest/start
zip -r ../../../build/release/loadtest/start.zip ./
cd ../../../
