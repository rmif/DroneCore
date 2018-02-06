# Set c-ares variables
set(DRONECORESERVER_CARES_SOURCE_DIR "${DRONECORESERVER_EXTERNAL_SOURCE_DIR}/cares")
set(DRONECORESERVER_CARES_BINARY_DIR "${DRONECORESERVER_EXTERNAL_BINARY_DIR}/cares")

# Actually build c-ares
include(cmake/helpers/build_target.cmake)
build_target(${DRONECORESERVER_CARES_SOURCE_DIR} ${DRONECORESERVER_CARES_BINARY_DIR})

## Include c-ares-config.cmake
#find_file(
#    DRONECORESERVER_CARES_CMAKE_CONFIG c-ares-config.cmake
#    PATHS ${DRONECORESERVER_CARES_BINARY_DIR}/lib/cmake/c-ares ${DRONECORESERVER_CARES_BINARY_DIR}/lib64/cmake/c-ares ${DRONECORESERVER_CARES_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}/cmake/c-ares
#    )
#
#if(NOT DRONECORESERVER_CARES_CMAKE_CONFIG)
#    message(FATAL_ERROR "C-ares config file (c-ares-config.cmake) not found!")
#else()
#    message(FATAL "C-ares config file (c-ares-config.cmake) FOUND!")
#endif()
#
##include(${DRONECORESERVER_PROTOBUF_CMAKE_CONFIG})


# Update CMAKE_PREFIX_PATH accordingly
list(APPEND CMAKE_PREFIX_PATH /cares/lib/cmake/c-ares)
list(APPEND ENV{CMAKE_PREFIX_PATH} /cares/lib/cmake/c-ares)
