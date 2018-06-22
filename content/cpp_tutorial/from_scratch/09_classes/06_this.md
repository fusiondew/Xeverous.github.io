---
layout: article
---

You may wonder how member functions actually work


```c++
void rectangle::set_values(int a, int b)
{
    // width and height are not global, so where do they come from?
    width = a;
    height = b;
}
```

It's rather simple to understand that each object of type `rectangle` has it's own width and height, but rather unclear how member functions actually work beneath.

The key is that member functions are called **on** objects:

```c++
rectangle r1;
r1.set_values(3, 4); // sets r1.width and r1.height
rectangle r2;
r2.set_values(5, 9); // sets r2.width and r2.height

set_values(16, 10);  // error: no rectangle on which to set width and height
```

Certainly there must be some hidden mechanism that knows when the function is invoked on `r1` or `r2` - there is only 1 function body, but it works separately on each object.

## implementation

Previously it was stated that functions are implemented as jumps in the assembly and (by default) their arguments are copied.

In fact, member functions are still functions and their implementation is the same except 1 thing - there is a hidden paremeter, called `this`.

To better understand it, compare these 2 snippets:

```c++
// member function - what you write
void rectangle::set_values(int a, int b)
{
    width = a;
    height = b;
}

// global function - what actually compiler does
void set_values(rectangle* this, int a, int b)
{
    this->width = a;
    this->height = b;
}
```

The second function is more close to what compiler actually does. Functions can not access any data outside global variables and their arguments - that's why there is a hidden `this`. The `this` pointer allows to access specific object.

Viewing it from the outside:

```c++
r1.set_values(3, 4);   // what you write
set_values(&r1, 3, 4); // what compiler does
```

## `this` in practice

What's truly interesting, is that `this` is a keyword and it's possible to use it like ordinary pointer.

TODO def block

For class foo, `this` represents it's own address - `this` has type `foo*`. `this` is only accessible inside class member functions.

Example - we make a very simple class that prints own address where it's located in memory.

```c++
#include <iostream>

class foo
{
public:
    void print() const;
};

void foo::print() const
{
    std::cout << "I'm at " << this << "\n";
}

int main()
{
    foo f1;
    f1.print();
    std::cout << "f1 is at: " << &f1 << "\n";

    foo f2;
    f2.print();
    std::cout << "f2 is at: " << &f2 << "\n";
}
```

~~~
I'm at 0x7ffcb0417dce
f1 is at: 0x7ffcb0417dce
I'm at 0x7ffcb0417dcf
f2 is at: 0x7ffcb0417dcf
~~~

Notice that `&f1` and `&f2` output the same address as `this`? `this` is simply an address of the object on which the function is invoked.

**`this` is only accessible inside member functions**

```c++
int main()
{
    std::cout << this << "\n"; // error: not inside a class
}
```

Accessing `this` inside non-member function does not make any sense - `main` is not working on any class-object.

## implicit `this`

```c++
void rectangle::set_values(int a, int b)
{
    width = a;
    height = b;
}
```

can be written as

```c++
void rectangle::set_values(int a, int b)
{
    this->width = a;
    this->height = b;
}
```

Now it should be clear where do `width` and `height` come from - **all member variables are implicitly accessed by `this`**.

This also explains `const` member functions:

```c++
void rectangle::get_area() const
{
    width = /*...*/; // error, can not assign inside const member function
    this->width = /*...*/; // as above
}
```

Inside const-qualified member functions, `this` is not of type `rectangle*` but `const rectangle*`. It's not possible to modify data through a pointer to const.

## core rules

- `this` is only accessible inside non-`static` member functions (what is `static` - in few lessons)
- `this` is never null

#### Question: If `this` is never null, why is it a pointer and not a reference?

History. `this` was added to the language before references. It would be a reference if added later.
