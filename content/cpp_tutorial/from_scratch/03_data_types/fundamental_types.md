---
layout: article
---

So far there were used only `int`ergers. Time to get more info about what fundamental types C++ provides and how they map to actual bits in the hardware.

## The void type

`void` is a type that has no possible values. It's a keyword indicating absence of data. You can't have variables of type `void` but it can be used in other contexts.

<details>
    <summary>Technicals</summary>
    <p>`void` is an incomplete type that can not be completed.
    
- a function can return `void` - in other words, such function does not return any data
- there are no references to `void`
- there are no arrays of `void`
- pointers to `void` are allowed</p>
</details>

## The boolean type

`bool` is a type capable of holding only 2 values: `false` and `true`. It's an equivalent to logic statements in math.

`bool` can also be viewed as a representation of a single bit (0 or 1), although it often occupies full byte (8 bits) or more memory - this is because in typical Von-Neumann architecture memory is addressed by bytes, not bits. Still, at the C++ language level `bool` can hold only 2 values.

## integers

TODO make more newbie-friendly (mb spoiler too mch technicals).

`int` is the most basic type. It represents a whole number in the most natural form for the target architecture.

### storage

Integers are stored in certain amount of bytes - this means that they have finite amount of bits and therefore they have bounds - you can't represent all possible numbers in them!

In decimal system, if you are given 3 digit space, you can't go beyond 999. Similarly, in the binary system, if you are given 10 digits, you can't go beyond 1111111111 (which is 1023). Any larger number would require more digits.

`int` can be surrounded by specific other keywords which modify the size and encoding. This can be used to change the possible value range and modify how it's interpreted.

Because plain binary numbers represent sums of consecutive powers of 2 (1, 2, 4, 8, 16, ...) there is no built-in way to represent negative numbers. Representations which allow this are named *signed representations*, they usually do this by treating first bit as +/- sign and some addiional changes in intepretation.

### encoding

`unsigned` - the integer is in it's simplest form, the underlying bits are treated with no modification (each more left-side bit is a bigger power of 2).

