# Zig

Apparently, the .dll needs to be inside the zig consumer folder. if not, the zig program will run without printing anything

```bash
cd examples/mylib-consumer-zig

# Copy the .dll. It is MANDATORY for the dll to be inside the mylib-consomer-zig/ root folder
copy /y ..\..\generated_libs\mylibLib\bin\mylib.dll .

# Run
zig run src/main.zig --library mylib -I. -L.
# or
zig run src/main.zig --library ../../generated_libs/mylibLib/bin/mylib -I. -L.
```

## Output

```bash
C:\path\to\cpp-library-template-winrt\examples\mylib-consumer-zig>copy /y ..\..\generated_libs\mylibLib\bin\mylib.dll .
        1 file(s) copied.

C:\path\to\cpp-library-template-winrt\examples\mylib-consumer-zig>zig run src/main.zig --library mylib -I. -L.
a + b = (6, 8)
a - b = (-2, -2)
a * b = (-7, 22)
a / b = (0.560976, 0.0487805)

Additional operations:
Real part of a: 2
Imaginary part of a: 3
Magnitude of a: 3.605551275463989
After setting new values:
Real part of a: 10
Imaginary part of a: 20
Conjugate of (2, 3): (2, -3)
Starting BLE scan (will run for 3 seconds)...
BLE scan started...

BLE Device Found:
  Address: 0000E12A539D63DC
  RSSI: -65 dBm
  Name: dbkA539D63DC-v1.0

BLE Device Found:
  Address: 0000E12A539D63DC
  RSSI: -65 dBm
  Name: dbkA539D63DC-v1.0

BLE Device Found:
  Address: 00001BDB34150FD3
  RSSI: -89 dBm

BLE Device Found:
  Address: 0000E12A539D63DC
  RSSI: -67 dBm
  Name: dbkA539D63DC-v1.0

...
```