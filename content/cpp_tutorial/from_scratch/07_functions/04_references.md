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

This time it works. The function still gets the copy of the argument, but this time it's a copy of the pointer - the function is able to access original variable. This works even if you change the name of `x` - the function argument has it's own scope - in this case the main function has own variable `x` of type `int` and the custom function has the argument named `x` of type `int*`.

The body of the function had to be changed - `x` was changed to `*x` because the pointer has to be dereferenced.

Advantages of passing pointers:

- You can work on the original variable and the result will stay.
- Pointers have fixed length for the given system. Copying large structures can be expensive but copying an address is very trivial

Disadvantages of passing pointers as arguments:

- Syntax gets complicated - pointers need to be dereferenced to access actual variable.
- `x += 2` will always compile, but there is a big difference where `x` is an integer (adding value 2) and where `x` is a pointer (moving 2 objects forward in memory). Forgetting to add dereference when chaning argument to a pointer can cause a hard to find bug which results in crashes.
- someone can put a null pointer as an argument - this can further complicate the function body (adding null pointer checks)

To solve these problems, **references** have been created.

## passing references

References are just hidden pointers but keep the same syntax as regular objects. Because of their restrictions, they can sometimes be optimized better than plain pointers.

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
    func(x); // pass by reference, not by value
    std::cout << "x = " << x;
}
```

~~~
x before multiplying: 10
x after multiplying: 20
x = 20
~~~

All syntax is back again like `x` was plain `int`, but the function works directly on the argument.

## references

References are simply aliases to existing objects. A reference is denoted by adding `&` to the type.

```c++
int x;    // integer
int* ptr; // poiter to integer
int& ref; // reference to integer
```

<div class="note warning">
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
    int& ref = y;  // create an integer reference bound to the variable y

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

## reference initialization

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

    // HOW IT WORKS: referenced variable is assigned value of b
    // HOW IT DOES NOT WORK: reference is set to alias "b"
    ref = b;

    std::cout << "referenced value: " << ref << "\n";
    std::cout << "b = " << b << "\n";

    ref = c; // referenced variable (a) is assigned value of c
    std::cout << "referenced value: " << ref << "\n";
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

In other words, `ref` for the entire program was `a`. The first line where the reference was created set it to alias `a`, but all subsequent instructions were modifying `a`.

## core rules of references

**There are two categories of references:**

- `type&` - **lvalue reference**
- `type&&` - **rvalue reference**

They have 1 but very important difference which you do not need to know now. For now, all code will use lvalue references.

**References must always be initialized. It's imposible to have a null or uninitialized reference.**

```c++
int main()
{
    int& ref1; // error: 'ref1' declared as reference but not initialized
    int& ref2 = nullptr; // error: invalid initialization of non-const reference of type 'int&' from an rvalue of type 'std::nullptr_t'

    int* ptr = nullptr;
    int& ref3 = *ptr; // this will compile but has undefined behaviour
}
```

**References must be initialized to valid, existing objects**

Imagine a function which is supposed to save the result into passed variable. Passing something that is not an object doesn't make sense - and thus does not compile.

```c++
void f(int& x);

int x = 0;
f(x);  // ok: x will be modified
f(10); // error: 10 is not an object (can not bind lvalue reference to rvalue...)
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

**Unlike pointers, references can not be nested.**

```c++
int x = 100;
int& ref = x;
int& & refref = ref; // error: can not create reference to a reference
// int&& // different reference, explained later
```

**References can not be themselves const. They can alias const objects, but since a reference can not be rebound it itself is always implicitly const.**

Don't get this rule wrong: you *can* write `const` with a reference declaration. But it does not mean that the reference is const - it means that the referenced object is const. References themselves are always const, because they can't be rebound. So `int&` is already like `int* const` and `const int&` like `const int* const`.

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

// invalid
int& const ref2 = x;
```

The key is to understand that first `=` performs initialization which binds the reference to some object and any subsequent `=` is normal value assignment.

**References do not offer pointer arithmetics. They have semantics of aliased type.**

```c++
int arr[] = { 10, 20, 30, 40, 50 };
int* ptr = arr;
int& ref = *ptr;

// pointer semantics - uses addresses
ptr + 3 // adds 3 * sizeof(int) to the address
ptr[3]  // accesses 3rd value

// value semantics - uses values
ref + 3 // adds 3 to the aliased object (10 becomes 13)
ref[3]  // invalid
```

All of the above features make references a safer, less error prone construct.

## dangling references

**Don't return references to local objects.**

```c++
int& func()
{
    int result = /* ... */;

    // ...

    return result;
} // dangling reference, returned variable no longer exists
```

This is basically the same issue as with dangling pointers.

Compilers have a warning about it.

## summary

References:

- use regular syntax but offer *reference semantics*
- must always be initialized and can not be rebound
- unlike pointers, can not be null - they are always assumed to be bound to valid object
- do not allow pointer arithmetics

Generally, references are safer and better optimized.

<div class="note pro-tip">
Whenever possible, use references instead of pointers.
</div>
