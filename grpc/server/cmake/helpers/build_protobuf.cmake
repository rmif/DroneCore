# Set protobuf variables
set(DRONECORESERVER_PROTOBUF_SOURCE_DIR "${DRONECORESERVER_EXTERNAL_SOURCE_DIR}/protobuf")
set(DRONECORESERVER_PROTOBUF_BINARY_DIR "${DRONECORESERVER_EXTERNAL_BINARY_DIR}/protobuf")

# Actually build protobuf
include(cmake/helpers/build_target.cmake)
build_target(${DRONECORESERVER_PROTOBUF_SOURCE_DIR} ${DRONECORESERVER_PROTOBUF_BINARY_DIR})

## Include protobuf-config.cmake
#find_file(
#    DRONECORESERVER_PROTOBUF_CMAKE_CONFIG protobuf-config.cmake
#    PATHS ${DRONECORESERVER_PROTOBUF_BINARY_DIR}/lib/cmake/protobuf ${DRONECORESERVER_PROTOBUF_BINARY_DIR}/lib64/cmake/protobuf ${DRONECORESERVER_PROTOBUF_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}/cmake/protobuf
#    )
#
#if(NOT DRONECORESERVER_PROTOBUF_CMAKE_CONFIG)
#    message(FATAL_ERROR "Protobuf config file (protobuf-config.cmake) not found!")
#endif()
#
#include(${DRONECORESERVER_PROTOBUF_CMAKE_CONFIG})

# Update CMAKE_PREFIX_PATH accordingly
list(APPEND CMAKE_PREFIX_PATH /protobuf/lib/cmake/protobuf)
list(APPEND ENV{CMAKE_PREFIX_PATH} /protobuf/lib/cmake/protobuf)
