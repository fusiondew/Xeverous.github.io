---
layout: article
---

So far all of the functions took their arguments **by value**. If you try (or tried) to do something like

```c++
#include <iostream>

void func(int x)
{
    std::cout << "x before multiplying: " << x << "\n";
    x = 2 * x;
    std::cout << "x after multiplying: " << x << "\n";
}

int main()
{
    int x = 10;
    func(x);
    std::cout << "x = " << x;
}
```

~~~
x before multiplying: 10
x after multiplying: 20
x = 10
~~~

it results in x still being 10. It is so because **functions do not work directly on the arguments they get**. Someone could write `func(10)` - would this make any sense? Where should 20 be saved?

When the processor encounters a function call in the machine instructions, it saves the position of the current instruction, saves current state of registers and inputs the copy of the arguments to registers or onto the stack. Then, the function operates on this data and when the function returns processor jumps back to the code where it was previously - only the return value is transferred, everything else was "done on the side".

You can confirm this by printing address of `x` inside and outside the function - both are different "x". They just happen to have the same name.

## passing pointers

From the assembly point of view, functions always operate on copied data and thus only the return statement can transfer some result. But what if the argument type is changed to a pointer?

```c++
#include <iostream>

void func(int* x)
{
    std::cout << "x before multiplying: " << *x << "\n";
    *x = 2 * *x;
    std::cout << "x after multiplying: " << *x << "\n";
}

int main()
{
    int x = 10;
    func(&x); // this time we need to pass the address of x
    std::cout << "x = " << x;
}
```

~~~
x before multiplying: 10
x after multiplying: 20
x = 20
~~~

This time it works. The function still gets the copy of the argument, but this time it's the copy of a pointer - the function is able to access original variable. This works even if you change the name of `x` - the function argument has it's own scope - in this case the main function has own variable `x` of type `int` and the custom function has the argument named `x` of type `int*`.

The body of the function had to be changed - `x` was changed to `*x` because the pointer has to be dereferenced.

Advantages of passing pointers:

- You can work on the original variable and the result will stay.
- Pointers have fixed length for the given system. Copying heavy types can be expensive

Disadvantages of passing pointers as arguments:

- Syntax gets complicated - pointers need to be dereferenced to access actual variable.
- `x += 2` will always compile, but there is a big difference where `x` is an integer (adding value 2) and where `x` is a pointer (moving 2 objects forward in memory). Forgetting to add dereference when chaning argument to a pointer can cause a hard to find bug which results in crashes.
- someone can put a null pointer as an argument - this can further complicate the function body (adding null pointer checks)

To solve these problems, **references** have been created.

## passing references

References keep the ordinary type semantics, but work like pointers.

```c++
#include <iostream>

void func(int& x) // int reference
{
    std::cout << "x before multiplying: " << x << "\n";
    x = 2 * x;
    std::cout << "x after multiplying: " << x << "\n";
}

int main()
{
    int x = 10;
    func(x);
    std::cout << "x = " << x;
}
```

~~~
x before multiplying: 10
x after multiplying: 20
x = 20
~~~

Note how all syntax is back again like `x` was plain `int`, but the function works on the same `x`.

## references

References are simply aliases to existing objects. A reference is denoted by adding `&` to the type.

```c++
int x; // integer
int* ptr; // poiter to inetegr
int& ref; // reference to integer
```

<div class="note warning">
<h4>&</h4>
<p markdown="block">
Do not confuse `&` applied to the type and `&` applied to the variable

- `&` applied to the variable is the address-of operator. Expression `&x` returns an address
- `&` applied to the type changes this type to a reference. Expression `int&` is a type - reference to an integer

</p>
</div>

### example

```c++
#include <iostream>

int main()
{
    int x = 10;
    int y = 10;
    // note that pointers operate on adresses but references work directly
    int* ptr = &x; // create an integer pointer equal to the address of x
    int& ref = y;  // create an integer reference equal to the variable y

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n";

    // chaning the value
    *ptr += 5; // pointers need to dereference
    ref += 5; // references works directly

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n";

    // getting the address
    std::cout << "x address = " << ptr << "\n"; // a pointer is an address
    std::cout << "y address = " << &ref << "\n"; // reference works like a variable, need to apply address-of operator
}
```

