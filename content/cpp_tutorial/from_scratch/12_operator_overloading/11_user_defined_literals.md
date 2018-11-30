---
layout: article
---

Just like language offers multiple suffixes for literals:

```c++
3.14f // float
1ul   // unsigned long
U'貓' // char32_t
```

It's possilble to define own literals to create objects of user-defined types (classes or enums).

## syntax

User-defined literals are created by "overloading" operator `""`.

```c++
class celcius { /* ... */ };

celcius operator""_C(long double x)
{
    return celcius(x);
}

// example use
const auto human_body_temperature = 36.6_C; // auto deduced to 'celcius'

// standard library example
const auto timeout = 1min + 30s; // equivalent to std::chrono::seconds(90)
// 1. constructs object std::chrono::minutes(1)
// 2. constructs object std::chrono::seconds(30)
// 3. applies overloaded operator+ which yields result in smaller units (here seconds)
```

There are some specific rules regarding this operator:

- User-defined literal suffixes must begin with `_` (does not apply to standard library).

This is just to avoid any name conflicts.

- User-defined suffixes have special parsing rules which in short:
    - cause suffixes not to be replaced by macros
    - allow suffixes to use names which would normally be keywords
    - allow suffixes to use reserved names

Thus, suffixes can start with `_` and an uppercase letter, just like in the example above. This rule is important, because it allows to use suffixes such as `_Hz` and `_Pa`.

TODO important block

**There must not be any space between literal and the suffix.**

```c++
kelvin operator""_K(long double x);  // ok: literal suffix '_K'
kelvin operator"" _K(long double x); // potential error: use of reserved identifier
```

```c++
// if/i/il are standard library suffixes for imaginary parts of complex numbers

std::complex<double> c = 1.1 + 2.2i; // complex number (real part: 1.1, imaginary: 2.2)

// float(3.0) + std::complex<float>(0, 4.0f) = std::complex<float>(3.0f, 4.0f)
auto z1 = 3.0f + 4.0if;
// this will not compile, 'if' will not be treated as suffix
auto z2 = 3.0f + 4.0 if;
```

- User-defined suffixes can not be used together with language-provided suffixes. There is just no way you could apply 2 suffixes at the same time.

This is why `std::complex` has 3 suffixes (for all 3 floating point types), not just one `i` with 3 overloads - it's not possible to input something different than `double`. Each suffix produces complex numbers of different type (`std::complex<float>`, `std::complex<double>`, `std::complex<long double>`).

- There is a fixed set for parameters for user-defined literals

```c++
// (1) any integer
(unsigned long long)
// (2) any floating point
(long double)
// (3) fallback for 2 above
(const char*)
// (4) characters
(char)
(wchar_t)
(char16_t)
(char32_t)
// (5) strings
(const char*, std::size_t)
(const wchar_t*, std::size_t)
(const char16_t*, std::size_t)
(const char32_t*, std::size_t)
```

Because it's impossible to mix language provided suffixes with uder-defined ones, it was decided to allow suffixes only for largest possible types. (3) is a fallback - (1) and (2) are prioritized in overload resolution but if required overload do not exist (3) will be called which inputs source code digits as characters.

Characters and strings use prefixes and they may be used together with user-defined suffixes. Note that overloads take also the length of the literal (length does not include null-terminating character).

## example literals

