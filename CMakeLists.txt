cmake_minimum_required(VERSION 3.28)

project(
    mylib
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "A simple C++ library for complex numbers"
)

# ==============================================================================
# Initial Setup
# ==============================================================================

# include(cmake/setup-windows.cmake)

if(NOT CMAKE_TOOLCHAIN_FILE AND DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

if(CMAKE_TOOLCHAIN_FILE)
    message(STATUS "Using VCPKG toolchain: ${CMAKE_TOOLCHAIN_FILE}")
endif()

# ==============================================================================
# Compiler Configuration
# ==============================================================================

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/W4 /permissive-)
    # add_compile_options(/WX) # more strict
else()
    add_compile_options(-Wall -Wextra)
    # add_compile_options(-Werror -pedantic) # more strict
endif()

if(WIN32)
    set(CMAKE_DEBUG_POSTFIX d)
endif()

include(cmake/options.cmake)

# ==============================================================================
# Dependencies
# ==============================================================================

find_package(cppwinrt CONFIG REQUIRED)

# ==============================================================================
# Library Target
# ==============================================================================

if(${ENABLE_SHARED})
    add_library(${CMAKE_PROJECT_NAME} SHARED)
    if(MSVC)
        target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE COMPILEDLL)
    endif()
else()
    add_library(${CMAKE_PROJECT_NAME} STATIC)
    if(MSVC)
        target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE COMPILELIB)
    endif()
endif()

# Version header generation
include(cmake/version.cmake)
generate_version_header()
source_group("Generated" FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/version.h")

message(STATUS "Building ${PROJECT_NAME} version ${PROJECT_VERSION}")

# Include directories
target_include_directories(${CMAKE_PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Library source files
add_subdirectory(mylibLib)

# ==============================================================================
# Docs
# ==============================================================================

if (BUILD_DOCS)
	include(cmake/docs.cmake)
	add_dependencies(${CMAKE_PROJECT_NAME} doxygenDocs) # needs to be below add_library(${CMAKE_PROJECT_NAME} SHARED/STATIC)
endif (BUILD_DOCS)

# ==============================================================================
# Installation
# ==============================================================================

install(TARGETS ${CMAKE_PROJECT_NAME}
    EXPORT mylibTargets
    FILE_SET HEADERS
)

install(
    EXPORT mylibTargets
    FILE mylibTargets.cmake
    DESTINATION "lib/cmake/mylib"
    NAMESPACE mylib::
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
    cmake/mylibConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/mylibConfig.cmake"
    INSTALL_DESTINATION "lib/cmake/mylib"
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/mylibConfig.cmake"
    DESTINATION "lib/cmake/mylib"
)

# ==============================================================================
# Examples (Optional)
# ==============================================================================

if(BUILD_EXAMPLES)
    add_subdirectory(examples/mylib-consumer-cpp23-with_vcpkg)
    # add_subdirectory(examples/mylib-consumer-cpp17-no_vcpkg)
    # add_subdirectory(examples/mylib-consumer-c)
endif()