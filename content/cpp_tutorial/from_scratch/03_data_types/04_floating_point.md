---
layout: article
---

## floating-point types

Types used to represent fractional numbers are named floating-point because they allow to shift the point - they are stored using scientific notation. For example: $-123 * 2^{-123}$.

Floating-point types consist of two parts - the mantisa $m$ and exponent $p$. Both themselves are signed integers. In computers the base is 2, so fractions are stored as $m * 2^p$, not $m * 10^p$.

Floating-point representations are standarized and practically all hardware adheres to [IEEE-754](https://en.wikipedia.org/wiki/IEEE_754).

C and C++ offer 3 floating-point types:

- `float` (aka single precision) - usually IEEE-754 32-bit floating-point type
- `double` (aka double precision) - usually IEEE-754 64-bit floating-point type
- `long double` (extended precision) - not necessarily any IEEE standard, on x86 and x86_64 architecture uses special 80-bit registers

Floating-point types may additionally support special values:

- negative/positive 0 - depending on the used signed representation, 0 may have 2 or even more representations
- negative/positive infinity - used when the value is too big to fit
- NaN (not-a-number) - used when function argument is out of domain - for example $log(-1) = NaN$ (logarithm argument can not be negative)
