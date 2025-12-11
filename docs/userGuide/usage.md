\page usage Usage

The following shows example use cases for the complex number library:


```cpp
#include <cassert>
#include "complexNumberLib/complexNumber.hpp"

int main() {
  ComplexNumber a(3.0, 4.0);
  ComplexNumber b(1.8, 5.3);

  assert(a.magnitude() == 5.0);

  a.conjugate();
  assert(a.Re() == 3.0);
  assert(a.Im() == -4.0);

  auto c1 = a + b;
  auto c2 = a - b;
  auto c2 = a * b;
  auto c2 = a / b;

  return 0;
}
```