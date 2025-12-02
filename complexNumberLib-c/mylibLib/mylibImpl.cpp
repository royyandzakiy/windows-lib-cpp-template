#include "mylibLib/mylibImpl.hpp"

ComplexNumber::ComplexNumber(double real, double imaginary) : _real(real), _imaginary(imaginary) {
    isNan(real, imaginary);
}

ComplexNumber::~ComplexNumber() = default;

double ComplexNumber::Re() const {
    return _real;
}
double ComplexNumber::Im() const {
    return _imaginary;
}
void ComplexNumber::setRe(double real) {
    _real = real;
}
void ComplexNumber::setIm(double imaginary) {
    _imaginary = imaginary;
}

void ComplexNumber::conjugate() {
    _imaginary *= -1.0;
}
double ComplexNumber::magnitude() const {
    return std::sqrt(std::pow(_real, 2) + std::pow(_imaginary, 2));
}

ComplexNumber ComplexNumber::operator+(const ComplexNumber &other) {
    isNan(_real, _imaginary);
    isNan(other._real, other._imaginary);

    ComplexNumber c(0, 0);
    c._real = _real + other._real;
    c._imaginary = _imaginary + other._imaginary;
    return c;
}

ComplexNumber ComplexNumber::operator-(const ComplexNumber &other) {
    isNan(_real, _imaginary);
    isNan(other._real, other._imaginary);

    ComplexNumber c(0, 0);
    c._real = _real - other._real;
    c._imaginary = _imaginary - other._imaginary;
    return c;
}

ComplexNumber ComplexNumber::operator*(const ComplexNumber &other) {
    isNan(_real, _imaginary);
    isNan(other._real, other._imaginary);

    ComplexNumber c(0, 0);
    c._real = _real * other._real - _imaginary * other._imaginary;
    c._imaginary = _real * other._imaginary + _imaginary * other._real;
    return c;
}

ComplexNumber ComplexNumber::operator/(const ComplexNumber &other) {
    isNan(_real, _imaginary);
    isNan(other._real, other._imaginary);

    double denominator = other._real * other._real + other._imaginary * other._imaginary;
    if (std::abs(denominator) < std::numeric_limits<double>::epsilon())
        throw std::runtime_error("Complex number division by zero");

    ComplexNumber c(0, 0);
    c._real = (_real * other._real + _imaginary * other._imaginary) / denominator;
    c._imaginary = (_imaginary * other._real - _real * other._imaginary) / denominator;
    return c;
}

std::ostream &operator<<(std::ostream &os, const ComplexNumber &c) {
    os << "(" << c._real << ", " << c._imaginary << ")";
    return os;
}

void ComplexNumber::isNan(double real, double imaginary) const {
    if (std::isnan(real) || std::isnan(imaginary))
        throw std::runtime_error("Complex number is NaN");
}
