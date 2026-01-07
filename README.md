# CMake C++ Library Template for Windows

A professional boilerplate for developing and building C++ static and dynamic libraries on Windows. This template follows modern C++23 practices and provides a robust structure for multi-language consumption.

## Features

* **Modern C++23** standards and best practices
* **Dual Library Support** for building both static and shared/dynamic libraries
* **vcpkg Integration** for seamless dependency management
* **Multi-language Examples** including C, C++17, C++23, Python, and Zig consumers
* **CMake Presets** for simplified configuration and build workflows
* **Doxygen Support** for automated API documentation

## Prerequisites

### Required Software

* **Visual Studio 2022** (v143 build tools)
* **Git**
* **CMake** (3.20 or newer)

### Recommended

* **Visual Studio Code** with CMake Tools extension
* **vcpkg** (global installation or as a submodule)

## Quick Start

### 1. Setup Environment

Create `CMakeUserPresets.json` in the root directory to specify your vcpkg path:

```json
{
  "version": 2,
  "configurePresets": [
    {
      "name": "default",
      "inherits": "windows-base",
      "environment": {
        "VCPKG_ROOT": "C:/path/to/vcpkg"
      }
    }
  ]
}

```

### 2. Build

**Using VS Code:**

1. Select the `default` preset
2. Run Task: `Configure Project`
3. Run Task: `Build Project`

**Using Command Line:**

```powershell
cmake --preset default
cmake --build build/default

```

## Project Structure

```text
windows-lib-cpp-template/
├── examples/        # Consumer examples (C, C++, Python, Zig)
├── include/         # Public headers for the library
├── mylibLib/        # Library implementation source code
├── cmake/           # Build utilities and scripts
├── docs/            # Documentation configuration
├── CMakePresets.json
└── vcpkg.json

```

## Library Consumption

This template is designed to be easily consumed by different environments. Refer to the `examples/` directory for specific implementation details:

* **C++ with vcpkg**: Modern integration using CMake find_package.
* **Pure C**: Demonstrates C-compatible ABI exports.
* **Python**: Integration via ctypes or C-extensions.
* **Zig**: Direct C-header import and linking.

## Development Workflow

### Documentation

Generate API docs using the provided Doxygen configuration:

```powershell
cmake --build build/default --target docs

```

### Dependency Management

Add new dependencies to `vcpkg.json`. The build system will automatically install them during the configuration phase.

## License

MIT License - see LICENSE file for details.
