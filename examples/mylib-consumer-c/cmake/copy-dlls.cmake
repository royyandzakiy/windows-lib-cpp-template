# copy-dlls.cmake
# A reusable function to automatically copy DLL files for Windows shared libraries
#
# Usage:
#   include(cmake/copy-dlls.cmake)
#   copy_dlls_for_target(
#     TARGET your_target
#     LIBRARY_TARGET imported::target
#     [DLL_NAME "custom_name"]  # Optional: custom DLL base name
#     [DEBUG_POSTFIX "d"]       # Optional: debug postfix (default: "d")
#   )

function(copy_dlls_for_target)
    set(options)
    set(oneValueArgs TARGET LIBRARY_TARGET DLL_NAME DEBUG_POSTFIX)
    set(multiValueArgs)
    cmake_parse_arguments(COPY_DLLS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Check required arguments
    if(NOT COPY_DLLS_TARGET)
        message(FATAL_ERROR "copy_dlls_for_target: TARGET argument is required")
    endif()
    
    if(NOT COPY_DLLS_LIBRARY_TARGET)
        message(FATAL_ERROR "copy_dlls_for_target: LIBRARY_TARGET argument is required")
    endif()

    # Set defaults
    if(NOT COPY_DLLS_DEBUG_POSTFIX)
        set(COPY_DLLS_DEBUG_POSTFIX "d")
    endif()

    if(WIN32)
        # Get the library type
        get_target_property(LIB_TYPE ${COPY_DLLS_LIBRARY_TARGET} TYPE)
        
        if(LIB_TYPE STREQUAL "SHARED_LIBRARY")
            # Determine DLL name
            if(NOT COPY_DLLS_DLL_NAME)
                # Extract base name from library target (remove namespace if present)
                string(REPLACE "::" "_" LIB_NAME "${COPY_DLLS_LIBRARY_TARGET}")
                string(REGEX REPLACE "^.*_" "" BASE_NAME "${LIB_NAME}")
                set(DLL_BASE_NAME "${BASE_NAME}")
            else()
                set(DLL_BASE_NAME "${COPY_DLLS_DLL_NAME}")
            endif()
            
            # Get imported locations using generator expressions to handle configurations
            # First try to get the imported location directly
            get_target_property(IMPORTED_LOCATION ${COPY_DLLS_LIBRARY_TARGET} IMPORTED_LOCATION)
            
            if(IMPORTED_LOCATION)
                # Extract directory from imported location
                get_filename_component(LIB_DIR "${IMPORTED_LOCATION}" DIRECTORY)
                
                # Create generator expressions for DLL paths
                set(DEBUG_DLL "${LIB_DIR}/${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll")
                set(RELEASE_DLL "${LIB_DIR}/${DLL_BASE_NAME}.dll")
                
                # Add post-build command using generator expressions
                add_custom_command(
                    TARGET ${COPY_DLLS_TARGET}
                    POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    "$<IF:$<CONFIG:Debug>,${DEBUG_DLL},${RELEASE_DLL}>"
                    "$<TARGET_FILE_DIR:${COPY_DLLS_TARGET}>/$<IF:$<CONFIG:Debug>,${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll,${DLL_BASE_NAME}.dll>"
                    COMMENT "Copying ${DLL_BASE_NAME} DLL for ${COPY_DLLS_TARGET}"
                )
                
                message(STATUS "Configured DLL copying for ${COPY_DLLS_TARGET}: ${DLL_BASE_NAME}[${COPY_DLLS_DEBUG_POSTFIX}].dll")
                
            else()
                # Try configuration-specific properties
                set(CONFIGS Debug Release RelWithDebInfo MinSizeRel)
                set(HAS_CONFIG_PATHS FALSE)
                
                foreach(CONFIG ${CONFIGS})
                    get_target_property(IMPORTED_LOCATION_CONFIG ${COPY_DLLS_LIBRARY_TARGET} "IMPORTED_LOCATION_${CONFIG}")
                    if(IMPORTED_LOCATION_CONFIG)
                        set(HAS_CONFIG_PATHS TRUE)
                        break()
                    endif()
                endforeach()
                
                if(HAS_CONFIG_PATHS)
                    # Create a more complex generator expression for multiple configurations
                    add_custom_command(
                        TARGET ${COPY_DLLS_TARGET}
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        "$<TARGET_FILE:${COPY_DLLS_LIBRARY_TARGET}>"
                        "$<TARGET_FILE_DIR:${COPY_DLLS_TARGET}>/$<IF:$<CONFIG:Debug>,${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll,${DLL_BASE_NAME}.dll>"
                        COMMENT "Copying ${DLL_BASE_NAME} DLL for ${COPY_DLLS_TARGET}"
                    )
                    
                    message(STATUS "Configured DLL copying (config-specific) for ${COPY_DLLS_TARGET}")
                else()
                    # Try to get the DLL from the target file itself (works if it's a local target, not imported)
                    if(TARGET ${COPY_DLLS_LIBRARY_TARGET})
                        add_custom_command(
                            TARGET ${COPY_DLLS_TARGET}
                            POST_BUILD
                            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                            "$<TARGET_FILE:${COPY_DLLS_LIBRARY_TARGET}>"
                            "$<TARGET_FILE_DIR:${COPY_DLLS_TARGET}>/"
                            COMMENT "Copying DLL from ${COPY_DLLS_LIBRARY_TARGET} to ${COPY_DLLS_TARGET}"
                        )
                        
                        message(STATUS "Configured DLL copying from local target ${COPY_DLLS_LIBRARY_TARGET}")
                    else()
                        message(WARNING "Could not determine DLL location for library target: ${COPY_DLLS_LIBRARY_TARGET}")
                    endif()
                endif()
            endif()
            
        else()
            message(STATUS "${COPY_DLLS_LIBRARY_TARGET} is not a shared library (type: ${LIB_TYPE}) - skipping DLL copy")
        endif()
    endif()
endfunction()