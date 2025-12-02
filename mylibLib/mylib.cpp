#include "mylib.h"
#include "ble.hpp"
#include "complexNumbers.hpp"
#include <cstring>
#include <sstream>

#ifdef __cplusplus
extern "C" {
#endif

EXPORT ComplexNumberHandle complex_create(double real, double imaginary) {
    try {
        ComplexNumber *obj = new ComplexNumber(real, imaginary);
        return static_cast<ComplexNumberHandle>(obj);
    } catch (...) {
        return nullptr;
    }
}

EXPORT void complex_destroy(ComplexNumberHandle handle) {
    if (handle) {
        ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
        delete obj;
    }
}

EXPORT double complex_get_real(ComplexNumberHandle handle) {
    if (!handle)
        return 0.0;
    ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
    return obj->Re();
}

EXPORT double complex_get_imaginary(ComplexNumberHandle handle) {
    if (!handle)
        return 0.0;
    ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
    return obj->Im();
}

EXPORT void complex_set_real(ComplexNumberHandle handle, double real) {
    if (handle) {
        ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
        obj->setRe(real);
    }
}

EXPORT void complex_set_imaginary(ComplexNumberHandle handle, double imaginary) {
    if (handle) {
        ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
        obj->setIm(imaginary);
    }
}

EXPORT void complex_conjugate(ComplexNumberHandle handle) {
    if (handle) {
        ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
        obj->conjugate();
    }
}

EXPORT double complex_magnitude(ComplexNumberHandle handle) {
    if (!handle)
        return 0.0;
    ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
    return obj->magnitude();
}

EXPORT ComplexNumberHandle complex_add(ComplexNumberHandle a, ComplexNumberHandle b) {
    if (!a || !b)
        return nullptr;

    ComplexNumber *objA = static_cast<ComplexNumber *>(a);
    ComplexNumber *objB = static_cast<ComplexNumber *>(b);

    try {
        ComplexNumber result = *objA + *objB;
        return static_cast<ComplexNumberHandle>(new ComplexNumber(result.Re(), result.Im()));
    } catch (...) {
        return nullptr;
    }
}

EXPORT ComplexNumberHandle complex_subtract(ComplexNumberHandle a, ComplexNumberHandle b) {
    if (!a || !b)
        return nullptr;

    ComplexNumber *objA = static_cast<ComplexNumber *>(a);
    ComplexNumber *objB = static_cast<ComplexNumber *>(b);

    try {
        ComplexNumber result = *objA - *objB;
        return static_cast<ComplexNumberHandle>(new ComplexNumber(result.Re(), result.Im()));
    } catch (...) {
        return nullptr;
    }
}

EXPORT ComplexNumberHandle complex_multiply(ComplexNumberHandle a, ComplexNumberHandle b) {
    if (!a || !b)
        return nullptr;

    ComplexNumber *objA = static_cast<ComplexNumber *>(a);
    ComplexNumber *objB = static_cast<ComplexNumber *>(b);

    try {
        ComplexNumber result = *objA * *objB;
        return static_cast<ComplexNumberHandle>(new ComplexNumber(result.Re(), result.Im()));
    } catch (...) {
        return nullptr;
    }
}

EXPORT ComplexNumberHandle complex_divide(ComplexNumberHandle a, ComplexNumberHandle b) {
    if (!a || !b)
        return nullptr;

    ComplexNumber *objA = static_cast<ComplexNumber *>(a);
    ComplexNumber *objB = static_cast<ComplexNumber *>(b);

    try {
        ComplexNumber result = *objA / *objB;
        return static_cast<ComplexNumberHandle>(new ComplexNumber(result.Re(), result.Im()));
    } catch (...) {
        return nullptr;
    }
}

EXPORT void complex_to_string(ComplexNumberHandle handle, char *buffer, int buffer_size) {
    if (!handle || !buffer || buffer_size <= 0) {
        if (buffer && buffer_size > 0) {
            buffer[0] = '\0';
        }
        return;
    }

    ComplexNumber *obj = static_cast<ComplexNumber *>(handle);
    std::ostringstream oss;
    oss << *obj;

    std::string str = oss.str();
    if (static_cast<int>(str.length()) >= buffer_size) {
        str = str.substr(0, buffer_size - 1);
    }

    std::strncpy(buffer, str.c_str(), buffer_size);
    buffer[buffer_size - 1] = '\0';
}

EXPORT void run_ble_scan() {
    MyBle::run_ble_scan();
}

#ifdef __cplusplus
}
#endif