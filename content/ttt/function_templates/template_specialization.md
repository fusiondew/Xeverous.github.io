---
layout: article
---

# function template specialization

### deduction traps - part 2

Suppose we have a very simple function:

```c++
template <typename T>
T duplicate(const T& t)
{
    return t * 2;
}
```

It works for any numeric type, because all of them support binary `operator*`. However, there is 1 thing worth to notice: the expression `t * 2` may use implicit convertions. If `T` is different from `int`, `2` will likely be cast to that type (unsigned integers and floating point numbers have higher priority) and perform the math on the promoted type.

The problem arises if the implicit convertion chooses `2` to have higher priority. This won't happen for integers, but if `2.0` was used things would likely be calculated on `double` type, and then cast back to the original type because function returns `T`.

There is a good practice to avoid this problem - explicitly cast `2` to the desired  type:

```c++
return t * static_cast<T>(2);
return t * T(2);
```

Both approaches are good, one will likely be more appropriate depending on the task. The first one requires `2` to be convertible to `T`. The second one requires `T` to have a constructor that can take `int`.

Both of these will work for any numeric type, however, for numeric types first option sounds more appropriate - we are not used to construct numbers using `double(2)` syntax (although it's perfectly valid).  For non-numeric types, second option will feel more appropriate - better to build than to convert.

### function template specialization

Suppose we have resigned of using multiplication and would like to use addition instead:

```c++
template <typename T>
T duplicate(const T& t)
{
    return t + t;
}
```

This function works for all types that support binary `operator+`:

```c++
std::cout << duplicate(2) << '\n';          // prints 4
std::cout << duplicate(3.14) << '\n';       // prints 6.28
std::cout << duplicate('#') << '\n'         // prints F (in ASCII # has value 35 and F 70)
std::cout << duplicate(std::string("word")); // prints wordword
```

But "wordword" looks bad. We want it to have a space between words. **We want the template to behave differently for certain type.**

This is a good place to use **template specialization**:

```c++
#include <iostream>

// primary implementation
template <typename T>
T duplicate(const T& t)
{
    return t + t;
}

// specialization for T = std::string
template <>
std::string duplicate<std::string>(const std::string& t)
//  (1)                   (2)                (3)
{
    return t + ' ' + t;
}

int main()
{
    std::cout << duplicate(2) << '\n';                   // prints 4
    std::cout << duplicate(3.14) << '\n' ;               // prints 6.28
    std::cout << duplicate('#') << '\n';                 // prints F (in ASCII # has value 35 and F 70)
    std::cout << duplicate(std::string("word")) << '\n'; // (4), prints word word - uses specialized version
    std::cout << duplicate<std::string>("word") << '\n'; // (5), same as above
}
```

Specialization allows to implement a different behaviour for certain types.

What is important:

- Function name has appended `<std::string>` (2) - this is the core syntax of specialization. It expresses that this implementation is unique for string type.
- `T`s are replaced with an actual type at (1) and (3) - template loses it's alias(es).
- `template <>` still has to be written, even if it has lost all of it's aliases. Just like functions taking no parameters still have to use `()`, the same way templates with no aliases still have to use `<>`.
- specializations have to be written after primary template (this should be obvious)

Note that only (2) is expressing specialization. (1) and (3) can be different from `std::string`, but given that the specialization is for string, it would be weird to take and/or return any different type.

**Do not confuse specialization with explicit deductions.**

- The place marked with (5) expresses it wants to use the duplicate function with `T = std::string`. It doesn't care whether the function template is specialized or not.
- The place marked with (4) puts a string into the function - the function obviously deduces `T` to be `std::string` and then notices there is a specilization for this type.

Both (4) and (5) work the same, just with the deduction part difference. They both want to call `duplicate<std::string>`.

#### example 2

We know that `sizeof` operator can not be applied to incomplete types. Since `void` is *an incomplete type that can not be completed* we can not put this into size of opeator. But we can implement a different behaviour for `void`, not using this operator:

```c++
template <typename T>
std::size_t my_sizeof()
{
    return sizeof(T);
}

template <>
std::size_t my_sizeof<void>()
{
    return 0;
}
```

In this example you can see more clearly that the specialization is just appended `<>` to the function name with alias replacements. This function does not take any arguments which made us not to worry about the need to replace anything else.

There is also another thing to notice - since the function takes no arguments, it's impossible to use type deduction.

```c++
main.cpp: In function 'int main()':
main.cpp:17:28: error: no matching function for call to 'my_sizeof()'
     std::cout << my_sizeof() << '\n';
                            ^
main.cpp:4:13: note: candidate: template<class T> std::size_t my_sizeof()
 std::size_t my_sizeof()
             ^~~~~~~~~
main.cpp:4:13: note:   template argument deduction/substitution failed:
main.cpp:17:28: note:   couldn't deduce template parameter 'T'
     std::cout << my_sizeof() << '\n';
                            ^
```

This means, that every time this function is used, the `T` must be given explicitly. The following example does it and also demonstrates architecture-specific behaviour of type sizes.

```c++
#include <iostream>

template <typename T>
std::size_t my_sizeof()
{
    return sizeof(T);
}

template <>
std::size_t my_sizeof<void>()
{
    return 0;
}

int main()
{
    std::cout << my_sizeof<void>() << '\n';     // 0 because of specialization
    std::cout << my_sizeof<char>() << '\n';     // always 1
    std::cout << my_sizeof<void*>() << '\n';    // 4 on 32-bit x86 and ARM, 8 on 64-bit x86_64 and ARM
    std::cout << my_sizeof<long long>() << '\n'; // 8 if the target architecture has 8-bit bytes
}
```

#### Question: I tried to specialize for multiple types at once, but it failed. Is this possible?

Such thing happens when a template with 1 alias is tried to be specialized for multiple aliases. You have probably done something like this:

```c++
template <typename T>
T func(const T& t)
{
    // whatever...
}

template <typename T>
T func<float, double, long double>(const T& t)
{
    // something different...
}
```
or this:

```c++
template <typename T>
T func(const T& t)
{
    // whatever...
}

template <>
long double func<float, double, long double>(long double t)
{
    // something different...
}
```

The problem with first approach is redefinition. Both functions have the same template signature (1 type alias) (changing T to a different letter will not help). It's impossible to templatize specialiations.

The problem with second approach is alias mismatch. Only 1 type is aliased, but 3 were given. This would make sense if the primary template had 3 aliases, but it does not.

> So what's the answer? Is specialization for multiple types at once possible?

No. Specialization is a feature that is made specifically for providing unique implementations for exactly 1 concrete type. However, there are other features which can do the trick.

In later chapters, more advanced magic will be presented which will allow to have 1 primary implemetation and any amount of specific implementations for certain types or types that exhibit certain properties. These features are:

- enabling/disabling implementations based on SFINAE (`std::enable_if` and `std::void_t`)
- compile-time decisions (`if constexpr`)
- concepts and matching arguments by their satisfaction