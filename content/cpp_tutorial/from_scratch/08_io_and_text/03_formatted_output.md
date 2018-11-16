---
layout: article
---

C++ has distinguishes between formatted and unformatted input/output.

All standard streams can do both formatted and unformatted I/O. Operators `<<` and `>>` always do formatted I/O. Unformatted and more formatted output options are available through stream member functions.

Now, what does it mean?

- unformatted I/O always behaves exaclty the same
- formatted I/O depends on object's state

## changing state

Standard library offers stream manipulators which when inserted to a stream, change its state which affects formatted output. Multiple state flags of different kinds may be on at the same time.

To manipulate streams you need to `#include <iomanip>`.

### bool as alpha

Enable or disable printing words for boolean values. Default: off.

```c++
std::cout << std::boolalpha   << true << " " << false << "\n";
std::cout << std::noboolalpha << true << " " << false << "\n";
```

~~~
true false
1 0
~~~

### show positive

Enable or disable plus sign in output for positive numbers. Default: disabled.

```c++
std::cout << std::showpos   << 2 << "\n";
std::cout << std::noshowpos << 2 << "\n";
```

~~~
+2
2
~~~

For negative numbers minus sign is always printed.

Note: floating-point `0` may exist both as positive and negative (sign bit is independent).

### number base

```c++
std::cout << std::showbase; // enable printing base prefix (0 for octal, 0x for hex)
std::cout << "in octal       (base  8): " << std::oct << 42 << "\n";
std::cout << "in decimal     (base 10): " << std::dec << 42 << "\n";
std::cout << "in hexadecimal (base 16): " << std::hex << 42 << "\n";

std::cout << "\n";

std::cout << std::noshowbase; // disable printing base prefix
std::cout << "in octal       (base  8): " << std::oct << 42 << "\n";
std::cout << "in decimal     (base 10): " << std::dec << 42 << "\n";
std::cout << "in hexadecimal (base 16): " << std::hex << 42 << "\n";
```

~~~
in octal       (base  8): 052
in decimal     (base 10): 42
in hexadecimal (base 16): 0x2a

in octal       (base  8): 52
in decimal     (base 10): 42
in hexadecimal (base 16): 2a
~~~

Defaults are decimal and no base prefix.

There is no flag to print binary numbers. For bases other than listed here, more advanced functions need to be used.

### uppercase

Use uppercase for numerical characters. Default: off.

```c++
std::cout << std::hex << std::showbase;
std::cout << std::uppercase   << 0xdeadbeef << "\n";
std::cout << std::nouppercase << 0xdeadbeef << "\n";
```

~~~
0XDEADBEEF
0xdeadbeef
~~~

This setting does not affect printing text in any way.

### adjustment and width

You can set minimal width of printed values. By default blank space is filled with spaces - you can also set custom fill character. **Width setting is not permanent - it works only for the next formatted I/O operation.**

Additionally, by setting adjustment the printed text may be shifted horizontally if it does not exceed minimum width.

```c++
// adjust left and fill with *
std::cout << std::left << std::setfill('*');
for (long i = 1; i < 1000000000; i *= 10)
	std::cout << std::setw(8) << i << "\n"; // setw in loop because it's not permanent

std::cout << "\n";

// adjust right and fill with .
std::cout << std::right << std::setfill('.');
for (long i = 1; i < 1000000000; i *= 10)
	std::cout << std::setw(8) << i << "\n";

std::cout << "\n";

// use hex base and print prefix
// adjust numbers to the right but other characters to the left
// fill with _
std::cout << std::hex << std::showbase;
std::cout << std::internal << std::setfill('_');
for (long i = 1; i < 1000000000; i *= 10)
	std::cout << std::setw(8) << i << "\n";
```

~~~
1*******
10******
100*****
1000****
10000***
100000**
1000000*
10000000
100000000

.......1
......10
.....100
....1000
...10000
..100000
.1000000
10000000
100000000

