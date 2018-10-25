---
layout: article
---

<div class="note info">
This lesson requires understanding of the binary system.

It can be skipped as the knowledge gained from this lesson is needed only in very specific situations.
</div>

## binary operations

Should be performed on unsigned types - numbers are expected to behave as pure binary values. Sign bits would cause complications: in some cases, using bit operations on signed integers is implementation-defined behaviour or even undefined behaviour.

With smart use of these operators, one can set or test specific single bits in any integer. This is often done for *bitmasks*.

## bitwise operators

- AND: `a & b`
- OR: `a | b`
- XOR `a ^ b`

```c++
#include <iostream>
#include <bitset>

int main()
{
    unsigned a = 0b11101001;
    unsigned b = 0b01010101;

    // there is no std::bin but we can use bitset class to print numbers as binary
    std::cout << "a AND b: " << std::bitset<8>(a & b) << "\n"; // 1 where both are 1
    std::cout << "a  OR b: " << std::bitset<8>(a | b) << "\n"; // 1 where any is 1
    std::cout << "a XOR b: " << std::bitset<8>(a ^ b) << "\n"; // 1 where bits are different
}
```

~~~
a AND b: 01000001
a  OR b: 11111101
a XOR b: 10111100
~~~

## bit shifts

`<<` and `>>` perform left and right shifts of left operand by value of the right operand.

Bits that go outside range are lost and bits that fill blank space are `0`.

Bit shifts are undefined behaviour:

- when right operand is negative
- when right operand is positive but larger than the amount of bits in the left operand
- in some conbinations when the left operand is a signed integer (too complex to list)

Note that streams (including `std::cout`) use the same operator but through custom overloads - the built-in shift operators work only with numbers. It works with streams because the standard library explicitly overloads this operator for stream types.

```c++
#include <iostream>
#include <bitset>

int main()
{
    unsigned x = 0b00001100;

    std::cout << "shift left by 4: " << std::bitset<8>(x << 4) << "\n";
    std::cout << "shift left by 5: " << std::bitset<8>(x << 5) << "\n";
    std::cout << "shift left by 6: " << std::bitset<8>(x << 6) << "\n";
    std::cout << "shift right by 2: " << std::bitset<8>(x >> 2) << "\n";
    std::cout << "shift right by 3: " << std::bitset<8>(x >> 3) << "\n";
    std::cout << "shift right by 4: " << std::bitset<8>(x >> 4) << "\n";
}
```

~~~
shift left by 4: 11000000
shift left by 5: 10000000
shift left by 6: 00000000
shift right by 2: 00000011
shift right by 3: 00000001
shift right by 4: 00000000
~~~

## negation

Flips all bits in the given number. This operator is unary.

```c++
#include <iostream>
#include <bitset>

int main()
{
    unsigned x = 0b01001100;

    std::cout << "x : " << std::bitset<8>(x)  << "\n";
    std::cout << "~x: " << std::bitset<8>(~x) << "\n";
}
```

~~~
x : 01001100
~x: 10110011
~~~

## short versions

The only bit operation that has no short version is negation operator - it's unary.

TODO pre/code for table below

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>full expression</th>
                <th>short version</th>
                <th>description</th>
            </tr>
            <tr>
                <td>a = a & b</td>
                <td>a &= b</td>
                <td>AND a by b</td>
            </tr>
            <tr>
                <td>a = a | b</td>
                <td>a |= b</td>
                <td>OR a by b</td>
            </tr>
            <tr>
                <td>a = a ^ b</td>
                <td>a ^= b</td>
                <td>XOR a by b</td>
            </tr>
            <tr>
                <td>a = a << b</td>
                <td>a <<= b</td>
                <td>shift left a by b</td>
            </tr>
            <tr>
                <td>a = a >> b</td>
                <td>a >>= b</td>
                <td>shift right a by b</td>
            </tr>
        </tbody>
    </table>
</div>
