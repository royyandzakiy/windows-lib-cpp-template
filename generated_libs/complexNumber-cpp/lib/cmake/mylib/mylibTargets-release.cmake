#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "mylib::mylib" for configuration "Release"
set_property(TARGET mylib::mylib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(mylib::mylib PROPERTIES
  IMPORTED_IMPLIB_RELEASE "${_IMPORT_PREFIX}/lib/mylib.lib"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/mylib.dll"
  )

list(APPEND _cmake_import_check_targets mylib::mylib )
list(APPEND _cmake_import_check_files_for_mylib::mylib "${_IMPORT_PREFIX}/lib/mylib.lib" "${_IMPORT_PREFIX}/bin/mylib.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
