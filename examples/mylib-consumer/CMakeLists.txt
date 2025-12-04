# ==============================================================================
# Project Configuration
# ==============================================================================

cmake_minimum_required(VERSION 3.28)

project(
    mylib-consumer
    VERSION 1.0.0
    LANGUAGES CXX
)

# ==============================================================================
# Toolchain Configuration
# ==============================================================================

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

# ==============================================================================
# Dependencies
# ==============================================================================

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(setup-windows)
find_package(cppwinrt CONFIG REQUIRED)
find_package(mylib REQUIRED)

# ==============================================================================
# Executable Target
# ==============================================================================

add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_INSTALL_PREFIX}/include
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        Microsoft::CppWinRT
        windowsapp
        mylib::mylib
)

# ==============================================================================
# Post-build Configuration
# ==============================================================================

include(copy-dlls)
copy_dlls_for_target(
    TARGET ${PROJECT_NAME}
    LIBRARY_TARGET mylib::mylib
    DLL_NAME "mylib"
    DEBUG_POSTFIX "d"
)

# ==============================================================================
# Installation (if applicable)
# ==============================================================================

# install(TARGETS ${PROJECT_NAME}
#     RUNTIME DESTINATION bin
# )

# install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/README.md
#     DESTINATION .
# )