`signed` - there are multiple variations (one's complement, two's complement, offset binary, negative base). See [this article](https://en.wikipedia.org/wiki/Signed_number_representations) for more information.

The simplest signed representations are one's/two's complement, which sacrifice first bit for +/- sign but also have shifted/reversed negative numbers order.

#### examples:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>bits</th>
                <th>interpreted as unsigned</th>
                <th>interpreted as signed in ones's complement</th>
                <th>interpreted as signed in two's complement</th>
            </tr>
            <tr>
                <td>00000000</td>
                <td>0</td>
                <td>+0</td>
                <td>0</td>
            </tr>
            <tr>
                <td>00000001</td>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <td>00000010</td>
                <td>2</td>
                <td>2</td>
                <td>2</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>01111110</td>
                <td>126</td>
                <td>126</td>
                <td>126</td>
            </tr>
            <tr>
                <td>01111111</td>
                <td>127</td>
                <td>127</td>
                <td>127</td>
            </tr>
            <tr>
                <td>10000000</td>
                <td>128</td>
                <td>-127</td>
                <td>-128</td>
            </tr>
            <tr>
                <td>10000001</td>
                <td>129</td>
                <td>-126</td>
                <td>-127</td>
            </tr>
            <tr>
                <td>10000010</td>
                <td>130</td>
                <td>-125</td>
                <td>-126</td>
            </tr>
           <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
            <tr>
                <td>11111101</td>
                <td>253</td>
                <td>-2</td>
                <td>-3</td>
            </tr>
            <tr>
                <td>11111110</td>
                <td>254</td>
                <td>-1</td>
                <td>-2</td>
            </tr>
            <tr>
                <td>11111111</td>
                <td>255</td>
                <td>-0</td>
                <td>-1</td>
            </tr>
        </tbody>
    </table>
</div>

From the table above you can see that:

- unsigned integer has value range [0, 255]
- one's complement signed integer has value range [-127, 127]; 0 has two representations
- two's complement signed integer has value range [-128, 127]

The reverse order of negative numbers (in both complement encodings) allows some math optimizations.

Two's complement compared to one's complement is shifted by 1 - it avoids the problem of positive and negative 0.

All used architectures use the same unsigned representation.

Most widely used architectures use two's complement for signed representation.

#### More examples:

```
16-bit unsigned int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit signed   int representing decimal   2925: 0000 1011 0110 1101     (0)
16-bit unsigned int representing decimal  -2925: impossible to represent (1)
16-bit signed   int representing decimal  -2925: 1111 0100 1001 0011     (2)
16-bit unsigned int representing decimal 48 522: 1011 1101 1000 1010     (3)
16-bit signed   int representing decimal 48 522: impossible to represent (4)
```

- (0) The first 2 numbers are relatively small, and fit in both representations
- (1) -2925 (and all other negative numbers) can not be represented as unsigned integers, as there is no bit that would indicate +/- sign - all numbers are assumed to be non-negative.
- (2) the first bit is `1` which indicates that the number is negative, rest bits (`111 0100 1001 0011`) are two's completement representation - in this representation positive numbers look the same but negative numbers have bits flipped and added 1 to the last bit - compare (2) to (0)
- (3) the number is represented normally
- (4) the number can not be represented because the value itself needs 16 bits, but signed representation sacrifices 1 bit for +/- sign

The default representation is signed. This means that `int` is the same type as `signed int`.

### size

- `short` - makes integer occupy less bytes
- `long` - makes inteegr occupy more bytes

`long` can be used twice

The exact size of an integer is architecture dependent, but there are many strong guarantees. Additionally, C++ standard guarantess minum size (in reality it can be larger, but never smaller) for each type.

These are the actual sizes for both x86 and x86_64 architecture:

- `char` - 8 bits
- `short int` - 16 bits
- `int` - 32 bits
- `long int` - 32 bits (same as `int`)
- `long long int` - 64 bits

These are value ranges for integers of various lengths:

TODO table alignment

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>size (in bits)</th>
                <th>interpretation</th>
                <th>value range</th>
            </tr>
            <tr>
                <td rowspan="3">8</td>
                <td>unsigned</td>
                <td>0 - 255</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-127 - 127</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-128 - 127</td>
            </tr>
            <tr>
                <td rowspan="3">16</td>
                <td>unsigned</td>
                <td>0 - 65536</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-32767 - 32767</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-32768 - 32767</td>
            </tr>
            <tr>
                <td rowspan="3">32</td>
                <td>unsigned</td>
                <td>0 - 4'294'967'295</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-2'147'483'647 - 2'147'483'647</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-2'147'483'648 - 2'147'483'647</td>
            </tr>
            <tr>
                <td rowspan="3">64</td>
                <td>unsigned</td>
                <td>0 - 18'446'744'073'709'551'615</td>
            </tr>
            <tr>
                <td>signed (one's complement)</td>
                <td>-9'223'372'036'854'775'807 - 9'223'372'036'854'775'807</td>
            </tr>
            <tr>
                <td>signed (two's complement)</td>
                <td>-9'223'372'036'854'775'808 - 9'223'372'036'854'775'807</td>
            </tr>
        </tbody>
    </table>
</div>

### notation

`int` is optional if any other keyword is used. So `unsigned` or `long` is enough, you don't have to write `unsigned int` and `long int`.

The order of applied keywords doesn't mater, but it's recommended to write intuitively - `unsigned long long`, not `long int unsigned long`.

### fixed-width integers

`<cstdint>` supplies multiple fixed-with integer types or types with strict minimal size.

The full list is available on [reference page](https://en.cppreference.com/w/cpp/types/integer).

## character types

Characters are stored as small integers. The simplest encoding - ASCII occupies numbers 0 - 127 but encodes only latin letters, digits, simplest math symbols and some control (line break, tabs, space, etc). Multiple different encodings have been created (UTF-8, UTF-16, UTF-32, Unicode) to support other alphabets and more complex symbols. Obviously they require larger integers.

- `signed char` - signed 8-bit (or larger) integer
- `unsigned char` - unsigned 8-bit (or larger) integer
- `char` - one of the 2 above, treated as distinct type at language level; On x86 and x86_64 signed, on ARM and PowerPC unsigned
- `char16_t` - integer capable of holding any character from UTF-16 encoding
- `char32_t` - integer capable of holding any character from UTF-32 encoding
- `wchar_t` - type for wide characters; 32-bit integer on systems that support Unicode but 16-bit on Windows

<details>
    <summary>`char8_t`</summary>
    <p>There is a proposal for `char8_t` type, it gives improvements for more strict text handling and helps with Unicode but it breaks backwards compability. It's currently discussed what will be done in this manner - committee wants to push more breaking changes as the C++ language must go forward and the evolution sometimes requires breaking backwards compability.</p>
</details>

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

## other types

Compilers may also support other non-standard architecture-specific types, for exaple `__float128` and `__int128` found in GCC and Clang.


## Summary

Of course, you don't have to remember everything, here is the summary of crucial things:

- `void` represntes no data
- `bool` represents logic state, can only be `true` or `false`
- `int` represents whole numbers, can be `short` / `long` / `long long` and `signed` / `unsigned`
- `char` is an integer, but represents characters. There are no `long char`s - but types `char16_t`, `char32_t` and `wchar_t`
- `int` by default is signed
- `char` has no default signess, it's treated as distinct type at C++ language level (whether it is signed or not depends on the compiler and architecture)
- all 3 floating-point types (in range order: `float`, `double`, `long double`) are signed and can support non-numeric values

All of information from this lesson is available on [reference page](https://en.cppreference.com/w/cpp/language/types).

Note that in reality `int` or `char` is usually enough. Examples on this site rarely go beyond simplest fundamental types, $\pm2147483647$ range is fairly enough for most computations.

#### Question: How big-number computations are done?

They use various custom encodings which span across multiple bytes. Numbers are stored in arrays which can have large lengths, although each cell does not necessarily represent each digit (it's more complicated).

Of course, there are libraries which provide big-integer types.
