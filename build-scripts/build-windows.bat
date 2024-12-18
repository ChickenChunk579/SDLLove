@echo off
echo Building for Windows...

echo Checking for compiler...

set generator=Visual Studio 17 2022
set CC=cl

set compilerPreferance="%1"

if %compilerPreferance%=="clang" (
    echo Using clang with MinGW Makefiles
    set "generator=MinGW Makefiles"
    set "CC=clang"
    goto START
) else if %compilerPreferance%=="gcc" (
    echo Using gcc with MinGW Makefiles
    set "generator=MinGW Makefiles"
    set "CC=gcc"
    goto START
) else if %compilerPreferance%=="cl" (
    echo Using MSVC with Visual Studio Solutions
    goto START
)

where /q cl
IF ERRORLEVEL 1 (
    where /q clang
    IF ERRORLEVEL 1 (
        echo Could not find a suitable compiler. Please install a C++ compiler.
        pause
        goto end
    ) ELSE (
        echo Using clang with MinGW Makefiles
        set generator="MinGW Makefiles"
        set CC=clang
    )
) ELSE (
    echo Using MSVC Compiler
)

:START

echo Step 1: Configure
mkdir build 2> NUL
mkdir build\windows-%CC% 2> NUL
cd build\windows-%CC%
set ERRORLEVEL=0
echo Running `cmake -G "%generator%" ..\..`
cmake -G "%generator%" ..\..
IF ERRORLEVEL 1 (
    echo Error occured while configuring
    cd ..\..
    pause
    goto end
)

echo Step 2: Build
cmake --build .
IF ERRORLEVEL 1 (
    echo Error occured while building
    cd ..\..
    pause
    goto end
)

echo Done!
cd ..\..
:end