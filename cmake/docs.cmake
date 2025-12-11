# use doxygen for building the documentation, check that it is available
if (BUILD_DOCS)
	find_program(DOXYGEN_EXECUTABLE doxygen)

  message(STATUS "Docs will be generated using Doxygen: ${DOXYGEN_EXECUTABLE}")
  message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
  message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")
  message(STATUS "CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")
  if (DOXYGEN_EXECUTABLE)
    # create Doxyfile
    configure_file(${PROJECT_SOURCE_DIR}/docs/Doxyfile.in ${CMAKE_BINARY_DIR}/Doxyfile @ONLY)

    # note the option ALL which allows to build the docs together with the application
    add_custom_target(doxygenDocs ALL
      COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/Doxyfile
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Generating API documentation with Doxygen"
    )
  else (DOXYGEN_EXECUTABLE)
    message(WARNING "Doxygen need to be installed to generate the doxygen documentation")
  endif (DOXYGEN_EXECUTABLE)
endif (BUILD_DOCS)
