---
layout: article
---

Consider a very simple inheritance:

```c++
struct base { int foo; };
struct derived : base { int bar; };
```

**Object slicing** happens when derived type gets assigned to base:

```c++
// (using aggregate initialiation)
base b{1};         // b.foo == 1
derived d{{2}, 3}; // d.foo == 2, d.bar == 3

b = d; // b.foo == 2 now, d.bar is lost
```

Assignment operator expects `const base&`. Since `d` is `derived` it's also a `base` and the operator has no problem taking an object - but it only uses the `base` part of `d`. **Remaining information is lost.**

## more severe case

```c++
#include <iostream>

struct base { int foo; };
struct derived : base { int bar; };

int main()
{
    derived d1{{1}, 2}; // d.foo == 1, d.bar == 2
    derived d2{{3}, 4}; // d.foo == 3, d.bar == 4

    base& b_ref = d1; // bind derived object to base reference (so far good)
    b_ref = d2; // object slicing!

    std::cout << "d1.foo: " << d1.foo << "\n";
    std::cout << "d1.bar: " << d1.bar << "\n";
}
```

~~~
d1.foo: 3
d1.bar: 2
~~~

**The resulting object contains mixed data from both `d1` and `d2`.**

Reference binding itself is not bad. We can use objects of derived types just like they were base (the use is limited to base class features).

```c++
base& b_ref = d1;
```

The problem happens here:

```c++
b_ref = d2;
```

TODO
