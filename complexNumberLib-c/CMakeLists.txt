# Select the minimum cmake version required. If in doubt, use the same version you are using
# To find out your cmake version, run 'cmake --version' in the console
cmake_minimum_required(VERSION 3.23)

# Set the project name/description and project settings like the C++ standard required
project(
  mylib
  LANGUAGES CXX
  VERSION 1.0.0
  DESCRIPTION "A simple C++ library for complex numbers"
)

#==============================================================================
# Compiler Configuration
#==============================================================================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# include custom options
include(CMakeOptions.txt)

# Add a postfix for debug library builds to avoid name clashes with release builds
if(WIN32)
  set(CMAKE_DEBUG_POSTFIX d)
endif()

if(${ENABLE_SHARED})
  # Create a shared (dynamic) library for the complex number class
  add_library(${CMAKE_PROJECT_NAME} SHARED)
  
  # add correct compiler flags so that we can correctly import/export symbols
  if (MSVC)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE COMPILEDLL)
  endif()
else()
  # Create a static library for the complex number class
  add_library(${CMAKE_PROJECT_NAME} STATIC)

  # add correct compiler flags so that we can correctly import/export symbols
  if (MSVC)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE COMPILELIB)
  endif()
endif()

target_include_directories(${CMAKE_PROJECT_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


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

# go through the complexNumberLib/ subdirectory and add any files to the library
add_subdirectory(mylibLib)

### INSTALLING ###

# install the headers that we specified with FILE_SET (header files for the user to include in their projects)
install(TARGETS ${CMAKE_PROJECT_NAME}
  EXPORT mylibTargets
  FILE_SET HEADERS
)

# provide some basic meta data about the library to generate the library's config file 
install(
  EXPORT mylibTargets
  FILE mylibTargets.cmake
  DESTINATION "lib/cmake/mylib"
  NAMESPACE mylib::
)

# generate the library's config file
include(CMakePackageConfigHelpers)
configure_package_config_file(
  cmake/mylibConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/mylibConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/mylib"
)

# install the config file
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/mylibConfig.cmake"
  DESTINATION "lib/cmake/mylib"
)