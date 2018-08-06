---
layout: article
---

Because numbers have finite range, some operations may result in values exceeding the limit.

TODO def box

<div class="note info">

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

Value 256 can not fit into 8-bit byte. The first bit will be discarded. Thus, unsigned integer overflow wraps around when exceeding the range.

![odometer rollover](https://upload.wikimedia.org/wikipedia/commons/5/53/Odometer_rollover.jpg)

The same thing can be observed on this odometer which wraps from 999999 to 000000. If it had 7 rotors, it would be at 1000000 but since it has only 6 rotors, the leading 1 is lost.

Similarly, unsigned numbers wraps around when going below 0:

```
  (1) 0000 0000
-     0000 0001
---------------
      1111 1111
```

Overflow behaviour is intentional. In some computations (eg hashing, checksums, encryption), it's desired to wrap around. Additionally, operations such as $255 + 1 - 1$ will yield back $255$, because both positive and negative overflows are exactly reverse.

## signed integer overflow

... is undefined behaviour. It's programmers responsibility to ensure that computations will not exceed the limit.

In realily, on all major arcitetures signed integer overflow behaves just like with unsigned integers - it wraps around, but while it is sometimes desirable to overflow $255$ to $0$, overflow $127 + 1 = -128$ would not give any usability.

Specifying signed overflow as undefined behaviour at the language level has important effect - it allows multiple optimizations. With unsigned integers, `a + b` may be less than `a` (if it overflows) which may need additional instructions depending what further code does.

<div class="note pro-tip">

Do not use unsigned types just because something can not be negative. **Use unsigned types only when you need wrap-around behaviour or bit operations** - for everything else use signed integers, even if you don't need negative values.
</div>

## floating-point overflow

Floating-point types do not wrap around. Depending on the environment, you would either get positive/negative infinity or stop at the minimum/maximum possible value. This is well-defined behaviour.

## floating-point underflow

The problem of too small values (very small fractions near 0), not huge negative numbers.

Depending on the environment 2 things can happen:

- flush to 0 - the number is too small to represent, instead it's rounded to zero
- [denormal number](https://en.wikipedia.org/wiki/Denormal_number) representation - allows smaller numbers than usual representation but may degrade performance
