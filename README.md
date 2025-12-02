```bash
# Lib
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Release
 && cmake --install build --prefix "generated_libs/mylibLib" --config Release
 && cmake -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake -DENABLE_SHARED=ON
 && cmake --build build --config Debug
 && cmake --install build --prefix "generated_libs/mylibLib" --config Debug

 # Consumer
 cd examples/complexNumberLib-c-consumer

 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Release
 && cmake -B build -DCMAKE_PREFIX_PATH="../../generated_libs/mylibLib" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake 
 && cmake --build build --config Debug
```