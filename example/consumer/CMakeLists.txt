#==============================================================================
# Project Configuration
#==============================================================================
cmake_minimum_required(VERSION 3.28)

project(cmake_project_template 
    LANGUAGES CXX
    VERSION 1.0.0
)

#==============================================================================
# Version Management
#==============================================================================
include(cmake/version.cmake)
generate_version_header()
source_group("Generated" FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/version.h")
message(STATUS "Building ${PROJECT_NAME} version ${PROJECT_VERSION}")

#==============================================================================
# Platform Configuration
#==============================================================================
if(WIN32)
    include(cmake/setup-windows.cmake)
endif()

#==============================================================================
# Toolchain Configuration
#==============================================================================
if(NOT CMAKE_TOOLCHAIN_FILE AND DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

if(CMAKE_TOOLCHAIN_FILE)
    message(STATUS "Using VCPKG toolchain: ${CMAKE_TOOLCHAIN_FILE}")
endif()

#==============================================================================
# WinRT Configuration
#==============================================================================

find_package(cppwinrt CONFIG REQUIRED)
add_compile_definitions(WINDOWS_WINRT_ENABLED=1)

#==============================================================================
# Compiler Configuration
#==============================================================================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Optional: Enable Clang-Tidy if defined
if(CLANGTIDY)
    set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY})
    message(STATUS "Clang-Tidy enabled: ${CLANGTIDY}")
endif()

#==============================================================================
# Dependencies
#==============================================================================
find_package(GTest CONFIG REQUIRED)
find_package(PahoMqttCpp CONFIG REQUIRED)

#==============================================================================
# Project Structure
#==============================================================================
add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(docs)

#==============================================================================
# Main Executable
#==============================================================================
add_executable(${PROJECT_NAME} 
    src/main.cpp
)
target_link_libraries(${PROJECT_NAME} PRIVATE my_ble)