---
layout: article
---

You can not have objects of type `void`, but you can have pointers to it.

This special feature lets to express pure address with no knowledge of the type.

```c++
#include <iostream>

int main()
{
    const char* str = "abc";
    const void* ptr = str; // implicit convertion

    std::cout << "string: " << str << "\n";
    std::cout << "address: " << ptr << "\n";
}
```

~~~
string: abc
address: 0x4009bd
~~~

In the example above, the stream is first given a character pointer - it prints the string. Then it's given a void pointer - it prints the address, just like for any other pointer.

## restrictions

Because void pointers carry no type information, they have very limited use:

- any pointer type can be implicitly converted to void pointer type (all `const` rules still apply)
- void pointers do not support arithmetic - `sizeof(void)` is invalid and therefore you can not move pointer forward/backward
- dereferencing void pointers is not possible
- void pointers needs explicit casts to convert them to other pointer types

You can still compare void pointers.

## usage

Void pointers are used when types do not matter or their meaning would bring no value.

- memory allocation functions
- low-level memory read/write functions
- cross-programming-language interfaces - each language has different type system

All of these things treat memory in a very generic way and do not care what actually is there.

Of course you should not use void pointers - they break one of the fundamental things: the type safety.

Still, in some situations, there is no other choice than the typeless pointers.
