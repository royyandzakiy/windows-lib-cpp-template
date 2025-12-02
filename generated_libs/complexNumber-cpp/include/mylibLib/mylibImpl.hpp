#pragma once

#include <iostream>
#include <cmath>
#include <stdexcept>
#include <limits>

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

/**
 * @brief If instead you want to make this to be exported. 
 * then you can just delete the ComplexNumbersWrapper.hpp/cpp
 * 
 
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

#include <iostream>
#include <cmath>
#include <stdexcept>
#include <limits>

class ComplexNumber {
public:
	EXPORT ComplexNumber(double real, double imaginary);
	EXPORT ~ComplexNumber();

	EXPORT double Re() const;
	EXPORT double Im() const;
  EXPORT void setRe(double real);
  EXPORT void setIm(double imaginary);

  EXPORT void conjugate();
  EXPORT double magnitude() const;
	
	EXPORT ComplexNumber operator+(const ComplexNumber &other);
  EXPORT ComplexNumber operator-(const ComplexNumber &other);
  EXPORT ComplexNumber operator*(const ComplexNumber &other);
  EXPORT ComplexNumber operator/(const ComplexNumber &other);

  EXPORT friend std::ostream &operator<<(std::ostream &os, const ComplexNumber &c);

private:
  void isNan(double real, double imaginary) const;
	
private:
	double _real;
	double _imaginary;
};

 * 
 */