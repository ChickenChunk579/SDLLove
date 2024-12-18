cmake_minimum_required(VERSION 3.5)
project(SDLLove)

add_library(SDL3 STATIC IMPORTED)
set_target_properties(SDL3 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/natives/sdl/include"
)
if (USINGIOS)
    
else()
    if (WIN32)
        message("Building on Windows")
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/windows/SDL3-static.lib"
        )
        set(SDL3_DEPS winmm setupapi version imm32)
    endif()
    if (UNIX)
        message("Building on Linux")
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/linux/libSDL3.a"
        )
        set(SDL3_DEPS )
    endif()
    if (EMSCRIPTEN)
        message("Building on Emscripten")
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/emscripten/libSDL3.a"
        )
        set(SDL3_DEPS )
        set(CMAKE_EXECUTABLE_SUFFIX ".html")
    endif()
endif()

add_executable(love main.cpp)

if (USINGIOS)
    message("Building on iOS")

    target_link_libraries(love PRIVATE "-framework CoreFoundation")
    target_link_libraries(love PRIVATE "-framework UIKit")
    target_link_libraries(love PRIVATE "-framework SDL3")
    set_target_properties(love PROPERTIES LINK_FLAGS "-Wl,-F${CMAKE_SOURCE_DIR}/natives/sdl/iossimulator")
    target_include_directories(love PRIVATE ${CMAKE_SOURCE_DIR}/natives/sdl/include)
    set_target_properties(love PROPERTIES 
        XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS "@executable_path/Frameworks")
else()
    target_link_libraries(love PRIVATE SDL3 ${SDL3_DEPS})
endif()