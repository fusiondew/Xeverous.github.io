---
layout: article
---

## The boolean type

`bool` is a type capable of holding only 2 values: `false` and `true`. It's an equivalent of logic statements in math.

`bool` can also be viewed as a representation of a single bit (0 or 1).

`bool` type will be most often used with `if` and similar control flow statements.

<details>
<summary>technicalities</summary>
<p>

`bool` will often occupy full byte (8 bits) or more memory - this is because in typical Von-Neumann architecture memory is addressed by bytes, not bits.

Still, for many instructions compiler can optimize them to single bits if processor registers are available.

Note that less memory usage does not necessarily mean better performance. In many situations, memory use is larger than necessary to store intermediate computation results to prevent repetitive calculations (very typical space for time tradeoff).
</p>
</details>

### printing booleans

```c++
#include <iostream>

int main()
{
    bool x = true;
    bool y = false;
    std::cout << "x = " << x << "\ny = " << y << '\n';
}
```

The code above prints

```
x = 1
y = 0
```

which corresponds to bit representation of logic values.

There is also another way:

```c++
#include <iostream>
#include <iomanip> // for std::boolalpha

int main()
{
    bool x = true;
    bool y = false;
    std::cout << std::boolalpha << "x = " << x << "\ny = " << y << '\n' ;
}
```

which prints

```
x = true
y = false
```

`std::boolalpha` modifies the stream - it makes it print text interpretation of boolean values. You can use `std::noboolalpha` to revert back to printing 0 and 1.

More about stream I/O manipulators later.
