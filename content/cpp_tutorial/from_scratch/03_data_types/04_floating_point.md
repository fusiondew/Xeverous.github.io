---
layout: article
---

## floating-point types

Types used to represent fractional numbers are named floating-point because they allow to shift the point - they are stored using scientific notation. For example: $-123 * 10^{-456}$.

Floating-point types consist of two parts - the **mantisa** $m$ and **exponent** $p$. Both themselves are signed integers. In computers the base is 2, so fractions are stored as $m * 2^p$, not $m * 10^p$.

For example, $416$ is stored as $13 * 2^5$ and $0,05078125$ as $13 * 2^{-8}$.

Floating-point representations are standarized and practically all hardware adheres to [IEEE-754](https://en.wikipedia.org/wiki/IEEE_754). This allows stable results regardless of used operating system or programming language.

On a hardware that satisfies IEEE-754 standard:

- 32 bit floating-point type uses
  - 1 bit for sign (+/-)
  - 23 bits for *mantisa*
  - 8 bits for *exponent*
- 64 bit floating-point type uses
  - 1 bit for sign (+/-)
  - 52 bits for *mantisa*
  - 11 bits for *exponent*

The bit sign affects mantisa, exponent does not need a bit sign because it's treated like it starts counting off not from 0 but some negative value. For example, all 0 bits on 32-bit type exponent means power -127. All bits 1 would mean power 128 (256 - 127).

C and C++ offer 3 floating-point types:

- `float` (single precision) - IEEE-754 32-bit floating-point type
- `double` (double precision) - IEEE-754 64-bit floating-point type
- `long double` (extended precision) - not necessarily any IEEE standard, on x86 and x86_64 architectures uses special 80-bit registers

Additional (non-standard) types may be offered by the compiler (eg `__float128` in GCC).

## consequences of representation

Floating-point math is approximate - it is mostly intended for physics where very huge or very small numbers come into play and strictly accurate results are not necessary.

**Example**

```c++
#include <iostream>
#include <iomanip> // input/output manipulation

int main()
{
    double x = 3.3;
    double y = 2.6;
    std::cout << std::setprecision(30) << x << "\n" << y << "\n";
}
```

~~~
3.29999999999999982236431605997
2.60000000000000008881784197001
~~~

`float` can represent fractions accurately roughly to 7 decimal digits and `double` - 15 decimal digits.

Floating-point math in computers suffers from the same issue as decimal notation: $1 \over 3$ can be at most approximated by $0.333...$. That's why in many computations you might get results like $0.99999998$ instead of $1$.

For this reason, in places where accuracy is necessary (eg finance) integers are used - monetary amounts like $1.5$ (in any currency that has denomination of 100) are stored as $150$.

Accurate calculators don't use floating-point arithmetic - they store fractions as 2 integers (counter and denominator) and perform arithmetic using the same method as humans.

## special values

Floating-point types may additionally support special values:

- infinity - numbers having all *exponent* bits set to `1` and mantisa to `0` are treated as "infinity" instead of their zero-to-the-power-of-very-large-number meaning. The existence of infinity helps to detect possible calculation errors.
- NaN (not a number) - represented similarly to infinity but also having non-zero *mantisa*. The purpose of NaNs is to indicate logic errors - for example, a logarithm can not take negative number as an argument, hence $log(-1) = NaN$

## other consequences

- Thanks to a separate bit used for sign, there are positive and negative infinities (and also NaNs)
- The value $0$ has many possible representations ($0 * 2^{anything}$, both signs)
- NaNs have multiple representations (all exponent bits 1 but any non-zero mantisa)

## in-depth presentation

Watch [CppCon 2015: John Farrier “Demystifying Floating Point"](https://www.youtube.com/watch?v=k12BJGSc2Nc) (roughly 40min if you skip questions time at the end). TODO embed.

## summary

- floating-point numbers in computers use approximate representation
- floating-point calculations have limited accuracy, but accuracy errors are orders of magnitude smaller than usual simulation model errors
- denormal numbers let to acheive greater precision but are multiple times slower (compilers have various options to change speed/accuracy tradeoff)
- there are multiple ways to round (I will later cover how to do them in C++)
  - to nearest integer
  - towards $0$
  - towards $+\infty$
  - towards $-\infty$
- various math functions round last bit towards even value which causes operations to sometimes increase and sometimes decrease the result - this reduces possibility of stacking bias when the same operation is repeated
- multiplication is usually faster and more precise than equivalent division
- epsilon - difference between `1.0` and the next possible representable number
- ulp - difference between 2 values that most closely represent given number
