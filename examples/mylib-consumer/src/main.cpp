#include <print>
#include <array>
#include <stdio.h>
#include "mylibLib/mylib.h"

#define BUFFER_SIZE 100

struct ComplexDeleter {
    void operator()(ComplexNumberHandle h) const noexcept {
        if (h) complex_destroy(h);
    }
};

using ComplexPtr = std::unique_ptr<std::remove_pointer_t<ComplexNumberHandle>, ComplexDeleter>;

int main() {
    ComplexPtr a{ complex_create(2, 3) };
    ComplexPtr b{ complex_create(4, 5) };
    
    if (!a || !b) {
        std::println(stderr, "Failed to create complex numbers");
        return 1;
    }
    
    ComplexPtr c{ complex_add(a.get(), b.get()) };
    ComplexPtr d{ complex_subtract(a.get(), b.get()) };
    ComplexPtr e{ complex_multiply(a.get(), b.get()) };
    ComplexPtr f{ complex_divide(a.get(), b.get()) };
    
    std::array<char, BUFFER_SIZE> buffer{};
    
    if (c) {
        complex_to_string(c.get(), buffer.data(), buffer.size());
        std::println("a + b = {}", buffer.data());
    }
    
    if (d) {
        complex_to_string(d.get(), buffer.data(), buffer.size());
        std::println("a - b = {}", buffer.data());
    }
    
    if (e) {
        complex_to_string(e.get(), buffer.data(), buffer.size());
        std::println("a * b = {}", buffer.data());
    }
    
    if (f) {
        complex_to_string(f.get(), buffer.data(), buffer.size());
        std::println("a / b = {}", buffer.data());
    }
    
    // Demonstrate other operations
    std::println("\nAdditional operations:");
    
    // Get real and imaginary parts
    std::println("Real part of a: {}", complex_get_real(a.get()));
    std::println("Imaginary part of a: {}", complex_get_imaginary(a.get()));
    
    // Magnitude
    std::println("Magnitude of a: {}", complex_magnitude(a.get()));
    
    // Set new values
    complex_set_real(a.get(), 10.0);
    complex_set_imaginary(a.get(), 20.0);
    std::println("After setting new values:");
    std::println("Real part of a: {}", complex_get_real(a.get()));
    std::println("Imaginary part of a: {}", complex_get_imaginary(a.get()));
    
    // Cleanup
    complex_destroy(a.get());
    complex_destroy(b.get());
    if (c.get()) complex_destroy(c.get());
    if (d.get()) complex_destroy(d.get());
    if (e.get()) complex_destroy(e.get());
    if (f.get()) complex_destroy(f.get());

	run_ble_scan();
    
    return 0;
}