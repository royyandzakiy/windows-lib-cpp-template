## Generate Library
This will generate the library binary inside `generated/libs`
```
└── mylibLib/
    ├── bin/
    │   ├── mylib.dll
    │   └── mylibd.dll
    ├── include/
    │   └── mylibLib/
    │       ├── ble.hpp
    │       ├── complexNumbers.hpp
    │       └── mylib.h
    └── lib/
        ├── cmake/
        │   └── mylib/
        │       ├── mylibConfig.cmake
        │       ├── mylibTargets-debug.cmake
        │       ├── mylibTargets-release.cmake
        │       └── mylibTargets.cmake
        ├── mylib.lib
        └── mylibd.lib
```
```bash
# Generate Library
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Release
 && cmake --install build --prefix "generated_libs/mylibLib" --config Release
 && cmake -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Debug
 && cmake --install build --prefix "generated_libs/mylibLib" --config Debug
```

## Build & Run Consumer Example
When running cmake Configure, adding `-DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib"` adds the path that will be searched using `find_package(mylib REQUIRED)`
```bash
# Build & Run Consumer
cd examples/mylib-consumer-cpp23-with_vcpkg

 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Release
 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Debug
```

## One liner
```bash
# Lib
rmdir /s /q build
 && cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Release
 && cmake --install build --prefix "generated_libs/mylibLib" --config Release
 && cmake -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Debug
 && cmake --install build --prefix "generated_libs/mylibLib" --config Debug

 && cd examples/mylib-consumer-cpp23-with_vcpkg
 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Release
 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Debug
```