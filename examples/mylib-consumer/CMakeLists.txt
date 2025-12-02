# =============================================================================
# Project Configuration
# =============================================================================
cmake_minimum_required(VERSION 3.28)

project(mylib-consumer 
    LANGUAGES CXX
    VERSION 1.0.0
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(copy-dlls)
include(setup-windows)

# =============================================================================
# Toolchain Configuration
# =============================================================================
if(NOT CMAKE_TOOLCHAIN_FILE AND DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

if(CMAKE_TOOLCHAIN_FILE)
    message(STATUS "Using VCPKG toolchain: ${CMAKE_TOOLCHAIN_FILE}")
endif()

find_package(cppwinrt CONFIG REQUIRED)
find_package(mylib REQUIRED)

# =============================================================================
# Compiler Configuration
# =============================================================================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# =============================================================================
# Main Executable
# =============================================================================
add_executable(${PROJECT_NAME} 
    src/main.cpp
)

target_link_libraries(${PROJECT_NAME} 
	PUBLIC
		Microsoft::CppWinRT
		windowsapp
		mylib::mylib
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_INSTALL_PREFIX}/include
)

copy_dlls_for_target(
    TARGET ${CMAKE_PROJECT_NAME}
    LIBRARY_TARGET mylib::mylib
    DLL_NAME "mylib"
    DEBUG_POSTFIX "d"
)