cmake_minimum_required(VERSION 3.23)

project(
  complexNumberTestC
  VERSION 1.0
  LANGUAGES C
)

# Include custom options
include(CMakeOptions.txt)

# Include reusable DLL copy function
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(copy-dlls)

# Find packages will search for a specific library
find_package(mylib REQUIRED)

# Add an executable
add_executable(${CMAKE_PROJECT_NAME} main.c)

# Link with the library
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE mylib::mylib)

# Include directories
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_INSTALL_PREFIX}/include
)

# Note: For C projects, you don't need the COMPILEDLL/COMPILELIB definitions
# as the wrapper header handles this automatically

# Use the reusable function to copy DLLs
copy_dlls_for_target(
    TARGET ${CMAKE_PROJECT_NAME}
    LIBRARY_TARGET mylib::mylib
    DLL_NAME "mylib"
    DEBUG_POSTFIX "d"
)