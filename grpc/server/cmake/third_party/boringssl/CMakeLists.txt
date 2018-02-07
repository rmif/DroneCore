cmake_minimum_required(VERSION 3.1)

project(external-boringssl)

include(ExternalProject)

set(ARG_GIT_REPOSITORY https://github.com/google/boringssl.git)
set(ARG_GIT_TAG 56d5d7085dd1beea9af220678091fc51e4b50d3e)

if(ANDROID)
    message(STATUS "Preparing external project \"boringssl\" for Android...")
    message(STATUS " -- CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")
    message(STATUS " -- ANDROID_ABI: ${ANDROID_ABI}")
    message(STATUS " -- ANDROID_STL: ${ANDROID_STL}")

    ExternalProject_add(
        boringssl
        GIT_REPOSITORY ${ARG_GIT_REPOSITORY}
        GIT_TAG ${ARG_GIT_TAG}
        PREFIX boringssl
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${BINARY_DIR}
            -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
            -DANDROID_ABI:STRING=${ANDROID_ABI}
            -DANDROID_STL:STRING=${ANDROID_STL}
        INSTALL_COMMAND true)
elseif(IOS)
    message(STATUS "Preparing external project \"boringssl\" for iOS...")
    message(STATUS " -- CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")

    ExternalProject_add(
        boringssl
        GIT_REPOSITORY ${ARG_GIT_REPOSITORY}
        GIT_TAG ${ARG_GIT_TAG}
        PREFIX boringssl
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${BINARY_DIR}
            -DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}
            -DIOS_PLATFORM=OS
        INSTALL_COMMAND true)
else()
    message(STATUS "Preparing external project \"boringssl\"...")

    ExternalProject_add(
        boringssl
        GIT_REPOSITORY ${ARG_GIT_REPOSITORY}
        GIT_TAG ${ARG_GIT_TAG}
        PREFIX boringssl
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=${BINARY_DIR}
        INSTALL_COMMAND true)
endif()
