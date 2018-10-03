#!/bin/bash

rm -rf build/release

mkdir build/release
mkdir build/release/cfn
mkdir build/release/web

cp src/cfn/*.yaml build/release/cfn

cd src/web/start
zip -r ../../../build/release/web/start.zip ./
