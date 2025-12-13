# ==============================================================================
# copy-dlls.cmake
# ------------------------------------------------------------------------------
# A helper module to automatically copy Windows DLLs of shared libraries
# into the output directory of consuming targets (typically executables).
#
# Author: <Your Name or Org>
# License: MIT (or appropriate)
# Version: 1.1
# ==============================================================================

# ------------------------------------------------------------------------------
# FUNCTION: _copy_dlls_get_base_name
# Internal helper to derive a DLL base name from a library target or use
# a provided custom name.
# ------------------------------------------------------------------------------
function(_copy_dlls_get_base_name OUT_VAR LIBRARY_TARGET DLL_NAME)
    if(DLL_NAME)
        set(BASE_NAME "${DLL_NAME}")
    else()
        # Remove namespace qualifiers (e.g., mylib::core → core)
        string(REPLACE "::" "_" LIB_NAME "${LIBRARY_TARGET}")
        string(REGEX REPLACE "^.*_" "" BASE_NAME "${LIB_NAME}")
    endif()
    set(${OUT_VAR} "${BASE_NAME}" PARENT_SCOPE)
endfunction()


# ------------------------------------------------------------------------------
# FUNCTION: _copy_dlls_try_imported_location
# Attempts to resolve DLL path via IMPORTED_LOCATION.
# Returns TRUE/FALSE in OUT_FOUND and sets OUT_DLL_DIR if found.
# ------------------------------------------------------------------------------
function(_copy_dlls_try_imported_location OUT_FOUND OUT_DLL_DIR LIBRARY_TARGET)
    get_target_property(IMPORTED_LOCATION ${LIBRARY_TARGET} IMPORTED_LOCATION)
    if(IMPORTED_LOCATION)
        get_filename_component(LIB_DIR "${IMPORTED_LOCATION}" DIRECTORY)
        set(${OUT_FOUND} TRUE PARENT_SCOPE)
        set(${OUT_DLL_DIR} "${LIB_DIR}" PARENT_SCOPE)
    else()
        set(${OUT_FOUND} FALSE PARENT_SCOPE)
    endif()
endfunction()


# ------------------------------------------------------------------------------
# FUNCTION: _copy_dlls_try_config_imported_location
# Attempts to find configuration-specific imported locations (Debug/Release/etc.).
# Returns TRUE if any found.
# ------------------------------------------------------------------------------
function(_copy_dlls_try_config_imported_location OUT_FOUND LIBRARY_TARGET)
    set(CONFIGS Debug Release RelWithDebInfo MinSizeRel)
    set(HAS_CONFIG_PATHS FALSE)
    foreach(CONFIG ${CONFIGS})
        get_target_property(IMPORTED_LOCATION_CONFIG ${LIBRARY_TARGET} "IMPORTED_LOCATION_${CONFIG}")
        if(IMPORTED_LOCATION_CONFIG)
            set(HAS_CONFIG_PATHS TRUE)
            break()
        endif()
    endforeach()
    set(${OUT_FOUND} ${HAS_CONFIG_PATHS} PARENT_SCOPE)
endfunction()


