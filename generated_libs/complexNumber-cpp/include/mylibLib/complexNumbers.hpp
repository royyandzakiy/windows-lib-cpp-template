#pragma once

#include <cmath>
#include <iostream>
#include <limits>
#include <stdexcept>

class ComplexNumber {
  public:
    ComplexNumber(double real, double imaginary);
    ~ComplexNumber();

    double Re() const;
    double Im() const;
    void setRe(double real);
    void setIm(double imaginary);

    void conjugate();
    double magnitude() const;

    ComplexNumber operator+(const ComplexNumber &other);
    ComplexNumber operator-(const ComplexNumber &other);
    ComplexNumber operator*(const ComplexNumber &other);
    ComplexNumber operator/(const ComplexNumber &other);

    friend std::ostream &operator<<(std::ostream &os, const ComplexNumber &c);

  private:
    void isNan(double real, double imaginary) const;

  private:
    double _real;
    double _imaginary;
};