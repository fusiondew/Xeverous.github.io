---
layout: article
---

## member functions outside class

Functions inside classes gain access to member variables. They can also be split up into declarations and definitions.

TODO header/source separation. But in which chapter?

```c++
class rectangle
{
private:
    int width;
    int height;

public:
    void set_values(int a, int b); // declaration
    int get_area() const;          // declaration
};

void rectangle::set_values(int a, int b) // definition
//   ^^^^^^^^^^^ spot this
{
    width = a;
    height = b;
}
```

Note how definition uses `rectangle::` before it's name. It's to inform the compiler that we are writing a member function - otherwise it would complain that `width` and `height` are unknown names.

Don't get it wrong: `width` and `height` are not global variables. They are member variables of class `rectangle`. Each rectangle has it's own width and height.

The body of the funtion modifies `width` and `height` - they are members of the rectangle class. These variables are `private` but it's allowed for any member function to access them.

## accessing member variables

You may wonder how member functions actually work

```c++
void rectangle::set_values(int a, int b)
{
    // width and height are not global, so where do they come from?
    width = a;
    height = b;
}
```

Each object of type `rectangle` has it's own `width` and `height`, but how compiler knows which `width` and `height` modify if you have multiple `rectangle` objects in the program?

The key is that member functions are called **on** objects:

```c++
rectangle r1;
r1.set_values(3, 4); // sets r1.width and r1.height
rectangle r2;
r2.set_values(5, 9); // sets r2.width and r2.height

set_values(16, 10);  // error: no rectangle on which to set width and height
```

Certainly there must be some hidden mechanism that knows when the function is invoked on `r1` or `r2` - there is only 1 function body, but it works separately on each object. Changes of each object are independent from other objects.

## implementation

Compare these 2 functions:

```c++
// what you write
void rectangle::set_values(int a, int b)
//   ^^^^^^^^^^^
{
    width = a;
    height = b;
    other_member_func(...);
}

// how compiler understands it
void set_values(rectangle* obj_ptr, int a, int b)
//              ^^^^^^^^^^^^^^^^^^
{
    obj_ptr->width = a;
    obj_ptr->height = b;
    other_member_func(obj_ptr, ...); // other methods take 'obj_ptr' in similar fashion
}
```

Functions can not access any data outside global variables and their arguments. For each member function you write, compiler adds hidden parameter that holds the address of the object on which operation should be performed.

Viewing it from the outside:

```c++
r1.set_values(3, 4);   // what you write
set_values(&r1, 3, 4); // how compiler understands it
```

This is the core mechanism that makes member functions work - `r1.set_values()` and `r2.set_values()` set width and height for different objects because they get different object pointers.

#### Question: Shouldn't `obj_ptr` be a reference?

Yes, it should be - there is no point in giving a null pointer into such functions but...

## the `this` pointer

...what's truly interesting, is that `obj_ptr` actually exists as a keyword `this`.

TODO def block

For class `X`, `this` represents it's own address - `this` has type `X*`. `this` is only accessible inside non-static class member functions.

Example - we make a very simple class that prints own address.

```c++
#include <iostream>

class foo
{
public:
    void print();
};

void foo::print()
{
    std::cout << "I'm at " << this << "\n";
}

int main()
{
    foo f1;
    f1.print(); // this == &f1
    std::cout << "f1 is at: " << &f1 << "\n";

    foo f2;
    f2.print(); // this == &f2
    std::cout << "f2 is at: " << &f2 << "\n";
}
```

~~~
I'm at 0x7ffcb0417dce
f1 is at: 0x7ffcb0417dce
I'm at 0x7ffcb0417dcf
f2 is at: 0x7ffcb0417dcf
~~~

Notice that `&f1` and `&f2` output the same address as relevant `this`? `this` is simply an address of the object on which the function is invoked.

Since every time you write `obj.` compiler takes the address of this object, **it's impossible for `this` to be null**.

**`this` is only accessible inside member functions**

```c++
#include <iostream>

int main()
{
    std::cout << this << "\n"; // error: not inside a member function
}
```

Accessing `this` inside non-member function does not make any sense - `main` is not working on any object.

## implicit `this`

```c++
void rectangle::set_values(int a, int b)
{
    width = a;
    height = b;
    some_member_func();
}
```

can be written as (this is a valid code)

```c++
void rectangle::set_values(int a, int b)
{
    this->width = a;
    this->height = b;
    this->some_member_func();
}
```

You can not add manually `this` parameter (it is already there when you write `class_name::`) but you can explicitly write `this` when dealing with member variables - for readability reasons C++ does not require to write `this->` every time a member is accessed.

**All member variables are implicitly accessed through `this` pointer**.

#### Question: If `this` can be skipped, does it exist only for examples or has it some actual purpose? Are there situations were `this` is actually needed to be written?

Yes, there are multiple situations in which `this` needs to be explicitly written. One of these situations is presented in few lessons.

## UB warning

Some people may claim they have managed `this` to be a null pointer. Non-null value of `this` is guaranteed by the C++ language standards so if anyone managed to get null value they are invoking undefined behaviour.

The example below is reproducible on most compilers. It prints `this = 0` but might aswell crash, frezee or print garbage data.

```c++
#include <iostream>

class foo
{
public:
    void print()
    {
        std::cout << "this = " << this << "\n";
    }
};

int main()
{
    foo* p = nullptr;
    foo& f = *p; // null pointer dereference - undefined behaviour
    // from now on, everything can happen
    f.print();
}
```

It seems to work because the method does not dereference `this`. It only prints the value of the pointer - if it was to access some members (dereference needed) it would likely crash. Dereference in main function does not affect it because it does not try to modify any data.

## summary

- All member non-`static` variables are accessed by this pointer.
- `this` is only accessible inside non-`static` member functions.
- For class `X`, `this` is of type `X*` inside non-const methods and `const X*` inside const methods.
- `this` is never null.

*What is `static`/`const` member in few lessons. I mention it here because otherwise skilful readers would complain that my summaries are not strictly correct.*  

#### Question: If `this` is never null, why is it a pointer and not a reference?

History. `this` was added to the language before references. It would be a reference if added later.

Programming languages similar to C++ which appeared later have `this` or `self` keyword which is a reference but the *reference* term is these languages may be also different.