~~~
x = 10
y = 10
x = 15
y = 15
x address = 0x7ffe2c70f628
y address = 0x7ffe2c70f62c
~~~

## refeence initialization

When a reference is created, it is being set to be an alias of some concrete object. Further assignments do not re-bind the reference but change the referenced object

```c++
#include <iostream>

int main()
{
    int a = 10;
    int b = 100;
    int c = 1000;

    int& ref = a; // create an alias "ref" that works like "a"
    std::cout << "referenced value: " << ref << "\n";

    // HOW IT WORKS: referenced variable is set to b
    // HOW IT DOES NOT WORK: reference is set to alias "b"
    ref = b;

    std::cout << "referenced value: " << ref << "\n"; // we still print a, but a was changed
    std::cout << "b = " << b << "\n";

    ref = c; // referenced variable (a) is set to the value of c
    std::cout << "referenced value: " << ref << "\n"; // we still print a
    std::cout << "b = " << b << "\n"; // b is unchanged
}
```

~~~
referenced value: 10
referenced value: 100
b = 100
referenced value: 1000
b = 100
~~~

In other words, `ref` for the entire program was `a`. The first line where the reference was created set it to alias `a`, but all subsequent instructions were modifying `a`, NOT changing the reference aliases.

## core rules of references

**References must always be initialized. It's imposible to have a null or uninitialized reference.**

```c++
int main()
{
    int& ref1; // error: 'ref1' declared as reference but not initialized
    int& ref2 = nullptr; // error: invalid initialization of non-const reference of type 'int&' from an rvalue of type 'std::nullptr_t'

    // possible workaround
    int* ptr = nullptr;
    int& ref3 = *ptr; // but the dereference is undefined behaviour
}
```

**References can not be rebound. Once you initialize a reference, it will always alias the same object.**

```c++
#include <iostream>

int main()
{
    int x = 10;
    int y = 33;
    int& ref = x;

    std::cout << "x = " << x << "\n";

    ref = y; // set x to the value of y, NOT rebind ref to alias y

    std::cout << "x = " << x << "\n";

    ref = 42; // still working on x

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n"; // y is untouched
}
```

**References can not be nested. A reference to reference can not exist - it will collapse instead and alias the original variable.**

It would be good to post an example for this, but there is a caveat - `int&&` is actually a valid syntax, but it means something other than a usual reference.

```c++
int x = 100;
int& ref = x;
int&& refref = ref;
```

Nonetheless the code above will not compile, but the reason will be very different - the compiler will not output that nested references are impossible, but something about **lvalue** vs **rvalue**. This is a quite complicated topic (value types), it's explained later, including the difference between `&` and `&&` reference.

**References can not be themselves const. They can alias const objects, but since a reference can not be rebound it itself is always implicitly const.**

```c++
int x = 10;
int y = 20;

// A pointer can be changed to point to a different object.
int* ptr1 = &x;
ptr1 = &y;

// A const pointer can not be changed to point to a different object
int* const ptr2 = &x;
ptr2 = &y; // error: ptr2 is const

// A reference never rebinds - it always aliases the same object
int& ref1 = x;
ref1 = y; // does not rebind, instead changes the value of x

// invalid syntax
int& const ref2 = x;
```

**References do not offer pointer arithmetics. They have semantics of aliased type.**

```c++
int arr[] = { 10, 20, 30, 40, 50 };
int* ptr = arr;
int& ref = *ptr;

// works, uses pointer arithmetics
*(ptr + 3)
ptr[3]

ref + 3 // adds 3 to the aliased object
ref[3] // invalid syntax
```

All of the above features make references a safer, less error prone construct.

#### Question: How do references work under the hood?

At worst case, they are just hidden pointers. At best case (due to their rules) compiler can perform multiple optimizations and remove them altogether making them a pure zero-cost abstraction.

## summary

References:

- work like pointers (can access and modify original objects - no copying)
- use syntax like values (no dereference needed, references are never null)
- must always be initialized and can not be rebound

Note: all of the examples above are about **lvalue references** (`type&`). In the future you will learn about **rvalue references** (`type&&`) which are different but still share all the constraints.

TODO returning refernces/pointers to local variables
