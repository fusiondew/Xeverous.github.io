---
layout: article
---

## The boolean type

`bool` is a type capable of holding only 2 values: `false` and `true`. It's an equivalent to logic statements in math.

`bool` can also be viewed as a representation of a single bit (0 or 1), although it often occupies full byte (8 bits) or more memory - this is because in typical Von-Neumann architecture memory is addressed by bytes, not bits. Still, at the C++ language level `bool` can hold only 2 values.

`bool` type will be most often used with `if` and similar control flow statements.

### printing booleans

```c++
#include <iostream>

int main()
{
    bool x = true;
    bool y = false;
    std::cout << "x = " << x << "\ny = " << y;
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
    std::cout << std::boolalpha << "x = " << x << "\ny = " << y;
}
```

which prints

```
x = true
y = false
```

`std::boolalpha` modifies the stream and makes it print text interpretation of boolean values. You can use `std::noboolalpha` to revert back to printing 0 and 1.

More about stream I/O manipulators later.
