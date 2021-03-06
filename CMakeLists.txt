cmake_minimum_required(VERSION 3.1)

set(CMAKE_INSTALL_PREFIX "../install" CACHE PATH "default cache path")

set(CMAKE_CXX_STANDARD 11)

project(dronecore)

if(NOT MSVC)
    # Clang and GCC
    # We want C++11 and lots of warnings.
    # We are not using exceptions to make it easier to write wrappers.
    add_definitions(
        -fno-exceptions
    )

    set(warnings "-Wall -Wextra -Werror -Wshadow -Wno-strict-aliasing -Wold-style-cast -Wdouble-promotion -Wformat=2")

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 6)
            set(warnings "${warnings} -Wduplicated-cond -Wnull-dereference")
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 7)
            set(warnings "${warnings} -Wduplicated-branches")
        endif()

        if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5)
            set(warnings "${warnings} -Wno-missing-field-initializers")
        endif()

        set(warnings "${warnings} -Wuseless-cast -Wlogical-op")
    endif()
else()
    # MSBuild
    add_definitions(
        -DWINDOWS
    )

    set(warnings "-WX -W2")

    # We need this so Windows links to e.g. dronecore_telemetry.dll.
    # Without this option it will look for dronecore_telemetry.lib and fail.
    option(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS "Export all symbols on Windows" ON)
endif()

# Clang needs this warning disabled.
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # Some time ago we needed `-stdlib=libc++` but that does not seem to be true anymore.
    set(warnings "${warnings} -Wno-missing-braces")
endif()

# We need a define if on APPLE
if(APPLE)
    add_definitions("-DAPPLE")
endif()

# Add DEBUG define for Debug target
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG")

set(CMAKE_CXX_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS_COVERAGE} --coverage")
set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS_COVERAGE} --coverage")
set(CMAKE_LINKER_FLAGS_COVERAGE "${CMAKE_LINKER_FLAGS_COVERAGE} --coverage")

# TODO: move into plugin
if (ANDROID)
    add_definitions(-frtti)
    # Workaround for a plugin where the __androidx86__ is necessary.
    if (ANDROID_ABI STREQUAL "x86")
        add_definitions(-D__androidx86__)
    endif()

endif()

include(cmake/zlib.cmake)

# We support install in order to use the header and library files in
# other applications.
if(ANDROID)
    set(lib_path "lib/android/${ANDROID_ABI}")
elseif(IOS)
    set(lib_path "lib/ios")
else()
    set(lib_path "lib")
endif()

# We want to use consistent install directories across libraries.
set(dronecore_install_include_dir "include/dronecore")
set(dronecore_install_lib_dir ${lib_path})

# core and some plugins require curl
if(ANDROID)
    set(CURL_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/core/third_party/curl-android-ios/prebuilt-with-ssl/android/include)
    set(CURL_LIBRARY ${CMAKE_SOURCE_DIR}/core/third_party/curl-android-ios/prebuilt-with-ssl/android/${ANDROID_ABI}/libcurl.a)
elseif(IOS)
    set(CURL_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/core/third_party/curl-android-ios/prebuilt-with-ssl/ios/include)
    set(CURL_LIBRARY ${CMAKE_SOURCE_DIR}/core/third_party/curl-android-ios/prebuilt-with-ssl/ios/libcurl.a)
elseif(MSVC)
    # You need to call cmake with -DWIN_CURL_INCLUDE_DIR:STRING="C:\\curl-7.54.1\\include"
    if(NOT WIN_CURL_INCLUDE_DIR)
        message(FATAL_ERROR "Please provide argument -DWIN_CURL_INCLUDE_DIR:STRING=\"path_to_curl_include\"")
    endif()
    if(NOT WIN_CURL_LIB)
        message(FATAL_ERROR "Please provide argument -DWIN_CURL_LIBSTRING=\"path_to_curl_lib\"")
    endif()

    set(CURL_INCLUDE_DIRS ${WIN_CURL_INCLUDE_DIR})
    set(CURL_LIBRARY ${WIN_CURL_LIB})

    add_definitions(
        -DCURL_STATICLIB
    )
else()
    find_package(CURL REQUIRED)
    set(CURL_LIBRARY "curl")
endif()

include_directories(${CURL_INCLUDE_DIRS})

# Build the actual dronecore library.
add_subdirectory(core)

# Add default plugins.
add_subdirectory(plugins)

# Add external plugins.
if (DEFINED EXTERNAL_DIR AND NOT EXTERNAL_DIR STREQUAL "")
    add_subdirectory(${EXTERNAL_DIR}/plugins
        ${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_DIR}/plugins)
    include_directories(
        ${EXTERNAL_DIR}
    )
endif()

if(NOT IOS AND NOT ANDROID)
    if (CMAKE_BUILD_DRONECORESERVER)
        message(STATUS "Building dronecore server")
        add_subdirectory(grpc/server)
    else()
        message(STATUS "BUILD_DRONECORESERVER not set: not building dronecore server")
    endif()

    enable_testing()
    add_subdirectory(${CMAKE_SOURCE_DIR}/third_party/gtest EXCLUDE_FROM_ALL)

    add_subdirectory(integration_tests)

    if (DEFINED EXTERNAL_DIR AND NOT EXTERNAL_DIR STREQUAL "")
        add_subdirectory(${EXTERNAL_DIR}/integration_tests
            ${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_DIR}/integration_tests)
    endif()
endif()

if (DROP_DEBUG EQUAL 1)
    add_definitions(-DDROP_DEBUG=${DROP_DEBUG})

    add_executable(drop_debug
        debug_helpers/drop_debug_main.cpp
    )

    target_link_libraries(drop_debug
        dronecore
    )
endif()
