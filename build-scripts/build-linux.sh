#!/bin/bash

echo "Building for Unix..."

echo "Searching for a compiler..."

CC="$1"
CC_RECOGNIZED="no"

if [ "$CC" = "gcc" ] || [ "$CC" = "clang" ]; then
    echo "Using $CC Compiler"
    CC_RECOGNIZED="yes"
fi

if [ "$CC" = "" ]; then
    echo "Using default compiler: clang"
    CC="clang"
    CC_RECOGNIZED="yes"
fi

CXX="${CC}++"

if [ "$CC_RECOGNIZED" = "no" ]; then
    echo "Unrecognized compiler: $CC"
    exit 1
fi


echo "Step 1: Configure"
mkdir -p build/linux-$CC
cd build/linux-$CC
cmake -GNinja -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_C_COMPILER=$CC ../..

echo "Step 2: Build"
cmake --build .