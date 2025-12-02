# C

```bash
cmake -B build -DCMAKE_PREFIX_PATH="../generated_libs/complexNumber" -DCMAKE_BUILD_TYPE=Release
 && cmake --build build --config Release
```

Output

```bash
C:\project-coding\cpp\202512\cpp-c-style-lib\mylibLib-consumer-c>C:\project-coding\cpp\202512\cpp-c-style-lib\mylibLib-consumer-c\build\Release\complexNumberTestC.exe
a + b = (6, 8)
a - b = (-2, -2)
a * b = (-7, 22)
a / b = (0.560976, 0.0487805)

Additional operations:
Real part of a: 2.000000
Imaginary part of a: 3.000000
Magnitude of a: 3.605551
After setting new values:
Real part of a: 10.000000
Imaginary part of a: 20.000000
```