# ------------------------------------------------------------------------------
# FUNCTION: copy_dlls_for_target
# Public API — adds a post-build step to copy a shared library DLL into
# the output directory of another target (e.g., executable).
#
# Usage:
#   copy_dlls_for_target(
#       TARGET <consumer-target>
#       LIBRARY_TARGET <shared-library-target>
#       [DLL_NAME <custom_base_name>]
#       [DEBUG_POSTFIX <debug_postfix>]
#   )
# ------------------------------------------------------------------------------
function(copy_dlls_for_target)
    # ------------------------------
    # Parse Arguments
    # ------------------------------
    set(options)
    set(oneValueArgs TARGET LIBRARY_TARGET DLL_NAME DEBUG_POSTFIX)
    cmake_parse_arguments(COPY_DLLS "${options}" "${oneValueArgs}" "" ${ARGN})

    # Validate required args
    if(NOT COPY_DLLS_TARGET)
        message(FATAL_ERROR "copy_dlls_for_target: TARGET argument is required.")
    endif()
    if(NOT COPY_DLLS_LIBRARY_TARGET)
        message(FATAL_ERROR "copy_dlls_for_target: LIBRARY_TARGET argument is required.")
    endif()

    # Defaults
    if(NOT COPY_DLLS_DEBUG_POSTFIX)
        set(COPY_DLLS_DEBUG_POSTFIX "d")
    endif()

    # ------------------------------
    # Platform Guard
    # ------------------------------
    if(NOT WIN32)
        message(STATUS "copy_dlls_for_target: Skipping (non-Windows platform).")
        return()
    endif()

    # ------------------------------
    # Determine Library Type
    # ------------------------------
    get_target_property(LIB_TYPE ${COPY_DLLS_LIBRARY_TARGET} TYPE)
    if(NOT LIB_TYPE STREQUAL "SHARED_LIBRARY")
        message(STATUS "${COPY_DLLS_LIBRARY_TARGET} is not a shared library (type: ${LIB_TYPE}) — skipping DLL copy.")
        return()
    endif()

    # ------------------------------
    # Determine DLL Base Name
    # ------------------------------
    _copy_dlls_get_base_name(DLL_BASE_NAME ${COPY_DLLS_LIBRARY_TARGET} ${COPY_DLLS_DLL_NAME})

    # ------------------------------
    # Attempt to Locate DLL
    # ------------------------------
    _copy_dlls_try_imported_location(HAS_IMPORTED_LOCATION DLL_DIR ${COPY_DLLS_LIBRARY_TARGET})

    if(HAS_IMPORTED_LOCATION)
        # Case 1: Found generic imported location
        set(DEBUG_DLL "${DLL_DIR}/${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll")
        set(RELEASE_DLL "${DLL_DIR}/${DLL_BASE_NAME}.dll")

        add_custom_command(
            TARGET ${COPY_DLLS_TARGET}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "$<IF:$<CONFIG:Debug>,${DEBUG_DLL},${RELEASE_DLL}>"
                "$<TARGET_FILE_DIR:${COPY_DLLS_TARGET}>/$<IF:$<CONFIG:Debug>,${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll,${DLL_BASE_NAME}.dll>"
            COMMENT "Copying ${DLL_BASE_NAME} DLL for ${COPY_DLLS_TARGET}"
        )

        message(STATUS "Configured DLL copying for ${COPY_DLLS_TARGET}: ${DLL_BASE_NAME}[${COPY_DLLS_DEBUG_POSTFIX}].dll")
        return()
    endif()

    # Case 2: Configuration-specific imported locations
    _copy_dlls_try_config_imported_location(HAS_CONFIG_PATHS ${COPY_DLLS_LIBRARY_TARGET})
    if(HAS_CONFIG_PATHS)
        add_custom_command(
            TARGET ${COPY_DLLS_TARGET}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "$<TARGET_FILE:${COPY_DLLS_LIBRARY_TARGET}>"
                "$<TARGET_FILE_DIR:${COPY_DLLS_TARGET}>/$<IF:$<CONFIG:Debug>,${DLL_BASE_NAME}${COPY_DLLS_DEBUG_POSTFIX}.dll,${DLL_BASE_NAME}.dll>"
            COMMENT "Copying ${DLL_BASE_NAME} DLL (config-specific) for ${COPY_DLLS_TARGET}"
        )
        message(STATUS "Configured DLL copying (config-specific) for ${COPY_DLLS_TARGET}")
        return()
    endif()

    # Case 3: Local target fallback
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
        return()
    endif()

    # Case 4: Failure
    message(WARNING "copy_dlls_for_target: Could not determine DLL location for library target: ${COPY_DLLS_LIBRARY_TARGET}")
endfunction()
