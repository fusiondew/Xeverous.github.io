---
layout: article
---

Sometimes you may encounter a problem where you need multiple functions doing similar task. Ideally, you would like to name the functions similar - in fact, these functions can be named the same as long as their argument specification is different.

TODO def block

Function overloading is a feature that allows to have multiple functions with the same name as long as their parameters are different

```c++
#include <iostream>

void divide(int a, int b)
{
    if (b == 0)
    {
        std::cout << "can not divide by 0\n";
        return;
    }

    std::cout << "quotient: " << a / b << "\n";
    std::cout << "remainder: " << a % b << "\n";
}

void divide(double a, double b)
{
    // In case you forgot: dividing fractions by 0 is allowed, but the results are not ordinary numbers
    std::cout << "quotient: " << a / b << "\n";
}

int main()
{
    divide(16, 7);
    divide(13, 0);

    divide(16.0, 7.0);
    divide(13.0, 0.0);
}
```

~~~
quotient: 2
remainder: 2
can not divide by 0
quotient: 2.28571
quotient: inf
~~~

It should be intuitive that the first 2 calls are using *the integer overload* and the second 2 calls are using *the double overload*.

## overloading - rules

- At least one must be different: amount of arguments, argument types (argument names do not matter)
- Functions can not be overloaded only by different return type

```c++
// OK: all overloads have different amount of arguments
int func1(int);
int func1(int, int);
int func1(int, int, int);

// OK: all overloads have different types
int func2(int);
int func2(float);
int func2(double);

// Also OK
int func3(int, float);
int func3(double);
int func3(char);

// error: only return type is different, can not overload
int func4();
void func4();

// OK: different amount of arguments
int func5();
void func5(int);

// OK: different argument types
void func6(int*);
void func6(int&);
```

- `const` applied to plain type is not enough, but it is enough for more complex types

```c++
void func1(int);
void func1(const int); // error: redefinition

// OK - all types are different
void func2(int*)
void func2(const int*)
void func2(int&)
void func2(const int&)
```

- aliases are not different types, they are the same type with multiple names

```c++
using integer = int;
typedef int my_int;

void func(int);
void func(integer); // error: the same signature
void func(my_int);  // error: the same singature
```

## overloading - choosing

TODO qualified/unqalified name lookup? ADL Too complex? Something more intuitive?
