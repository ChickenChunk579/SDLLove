cmake_minimum_required(VERSION 3.5)
project(SDLLove)

add_library(SDL3 STATIC IMPORTED)
set_target_properties(SDL3 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/natives/sdl/include"
)
if (USINGIOS)
    add_library(SDL3Framework)
    target_link_libraries(SDL3Framework PRIVATE "-framework CoreFoundation")
    target_link_libraries(SDL3Framework PRIVATE "-framework UIKit")
    target_link_libraries(SDL3Framework PRIVATE "-framework SDL3")
    set_target_properties(SDL3Framework PROPERTIES LINK_FLAGS "-Wl,-F${CMAKE_SOURCE_DIR}/natives/iossimulator")
    set(SDL3_DEPS SDL3Framework)
else()
    if (WIN32)
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/windows/SDL3-static.lib"
        )
        set(SDL3_DEPS winmm setupapi version imm32)
    endif()
    if (UNIX)
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/linux/libSDL3.a"
        )
        set(SDL3_DEPS )
    endif()
    if (EMSCRIPTEN)
        set_target_properties(SDL3 PROPERTIES
            IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/natives/sdl/emscripten/libSDL3.a"
        )
        set(SDL3_DEPS )
        set(CMAKE_EXECUTABLE_SUFFIX ".html")
    endif()
endif()


add_executable(love main.cpp)
target_link_libraries(love PRIVATE SDL3 ${SDL3_DEPS})