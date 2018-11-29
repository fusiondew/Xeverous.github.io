---
layout: article
---

By default, `<<` and `>>` perform bitshifts on the numeric operands: `0b00000001 << 4 == 0b00010000`.

When overloaded, they are usually used for text output. You can then print objects of custom type just like many other types that streams already accept.

```c++
// inside class
friend std::ostream& operator<<(std::ostream& os, integer in);

// outside
std::ostream& operator<<(std::ostream& os, integer in)
{
    // os << in.x;
    // return os;
    return os << in.x; // (shorter version)
}
```

`std::ostream` is the standard **o**utput **stream** class. `std::cout` is a global object of this type. Various string streams can also be treated as output streams.

The function returns reference to allow operator chaining. Stream is taken by non-const reference because expression `os << in.x` will modify stream object. Note that we do not implement data-to-text convertion here, we just reuse stream's operator `<<` that takes an `int`.

Similarly, we reuse **i**nput **stream**'s operator `>>` taking an `int`:

```c++
std::istream& operator>>(std::istream& is, integer& in)
{
    return is >> in.x;
}
```

`std::cin` is a global object of this type, various string/file streams can be used too.

## <<= and >>=

Overloading these operators makes only sense if `<<` and `>>` are implemented as mathematical operations. If the type implements `<<` and `>>` as text output, `<<=` and `>>=` should not be overloaded - there is nothing intuitive to do here and it would only cause confusion.

`<<=` and `>>=` when needed, are implemented like `+=` (non-const member functions).

## exercise

What is wrong with the following implementation?

```c++
std::ostream& operator<<(std::ostream& os, const person& p)
{
    return std::cout << p.name;
}
```

<details>
<summary>answer</summary>
<p markdown="block">

`os` is not used (would generate a compiler warning). The function is wrong because it always calls the standard character output stream, not the stream provided as an argument</p>
</details>
