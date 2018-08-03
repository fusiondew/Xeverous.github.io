---
layout: article
---

Constant values written in the code are **literals**.

```c++
123   // integer literal
4.5   // floating-point literal
'a'   // character literal
"abc" // string literal
```

Note that characters use single quotes while strings use double quotes.

Literals themselves also have types:

```c++
123    // int
123u   // unsigned int
123ul  // unsigned long int
123ull // unsigned long long int
```

## integers

possible suffixes:

- `u` - makes literal type `unsigned`
- `l` - makes literal type `long` (can be used twice)
- (there is no suffix for `short`)

Case of both doesn't matter with the exception that `long long` must be either `ll` or `LL` (`lL` and `Ll` will not work).

Integers may be written using various numeric systems:

```c++
// all represent the same value
int decimal     = 42;       // base 10 (digits 0 - 9)
int octal       = 052;      // base 8  (digits 0 - 7)
int hexadecimal = 0x2a;     // base 16 (digits 0 - 9 and a - f or A - F)
int heXadecimal = 0X2A;     // as above
int binary      = 0b101010; // base 2 (digits 0 and 1), requires C++14
```

Since C++14 numbers may use single quotes to separate digit groups:

```c++
int x1 = 123456789;
int x2 = 123'456'789;
int x3 = 1'2345'6'7'89; // this one is also valid
```

## floating-point

- `f` or `F` - `float`
- no suffix - `double`
- `l` or `L` - `long double`

Floating point literals support various formats, including expotential notation and hexadecimal fractions. When using dot (`.`) one digit sequence is optional.

```c++
42.0 // 42, double
42.f // 42, float
3e10 // 30000000000, double
123.456e-67 // 123.456 * 10^(-67)
.1E4l // 1000, long double
0x10.1p2f // 64.25, float (uses hexadecimal digits)
0x1.2p3 // 9 (1.125 * 2^3), double (uses hexadecimal digits)
```

Obviously the best is to write intuitive code and use the first format if possible.

## characters

Characters are stored as numbers. It's up to the encoding to determine what values are rendered to what characters.

Character literals use prefixes. They are case-sensitive.

It's possible to write character value directly (in hexadecimal system) by using `\U` escape.

```c++
'a' // char, ASCII encoding
u'貓' // char16_t, supports only BMP part of Unicode (UTF-16)
U'🍌' // char32_t, supports any Unicode character (UTF-32)
U'\U0001f34c' // same as line above, value written directly
L'β' // wchar_t, encoding and value implementation-defined

// this form requires C++17
u8'a' // char, UTF-8 encoding (single byte characters from ISO 10646)

// this form is not really used, compilers give a warning about such code because multiple characters are usually a typo
'abc' // int, value implementation-defined
```

It's really rare to have a need to write characters directly in the code - programs offering various translations usually load language-specific text from files.

For this reason, all example programs that will manipulate characters will use only the simplest `'a'` with no prefix.

## strings

Analogically to characters, but they use `"` instead of `'`. 

String literals are character sequences - they can hold multiple characters.

Like ordinary characters, strings can be saved to variables (actually arrays) but arrays were not covered yet.

```c++
 "abc" // array of char
L"abc" // array of wchar_t
u"abc" // array of char16_t
U"abc" // array of char32_t
```

## other literals

It's worth noting that not all literals have to be letters or digits - some literals are keywords.

You already know 2 of them: `true` and `false` are literals of type `bool`.

Later you will be presented 1 more keyword literal and learn how to define custom literals.
