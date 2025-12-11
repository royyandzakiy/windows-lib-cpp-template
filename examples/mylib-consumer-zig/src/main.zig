const std = @import("std");
const c = @cImport({
    @cInclude("../../generated_libs/mylibLib/include/mylibLib/mylib.h");
});

const BUFFER_SIZE = 100;

pub fn main() !void {
    // Create complex numbers
    const a = c.complex_create(2.0, 3.0);
    const b = c.complex_create(4.0, 5.0);

    if (a == null or b == null) {
        std.debug.print("Failed to create complex numbers\n", .{});
        return;
    }

    defer {
        c.complex_destroy(a);
        c.complex_destroy(b);
    }

    // Perform operations
    const c_result = c.complex_add(a, b);
    const d = c.complex_subtract(a, b);
    const e = c.complex_multiply(a, b);
    const f = c.complex_divide(a, b);

    defer {
        if (c_result != null) c.complex_destroy(c_result);
        if (d != null) c.complex_destroy(d);
        if (e != null) c.complex_destroy(e);
        if (f != null) c.complex_destroy(f);
    }

    // Print results
    var buffer: [BUFFER_SIZE]u8 = undefined;

    if (c_result != null) {
        c.complex_to_string(c_result, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a + b = {s}\n", .{str});
    }

    if (d != null) {
        c.complex_to_string(d, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a - b = {s}\n", .{str});
    }

    if (e != null) {
        c.complex_to_string(e, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a * b = {s}\n", .{str});
    }

    if (f != null) {
        c.complex_to_string(f, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("a / b = {s}\n", .{str});
    }

    // Demonstrate other operations
    std.debug.print("\nAdditional operations:\n", .{});

    // Get real and imaginary parts
    std.debug.print("Real part of a: {d}\n", .{c.complex_get_real(a)});
    std.debug.print("Imaginary part of a: {d}\n", .{c.complex_get_imaginary(a)});

    // Magnitude
    std.debug.print("Magnitude of a: {d}\n", .{c.complex_magnitude(a)});

    // Set new values
    c.complex_set_real(a, 10.0);
    c.complex_set_imaginary(a, 20.0);
    std.debug.print("After setting new values:\n", .{});
    std.debug.print("Real part of a: {d}\n", .{c.complex_get_real(a)});
    std.debug.print("Imaginary part of a: {d}\n", .{c.complex_get_imaginary(a)});

    // Conjugate
    const a_conj = c.complex_create(2.0, 3.0);
    defer if (a_conj != null) c.complex_destroy(a_conj);

    if (a_conj != null) {
        c.complex_conjugate(a_conj);
        c.complex_to_string(a_conj, &buffer, BUFFER_SIZE);
        const str = std.mem.sliceTo(&buffer, 0);
        std.debug.print("Conjugate of (2, 3): {s}\n", .{str});
    }
}
