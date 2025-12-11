import ctypes
import os

# Get the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the relative path
if os.name == 'nt':  # Windows
    # Go up one directory, then to generated_libs/mylibLib/bin/mylibLibs.dll
    lib_path = os.path.join(script_dir, "..", "..", "generated_libs", "mylibLib", "bin", "mylib.dll")
    lib_path = os.path.normpath(lib_path)  # Normalize the path
    
lib = ctypes.CDLL(lib_path)

# Define function signatures
lib.complex_create.argtypes = [ctypes.c_double, ctypes.c_double]
lib.complex_create.restype = ctypes.c_void_p

lib.complex_destroy.argtypes = [ctypes.c_void_p]
lib.complex_destroy.restype = None

lib.complex_get_real.argtypes = [ctypes.c_void_p]
lib.complex_get_real.restype = ctypes.c_double

lib.complex_get_imaginary.argtypes = [ctypes.c_void_p]
lib.complex_get_imaginary.restype = ctypes.c_double

lib.complex_add.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
lib.complex_add.restype = ctypes.c_void_p

lib.complex_to_string.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int]
lib.complex_to_string.restype = None

def complex_to_string_py(handle):
    buffer = ctypes.create_string_buffer(100)
    lib.complex_to_string(handle, buffer, 100)
    return buffer.value.decode('utf-8')

# Create complex numbers
a = lib.complex_create(2, 3)
b = lib.complex_create(4, 5)

# Perform addition
c = lib.complex_add(a, b)

# Print result
print(f"a + b = {complex_to_string_py(c)}")
print(f"Real part of a: {lib.complex_get_real(a)}")
print(f"Imaginary part of a: {lib.complex_get_imaginary(a)}")

lib.run_ble_scan()

# Cleanup
lib.complex_destroy(a)
lib.complex_destroy(b)
lib.complex_destroy(c)