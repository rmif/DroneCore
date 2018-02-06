# Set gRPC variables
set(DRONECORESERVER_GRPC_SOURCE_DIR "${DRONECORESERVER_EXTERNAL_SOURCE_DIR}/grpc")
set(DRONECORESERVER_GRPC_BINARY_DIR "${DRONECORESERVER_EXTERNAL_BINARY_DIR}/grpc")

# Actually build gRPC
include(cmake/helpers/build_target.cmake)
build_target(${DRONECORESERVER_GRPC_SOURCE_DIR} ${DRONECORESERVER_GRPC_BINARY_DIR})

# Include gRPCConfig.cmake
find_file(
    DRONECORESERVER_GRPC_CMAKE_CONFIG gRPCConfig.cmake
    PATHS ${DRONECORESERVER_GRPC_BINARY_DIR}/lib/cmake/grpc ${DRONECORESERVER_GRPC_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}/cmake/grpc
   )

if(NOT DRONECORESERVER_GRPC_CMAKE_CONFIG)
    message(FATAL_ERROR "GRPC config file (gRPCConfig.cmake) not found!")
endif()

#include(${DRONECORESERVER_GRPC_CMAKE_CONFIG})

# Update CMAKE_PREFIX_PATH accordingly
set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}:${DRONECORESERVER_GRPC_BINARY_DIR}")
set(ENV{CMAKE_PREFIX_PATH} ${CMAKE_PREFIX_PATH})