0x_____1
0x_____a
0x____64
0x___3e8
0x__2710
0x_186a0
0x_f4240
0x989680
0x5f5e100
~~~

### custom floating-point precision

You can set custom precision of floating-point numbers. Combine with width for pretty print.

```c++
constexpr double pi = 3.1415926535897932384626433;
std::cout << std::setprecision(15);
for (double x = 0.0; x < 2 * pi; x += pi / 18.0)
	std::cout << std::sin(x) << "\n"; // requires <cmath>
```

~~~
0
0.17364817766693
0.342020143325669
0.5
0.642787609686539
0.766044443118978
0.866025403784439
0.939692620785908
0.984807753012208
1
0.984807753012208
0.939692620785908
0.866025403784439
0.766044443118978
0.64278760968654
0.500000000000001
0.34202014332567
0.173648177666932
1.45473230946492e-15
-0.173648177666929
-0.342020143325667
-0.499999999999998
-0.642787609686538
-0.766044443118977
-0.866025403784437
-0.939692620785908
-0.984807753012208
-1
-0.984807753012209
-0.93969262078591
-0.86602540378444
-0.76604444311898
-0.642787609686542
-0.500000000000004
-0.342020143325673
-0.173648177666935
-4.6858214583301e-15
~~~

You can observe limited precision of floating point numbers: we have hit both negative and positive $1$ of sine function but instead of 2 $0$s there are 2 very small fractions (likely denormal numbers) and from all four halfs only one is ideal.

Setting precision beyond supported by underlying type can result in characteristic output:

~~~
0.499999999999999944488848768742
0.50000000000000077715611723761
-0.500000000000003552713678800501
~~~

### show point

Enable or disable printing point and decimal fraction digits when not necessary. Default: off.

```c++
std::cout << std::showpoint   << 1.0 << " " << 12.34 << "\n";
std::cout << std::noshowpoint << 1.0 << " " << 12.34 << "\n";
```

~~~
1.00000 12.3400
1 12.34
~~~

This setting is locale-dependent.

### floating-point formats

```c++
std::cout << "0.001 in fixed:      " << std::fixed        << 0.001 << "\n"; // ignores showpoint
std::cout << "0.001 in scientific: " << std::scientific   << 0.001 << "\n";
std::cout << "0.001 in hexfloat:   " << std::hexfloat     << 0.001 << "\n"; // ignores precision
std::cout << "0.001 in default:    " << std::defaultfloat << 0.001 << "\n"; // this is the default

std::cout << "\n";

std::cout << " 1000 in fixed:      " << std::fixed        << 1000.0 << "\n";
std::cout << " 1000 in scientific: " << std::scientific   << 1000.0 << "\n";
std::cout << " 1000 in hexfloat:   " << std::hexfloat     << 1000.0 << "\n";
std::cout << " 1000 in default:    " << std::defaultfloat << 1000.0 << "\n";
```

~~~
0.001 in fixed:      0.001000
0.001 in scientific: 1.000000e-03
0.001 in hexfloat:   0x1.0624dd2f1a9fcp-10
0.001 in default:    0.001

 1000 in fixed:      1000.000000
 1000 in scientific: 1.000000e+03
 1000 in hexfloat:   0x1.f4p+9
 1000 in default:    1000
~~~

## exercise

What does the following program print?

```c++
#include <iostream>
#include <iomanip>

int main()
{
    std::cout << std::showpos;
    std::cout << 0 << " " << -0 << "\n";
    std::cout << 0.0 << " " << -0.0 << "\n";
}
```

<details>
<summary>answer</summary>
<p markdown="block">

~~~
+0 +0
+0 -0
~~~
</p>
</details>

<details>
<summary>explanation</summary>
<p markdown="block">
Integers have only one representation of 0 and it is regarded as positive (in true mathematical sense 0 is neither positive nor negative). Negating integer 0 does nothing.

Floating points allow many special values including not-a-number and infinities. There is also a separate bit for sign so any value can be both positive and negative, including 0.
</p>
</details>
