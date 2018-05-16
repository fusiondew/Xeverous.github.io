---
layout: article
---

Because numbers have finite range, some operations may result in values exceeding the limit.

TODO def box

<div class="note info">
#### Definition
<i class="fas fa-info-circle"></i>
Exceeding upper or bottom limit is named **overflow**.
</div>

## unsigned integer overflow

Sample demonstration of adding 8-bit max integer (255) and 1:

```
  1111 1111
+ 0000 0001
-----------
1 0000 0000
```

Value 256 can not fit into 8-bit byte. The first bit will be discarded. Thus, unsigned integer overflow wraps around when exceeding the range. It's like decimal counter which wraps from 999 to 0 because it has only 3 rotors.

TODO image of such rotor counter? https://en.wikipedia.org/wiki/Integer_overflow

Similarly, unsigned numbers wraps around when going below 0:

```
  (1) 0000 0000
-     0000 0001
---------------
      1111 1111
```

Overflow behaviour is intentional. In some computations, it's desired to wrap around and start over. Additionally, operations such as $255 + 1 - 1$ will yield back $255$, because both positive and negative overflows are exactly reverse.

## signed integer overflow

... is undefined behaviour. It's programmers responsibility to ensure that computations will not exceed the limit.

In realily, on all major arcitetures signed integer overflow behaves just like with unsigned integers - it wraps around, but while it is sometimes desirable to overflow $255$ to $0$, I haven't seen any place where $127 + 1 = -128$ would give any usability.

Specifying signed overflow as undefined behaviour at the language level has important effect - it allows multiple optimizations. For example, compiler can elide some `if`s because it knows some specific information about the result (more about it in optimization articles).

<div class="note pro-tip">
#### Signed or unsigned?
<i class="fas fa-star-exclamation"></i>
Do not use unsigned types just because something can not be negative. Use unsigned types only when you need wrap-around behaviour or bit-operations - for everything else use signed int, even if you don't need negative values.
</div>

## floating-point overflow

Floating-point types do not wrap around. Depending on the environment, you would either get positive/negative infinity or stop at the minimum/maximum possible value. This is well-defined behaviour.

## floating-point underflow

Here, the term means something different - it's the problem of too small values (very small fractions), not huge negative numbers.

Depending on the environment 2 things can happen:

- flush to 0 - the number is too small to represent, instead it's rounded to zero
- [denormal number](https://en.wikipedia.org/wiki/Denormal_number) representation - allows even smaller numbers, but may degrade performance
