#!/bin/bash

rm -rf build/release

mkdir build/release
mkdir build/release/cfn
mkdir build/release/web
mkdir build/release/loadtest
mkdir build/release/deploy

cp src/cfn/*.yaml build/release/cfn

# Create the application version for the start of the main web app
cd src/web
mkdir zip
cd zip
## Start content
cp -R ../start/. ./
npm install
zip -r ../../../build/release/web/start.zip ./

## Cache Content
cp -R ../cache/. ./
zip -r ../../../build/release/web/cache.zip ./

cd ../
rm -rf zip
cd ../../

# Create an app package for the locust load testers
cd src/loadtest
mkdir zip
cd zip

## Start Content
cp -R ../start/. ./
zip -r ../../../build/release/loadtest/start.zip ./

## CloudFront Content
cp -R ../cloudfront/. ./
zip -r ../../../build/release/loadtest/cloudfront.zip ./

cd ../
rm -rf zip
cd ../../

# Create package for DB populator
cd ./src/dbpopulate
npm install
zip -r ../../build/release/deploy/dbpopulate.zip ./
cd ../../


