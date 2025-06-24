cmake_minimum_required(VERSION 3.1)
project(rsp_tcp VERSION 0.1.0)

find_package(Threads REQUIRED)

# Set SDRplay API paths
set(SDRPLAY_INCLUDE_DIR /opt/sdrplay_api/include)
set(SDRPLAY_LIBRARY /opt/sdrplay_api/lib/libmirsdrapi-rsp.so)

# Set include and library paths
include_directories(${SDRPLAY_INCLUDE_DIR})
link_directories(/opt/sdrplay_api/lib)

# Build options
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_C_FLAGS "-Wall")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -ggdb")
add_definitions(-D_GNU_SOURCE)
add_definitions(-DSERVER_NAME="${PROJECT_NAME}")
add_definitions(-DSERVER_VERSION="${PROJECT_VERSION}")

# Source file is in top-level directory
add_executable(rsp_tcp rsp_tcp.c)
target_link_libraries(rsp_tcp ${SDRPLAY_LIBRARY} Threads::Threads)

# Install to /usr/local/bin
install(TARGETS rsp_tcp DESTINATION bin)
