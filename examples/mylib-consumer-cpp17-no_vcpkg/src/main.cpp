#include "mylibLib/mylib.h"
#include <array>
#include <cstdio>
#include <iostream>
#include <memory>

#define BUFFER_SIZE 100

struct ComplexDeleter {
    void operator()(ComplexNumberHandle h) const noexcept {
        if (h)
            complex_destroy(h);
    }
};

using ComplexPtr = std::unique_ptr<std::remove_pointer_t<ComplexNumberHandle>, ComplexDeleter>;

int main() {
    ComplexPtr a{complex_create(2, 3)};
    ComplexPtr b{complex_create(4, 5)};

    if (!a || !b) {
        std::cerr << "Failed to create complex numbers" << std::endl;
        return 1;
    }

    ComplexPtr c{complex_add(a.get(), b.get())};
    ComplexPtr d{complex_subtract(a.get(), b.get())};
    ComplexPtr e{complex_multiply(a.get(), b.get())};
    ComplexPtr f{complex_divide(a.get(), b.get())};

    std::array<char, BUFFER_SIZE> buffer{};

    if (c) {
        complex_to_string(c.get(), buffer.data(), buffer.size());
        std::cout << "a + b = " << buffer.data() << std::endl;
    }

    if (d) {
        complex_to_string(d.get(), buffer.data(), buffer.size());
        std::cout << "a - b = " << buffer.data() << std::endl;
    }

    if (e) {
        complex_to_string(e.get(), buffer.data(), buffer.size());
        std::cout << "a * b = " << buffer.data() << std::endl;
    }

    if (f) {
        complex_to_string(f.get(), buffer.data(), buffer.size());
        std::cout << "a / b = " << buffer.data() << std::endl;
    }

    // Demonstrate other operations
    std::cout << "\nAdditional operations:" << std::endl;

    // Get real and imaginary parts
    std::cout << "Real part of a: " << complex_get_real(a.get()) << std::endl;
    std::cout << "Imaginary part of a: " << complex_get_imaginary(a.get()) << std::endl;

    // Magnitude
    std::cout << "Magnitude of a: " << complex_magnitude(a.get()) << std::endl;

    // Set new values
    complex_set_real(a.get(), 10.0);
    complex_set_imaginary(a.get(), 20.0);
    std::cout << "After setting new values:" << std::endl;
    std::cout << "Real part of a: " << complex_get_real(a.get()) << std::endl;
    std::cout << "Imaginary part of a: " << complex_get_imaginary(a.get()) << std::endl;

    // Cleanup - Note: The unique_ptr will automatically destroy these,
    // but keeping your manual cleanup for compatibility
    complex_destroy(a.get());
    complex_destroy(b.get());
    if (c.get())
        complex_destroy(c.get());
    if (d.get())
        complex_destroy(d.get());
    if (e.get())
        complex_destroy(e.get());
    if (f.get())
        complex_destroy(f.get());

    run_ble_scan();

    return 0;
}