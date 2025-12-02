#include "mylibLib/mylib.h"
#include <stdio.h>

#define BUFFER_SIZE 100

int main() {
    // Create complex numbers
    ComplexNumberHandle a = complex_create(2, 3);
    ComplexNumberHandle b = complex_create(4, 5);

    if (!a || !b) {
        fprintf(stderr, "Failed to create complex numbers\n");
        return 1;
    }

    // Perform operations
    ComplexNumberHandle c = complex_add(a, b);
    ComplexNumberHandle d = complex_subtract(a, b);
    ComplexNumberHandle e = complex_multiply(a, b);
    ComplexNumberHandle f = complex_divide(a, b);

    // Print results
    char buffer[BUFFER_SIZE];

    if (c) {
        complex_to_string(c, buffer, BUFFER_SIZE);
        printf("a + b = %s\n", buffer);
    }

    if (d) {
        complex_to_string(d, buffer, BUFFER_SIZE);
        printf("a - b = %s\n", buffer);
    }

    if (e) {
        complex_to_string(e, buffer, BUFFER_SIZE);
        printf("a * b = %s\n", buffer);
    }

    if (f) {
        complex_to_string(f, buffer, BUFFER_SIZE);
        printf("a / b = %s\n", buffer);
    }

    // Demonstrate other operations
    printf("\nAdditional operations:\n");

    // Get real and imaginary parts
    printf("Real part of a: %f\n", complex_get_real(a));
    printf("Imaginary part of a: %f\n", complex_get_imaginary(a));

    // Magnitude
    printf("Magnitude of a: %f\n", complex_magnitude(a));

    // Set new values
    complex_set_real(a, 10.0);
    complex_set_imaginary(a, 20.0);
    printf("After setting new values:\n");
    printf("Real part of a: %f\n", complex_get_real(a));
    printf("Imaginary part of a: %f\n", complex_get_imaginary(a));

    // Cleanup
    complex_destroy(a);
    complex_destroy(b);
    if (c)
        complex_destroy(c);
    if (d)
        complex_destroy(d);
    if (e)
        complex_destroy(e);
    if (f)
        complex_destroy(f);

    return 0;
}