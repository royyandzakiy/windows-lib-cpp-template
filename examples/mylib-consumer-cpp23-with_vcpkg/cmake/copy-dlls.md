# copy-dlls.cmake

### Overview

`copy-dlls.cmake` is a reusable helper for Windows builds that automatically copies
the `.dll` files of shared library dependencies into the runtime output directory
of consuming targets (usually executables).  
It’s particularly useful for projects that can be built both **in-tree** and
**standalone via installed packages** (`find_package()`).

---

### Features

- Automatically detects and copies DLLs of shared libraries.
- Works for both local and imported targets.
- Handles Debug vs Release naming conventions (`mylibd.dll` vs `mylib.dll`).
- Adds CMake `POST_BUILD` commands automatically.
- Fully configuration-aware (Debug, Release, etc.).
- Designed to be easily extended and readable.

---

### Usage

```cmake
include(cmake/copy-dlls.cmake)

copy_dlls_for_target(
    TARGET MyExecutable
    LIBRARY_TARGET mylib::mylib
    DLL_NAME "mylib"
    DEBUG_POSTFIX "d"
)