```c++
#include <iostream>

// fallback if there is no (unsigned long long) or (long double)
void operator""_print(const char* str)
{
    std::cout << str << '\n';
}

void operator""_print(const char* str, std::size_t n)
{
    std::cout << n << ": " << str << '\n';
}

void operator""_print(const wchar_t* str, std::size_t n)
{
    std::wcout << n << L"L: " << str << L'\n';
}

// overloads (2) and (1) are prioritized
void operator""_print(unsigned long long x)
{
    std::cout << "user-defined integer: " << x << '\n';
}

// convert degrees to radians (computers use radians in all trigonometric functions)
// constexpr for optimization - literals are known at compile time
constexpr long double operator""_deg(long double deg)
{
    return deg * 3.141592 / 180; // 360 degrees == 2π radians
}

class meter
{
public:
    constexpr meter(long double value = 0) : value(value) { }
private:
    long double value;
};

constexpr meter operator""_m(long double x)
{
    return meter(x);
}

constexpr meter operator""_km(long double x)
{
    return meter(x * 1000);
}

constexpr meter operator""_cm(long double x)
{
    return meter(x / 10);
}

int main()
{
    0x12'3A'BC_print;  // uses overload for integers (hex 123abc is 1194684 dec)
    0x123.ABCp0_print; // uses fallback overload (this is a floating-point hex)
    123_print;         // uses overload for integers
    123.456_print;     // uses fallback overload

    // auto m0 = 100_m; // error: no overload for integers and no fallback
    auto m1 = 100.0_m;
    auto m2 = 100.0_km;
    auto m3 = 100.0_cm;

    "abc"_print;  // uses _print(const char* str, std::size_t n)
    L"abc"_print; // uses _print(const wchar_t* str, std::size_t n)
    // U"abc"_print; // error: no _print(const char32_t* str, std::size_t n) (fallback does not apply for strings)
}
```

~~~
user-defined integer: 1194684
0x123.ABCp0
user-defined integer: 123
123.456
3: abc
3L: abc
~~~

## standard library literals

Standard library literals are in respective namespaces. They are not exposed in `std` namespace to avoid name conflicts (there are two `s` suffixes: `std::chrono::seconds` and `std::string`).

<div class="note info">
The feature of user-defined literals was introduced in C++11 but the first standard library ones in C++14.
</div>

```c++
#include <iostream>
#include <complex>
#include <string_view>

int main()
{
    { // C++14
        using namespace std::complex_literals;
        auto c = 1.0 + 1i; // std::complex<double>(1.0, 1.0)
        std::cout << "abs" << c << " = " << abs(c) << '\n';
    }

    { // C++14
        using namespace std::chrono_literals;
        auto lesson = 45min;   // std::chrono::minutes, uses integers
        auto halfmin = 0.5min; // std::chrono::minutes, uses floating-point
        std::cout << "one lesson is " << lesson.count() << " minutes\n"
                  << "half a minute is " << halfmin.count() << " minutes\n";
    }

    { // C++17
        using namespace std::string_view_literals;
        std::string_view s1 = "abc\0\0def"; // ctor that takes (const char*) - terminates on first null character
        std::string_view s2 = "abc\0\0def"sv; // literal that takes (const char*, std::size_t)
        std::cout << "s1: " << s1.size() << " \"" << s1 << "\"\n";
        std::cout << "s2: " << s2.size() << " \"" << s2 << "\"\n";
    }

    { // C++20
        using namespace std::chrono_literals;
        auto date = 2018y/8/17; // overloaded operator/ for year type and integers
        auto now = std::chrono::system_clock::now();
        auto today = std::chrono::year_month_day(std::chrono::sys_days(now));
        int leaps = 0;
        while (date.year() < today.year())
        {
            leaps += date.year().is_leap();
            date += std::chrono::years(1);
        }
        std::cout << "There have been " << leaps << " leap years since this post was written.\n";
    }
}
```

~~~
abs(1,1) = 1.41421
one lesson is 45 minutes
half a minute is 0.5 minutes
s1: 3 "abc"
s2: 8 "abc^@^@def"
~~~

## other notes

- there are no user-defined literal prefixes
- user-defined literal suffixes must be free functions (non-members) (they can be templates but there are [some restrictions](https://en.cppreference.com/w/cpp/language/user_literal#Literal_operators))
- default arguments are not allowed

## recommendation

User-defined literals are most useful for physical units and other well-known measures (eg date, time).
