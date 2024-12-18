#!/bin/bash

echo "Building for iOS Simualtor"

echo "Step 1: Configure"

mkdir -p build/macos-iossimulator
cd build/macos-iossimulator
cmake ../.. -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=SIMULATORARM64 -DUSINGIOS=YES

echo "Step 2: Build"
cmake --build . --config Release