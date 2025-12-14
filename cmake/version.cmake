# cmake/version.cmake
function(generate_version_header)
    # Read version from version.txt
    set(VERSION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/version.txt")
    if(EXISTS "${VERSION_FILE}")
        file(READ "${VERSION_FILE}" VERSION_CONTENT)
        string(STRIP "${VERSION_CONTENT}" VERSION_CONTENT)
        string(REPLACE "." ";" VERSION_LIST "${VERSION_CONTENT}")
        list(LENGTH VERSION_LIST VERSION_LENGTH)
        
        if(VERSION_LENGTH GREATER 0)
			list(GET VERSION_LIST 0 PROJECT_VERSION_MAJOR)
			set(PROJECT_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}" PARENT_SCOPE)
		else()
			set(PROJECT_VERSION_MAJOR 0 PARENT_SCOPE)
		endif()
			
		if(VERSION_LENGTH GREATER 1)
			list(GET VERSION_LIST 1 PROJECT_VERSION_MINOR)
			set(PROJECT_VERSION_MINOR "${PROJECT_VERSION_MINOR}" PARENT_SCOPE)
		else()
			set(PROJECT_VERSION_MINOR 0 PARENT_SCOPE)
		endif()
			
		if(VERSION_LENGTH GREATER 2)
			list(GET VERSION_LIST 2 PROJECT_VERSION_PATCH)
			set(PROJECT_VERSION_PATCH "${PROJECT_VERSION_PATCH}" PARENT_SCOPE)
		else()
			set(PROJECT_VERSION_PATCH 0 PARENT_SCOPE)
		endif()
    else()
        # Fallback if version.txt doesn't exist
        set(PROJECT_VERSION_MAJOR 0 PARENT_SCOPE)
        set(PROJECT_VERSION_MINOR 1 PARENT_SCOPE)
        set(PROJECT_VERSION_PATCH 0 PARENT_SCOPE)
        message(WARNING "version.txt not found, using default version: ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
    endif()

    # Set CMake project version
    set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}" PARENT_SCOPE)

	set(CMAKE_PROJECT_VERSION_MAJOR ${PROJECT_VERSION_MAJOR} PARENT_SCOPE)
	set(CMAKE_PROJECT_VERSION_MINOR ${PROJECT_VERSION_MINOR} PARENT_SCOPE)
	set(CMAKE_PROJECT_VERSION_PATCH ${PROJECT_VERSION_PATCH} PARENT_SCOPE)

	# Configure the version header in the source include directory
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/include/version.h
        @ONLY
    )
    
    message(STATUS "Project version: ${PROJECT_VERSION}")
endfunction()