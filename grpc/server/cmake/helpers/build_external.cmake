set(DRONECORESERVER_EXTERNAL_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake/third_party")
set(DRONECORESERVER_EXTERNAL_BINARY_DIR "${CMAKE_BINARY_DIR}/third_party")

# TODO SPARTA necessary?
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)

include(cmake/helpers/build_protobuf.cmake)
include(cmake/helpers/build_cares.cmake)
include(cmake/helpers/build_grpc.cmake)
