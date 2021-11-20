cmake_minimum_required(VERSION 3.12)

if(CMAKE_POLICY_DEFAULT_CMP0017 OR CMAKE_POLICY_DEFAULT_CMP0020)
	# touch these to remove warnings
endif()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

set(LUA_VERSION "lua" CACHE STRING "Lua version to try and find." FORCE)
set(SDL_RENDERER OFF CACHE BOOL "Use the SDL2 based renderer" FORCE)

project(lite-lime VERSION 3.0.0 LANGUAGES C)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_compile_definitions(LITE_NAME="Lime Lite")
add_compile_definitions(LITE_VERSION="${CMAKE_PROJECT_VERSION}")

if (SDL_RENDERER)
    add_compile_definitions(LITE_USE_SDL_RENDERER)    
endif()

message(STATUS "Version: ${CMAKE_PROJECT_VERSION}")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

add_subdirectory(src)