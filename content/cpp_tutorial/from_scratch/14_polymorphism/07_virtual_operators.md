---
layout: article
---

Sometimes you might have an urge to implement overloaded operators as virtual functions.

Previously it was stated that overloaded operators should keep their intuitive behaviour. **If you are unsure, use named functions instead.**

## rationale - binary operators

Technically, virtual operators are allowed (they are functions too) but there are important problems with them:

- if the overloaded operator is non-member, it obviously can't be virtual
- if the overloaded operator is a member, **it can lose associativity**

Now, what does it mean?

Assuming non-member implementation, an expression `a + b` is equivalent to `a.operator+(b)`. `b + a` is equivalent to `b.operator+(a)`.

See the problem? `a + b` and `b + a` resolve to 2 different functions. First will use virtual function of `a`, second will use virtual function of `b`.

Recall, why is member function implementation discouraged for many operators? Here, it's a similar problem. But now we do not only get inconsistent argument handling, but also inconsistent function execution. **Argument order impacts which function override is called.**

Generally, it's a bad idea to mix operator overloading and inheritance (even without virtual functions). Either go inheritance and use named functions or go for 1 type with well-specified invariants.

## rationale - unary operators

This is a pretty grey area. Personally, I haven't encountered any situation for making virtual unary operators. I would stick to general recommendation - just don't. Use named functions.

## rationale - operator ()

No strong opinions, but `operator()` might be treated like a function which name is `""` (empty string). Given how this operator is used within some templates, it might not be a bad idea. All in all it looks like a function, just with no name.

I would be thankful if anyone could post some arguments for/against virtual `()`.

## streams

`<<` and `>>` for text I/O are global operators. We can not make global functions virtual, but there is a simple trick to workaround it:

```c++
std::ostream& operator<<(std::ostream& os, const animal& a)
{
    a.print(os); // can be virtual
    return os;
}
```

This approach works intuitively and has no drawbacks. But don't use it for other binary operators - you will need first a virtual member function for each operator. Wrapping these functions inside binary operators would cause confusion due to broken associativity.

In the case of `<<` and `>>` associativity is not a problem because this operators are chained, so we always expect stream on the left and user-class on the right.

## summary

<div class="note pro-tip">
Do not mix operator overloading and inheritance.

Exception: stream operators and `()` if you have a good reason.
</div>
