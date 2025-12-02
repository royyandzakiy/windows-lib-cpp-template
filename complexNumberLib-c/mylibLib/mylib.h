#pragma once

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
    #if defined(COMPILEDLL)
        #define EXPORT __declspec(dllexport)
    #elif defined(COMPILELIB)
        #define EXPORT
    #else
        #define EXPORT __declspec(dllimport)
    #endif
#else
    #define EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Opaque handle type for ComplexNumber
typedef void* ComplexNumberHandle;

// Creation and destruction
EXPORT ComplexNumberHandle complex_create(double real, double imaginary);
EXPORT void complex_destroy(ComplexNumberHandle handle);

// Getters
EXPORT double complex_get_real(ComplexNumberHandle handle);
EXPORT double complex_get_imaginary(ComplexNumberHandle handle);

// Setters
EXPORT void complex_set_real(ComplexNumberHandle handle, double real);
EXPORT void complex_set_imaginary(ComplexNumberHandle handle, double imaginary);

// Operations
EXPORT void complex_conjugate(ComplexNumberHandle handle);
EXPORT double complex_magnitude(ComplexNumberHandle handle);

// Arithmetic operations (returns new ComplexNumber)
EXPORT ComplexNumberHandle complex_add(ComplexNumberHandle a, ComplexNumberHandle b);
EXPORT ComplexNumberHandle complex_subtract(ComplexNumberHandle a, ComplexNumberHandle b);
EXPORT ComplexNumberHandle complex_multiply(ComplexNumberHandle a, ComplexNumberHandle b);
EXPORT ComplexNumberHandle complex_divide(ComplexNumberHandle a, ComplexNumberHandle b);

// String representation
EXPORT void complex_to_string(ComplexNumberHandle handle, char* buffer, int buffer_size);

#ifdef __cplusplus
}
#endif