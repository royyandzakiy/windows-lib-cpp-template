const std = @import("std");
const mylib = @cImport({
    @cInclude("../../generated_libs/mylibLib/include/mylibLib/mylib.h");
});

const BUFFER_SIZE = 100;

pub fn main() !void {
    // Create complex numbers
    const a = mylib.complex_create(2.0, 3.0);
    const b = mylib.complex_create(4.0, 5.0);

    if (a == null or b == null) {
        std.debug.print("Failed to create complex numbers\n", .{});
        return;
    }

    defer {
        mylib.complex_destroy(a);
        mylib.complex_destroy(b);
    }

    // Perform operations
    const c_result = mylib.complex_add(a, b);
    const d = mylib.complex_subtract(a, b);
    const e = mylib.complex_multiply(a, b);
    const f = mylib.complex_divide(a, b);

    defer {
        if (c_result != null) mylib.complex_destroy(c_result);
        if (d != null) mylib.complex_destroy(d);
        if (e != null) mylib.complex_destroy(e);
        if (f != null) mylib.complex_destroy(f);
    }

    // Print results
    var buffer: [BUFFER_SIZE]u8 = undefined;

    if (c_result != null) {
        mylib.complex_to_string(c_result, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a + b = {s}\n", .{str});
    }

    if (d != null) {
        mylib.complex_to_string(d, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a - b = {s}\n", .{str});
    }

    if (e != null) {
        mylib.complex_to_string(e, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a * b = {s}\n", .{str});
    }

    if (f != null) {
        mylib.complex_to_string(f, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a / b = {s}\n", .{str});
    }

    // Demonstrate other operations
    std.debug.print("\nAdditional operations:\n", .{});

    // Get real and imaginary parts
    std.debug.print("Real part of a: {d}\n", .{mylib.complex_get_real(a)});
    std.debug.print("Imaginary part of a: {d}\n", .{mylib.complex_get_imaginary(a)});

    // Magnitude
    std.debug.print("Magnitude of a: {d}\n", .{mylib.complex_magnitude(a)});

    // Set new values
    mylib.complex_set_real(a, 10.0);
    mylib.complex_set_imaginary(a, 20.0);
    std.debug.print("After setting new values:\n", .{});
    std.debug.print("Real part of a: {d}\n", .{mylib.complex_get_real(a)});
    std.debug.print("Imaginary part of a: {d}\n", .{mylib.complex_get_imaginary(a)});

    // Conjugate
    const a_conj = mylib.complex_create(2.0, 3.0);
    defer if (a_conj != null) mylib.complex_destroy(a_conj);

    if (a_conj != null) {
        mylib.complex_conjugate(a_conj);
        mylib.complex_to_string(a_conj, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("Conjugate of (2, 3): {s}\n", .{str});
    }

    mylib.run_ble_scan();
}
