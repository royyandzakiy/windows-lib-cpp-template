# ==============================================================================
# Project Configuration
# ==============================================================================

cmake_minimum_required(VERSION 3.28)

project(
    mylib-consumer-cpp17-no_vcpkgconsumer
    VERSION 1.0.0
    LANGUAGES CXX
)

# ==============================================================================
# Compiler Configuration
# ==============================================================================

set(CMAKE_CXX_STANDARD 17)
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

# ==============================================================================
# Library Dependency
# ==============================================================================

# Try to find the mylib library
if(TARGET mylib)
    # We're building as part of the main mylib project
    message(STATUS "Linking to mylib from same build")
    set(MYLIB_TARGET mylib)
else()
    # We're building standalone - find the installed package
    message(STATUS "Looking for installed mylib package")
    find_package(mylib REQUIRED)
    set(MYLIB_TARGET mylib::mylib)
endif()

# ==============================================================================
# Executable Target
# ==============================================================================

add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../..  # For accessing mylib headers
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        ${MYLIB_TARGET}
)

# ==============================================================================
# Post-build Configuration
# ==============================================================================

# Include copy-dlls only if building shared library
if(TARGET ${MYLIB_TARGET})
    get_target_property(MYLIB_TYPE ${MYLIB_TARGET} TYPE)
    if(MYLIB_TYPE STREQUAL "SHARED_LIBRARY")
        include(copy-dlls)
        copy_dlls_for_target(
            TARGET ${PROJECT_NAME}
            LIBRARY_TARGET ${MYLIB_TARGET}
            DLL_NAME "mylib"
            DEBUG_POSTFIX "d"
        )
    endif()
endif()