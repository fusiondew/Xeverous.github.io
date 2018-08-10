---
layout: article
---

Sometimes you may encounter a problem where you need multiple functions doing similar task or the same task but on different types. You probably would name them similarly - in fact, names can be the same thanks to overloading.

TODO def block

Function overloading is a feature that allows to have multiple functions with the same name as long as their *signatures* are different.

```c++
#include <iostream>

void divide(int a, int b)
{
    if (b == 0)
    {
        std::cout << "can not divide by 0\n\n";
        return;
    }

    std::cout << "quotient: " << a / b << "\n";
    std::cout << "remainder: " << a % b << "\n\n";
}

void divide(double a, double b)
{
    std::cout << "quotient: " << a / b << "\n\n";
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

It should be intuitive that the first 2 calls are using first overload and the second 2 calls are using second one.

## rules

In order to overload, functions must have different **signature**. Not all elements of function type consist to it's signature.

TODO def block

Function signature consists of:

- amount of parameters
- types of parameters
- const/volatile/reference qualifiers (on the function, not on paremeters) - this rule has sense only for *methods* which are functions inside classes

Function signature does not consist of:

- return type
- exception specification

```c++
// OK: all overloads have different amount of arguments
int func1(int);
int func1(int, int);
int func1(int, int, int);

// OK: all overloads have different argument types
int func2(int);
int func2(float);
int func2(double);

// Also OK
int func3(int, float);
int func3(int);
int func3(double);
int func3(char);

// error: return type does not affect signature
int func4();
void func4();

// OK: different amount of arguments
int func5();
void func5(int);

// OK: different argument types
void func6(int*);
void func6(int&);
void func6(int&&);

// error: exception specification does not affect signature
void func7();
void func7() noexcept;
```

- `const` applied to plain type is treated as the same, but inner consts like pointed types or referenced types are treated as different

```c++
void func1(int);
void func1(const int); // treated as the same declaration

void func1(int) {}
void func1(const int) {} // error: redefinition

void func2(int*);
void func2(int* const); // treated as the same declaration

void func2(int*) {}
void func2(int* const) {} // error: redefinition

// OK - all types are different
void func3(int*)
void func3(const int*)
void func3(int&)
void func3(const int&)

// all are the same declaration
int f(char s[10]);
int f(char[]);
int f(char* s);
int f(char* const s);
int f(char* volatile s);
```

- aliases are not different types, they are the same type with multiple names

```c++
using integer = int;
typedef int my_int;

void func(int);
void func(integer); // treated as the same declaration
void func(my_int);  // treated as the same declaration

void func(integer) {}
void func(int) {} // error: redefinition
```

## overloading - choosing

TODO qualified/unqalified name lookup? ADL Too complex? Something more intuitive?

When call to a function is encountered, (un)qualified name lookup is performed (depending how the call is written) and template overloads are deduced. All possible function calls are then *candidates*.

If there are multiple candidates, there are few possible results:

- Arguments don't match any candidate and can not be implicitly converted to matching types. This is a compilation error.
- Arguments match exactly 1 overload - then this function is chosen.
- Arguments can match more than 1 overload. **Depending on the priority of required implicit convertions:**
    - multiple or all convertions have the same priority - complication error
    - 1 convertion has higher priority - then this overload is chosen

The most tricky is the bolded part. The full list of rules regarding overload resolution [is long](https://en.cppreference.com/w/cpp/language/overload_resolution) but somewhat intuitive.

When multiple overloads are possible, this is the priority of choosing:

- Perfect match. Should be obvious - if nothing is needed to do with the types, such overload is always choosen.

```c++
void func(int, float);
// other overloads...

func(42, 3.14f); // perfect match - types are int and float
```

- Promotion (lossless implicit convertion).

This mostly applies to integers or floating-points becoming larger. Characters and plain enumerations can become integers. Note that *any integer to any floating-point* is not a promotion.

```c++
void func(int);
// other overloads... but no func(char)

func('a'); // char promoted to int
```

- Standard convertion.

```c++
void func(int*);
// other overloads... but no one taking any sort of integer

// don't do this obviously
func(0); // 0 treated as null pointer, error if there is more than 1 pointer overload
```

```c++
void func2(const void*);
// other overlods but no one taking other pointer types

func2("text"); // const char[5] decayed to const char* then implicitly converted to const void*
```

- User-defined convertion (especially *constructors*)

```c++
void func(std::string)
// other overloads but no one taking any pointer type or character array

func("text"); // std::string *constructed* from character array
```

Overloads requiring promotions, standard implicit convertions and user-defined convertions are treated equally when on the same level. If overload resolution stops on any of these with multiple candidates this results in compilation error. If not, the function with highest priority convertion of these is chosen.

More examples:

```c++
void func(unsigned);    // (1)
void func(double);      // (2)
void func(const char*); // (3)
void func(const void*); // (4)

int x;
func(0u);      // 0u is unsigned, perfect match with (1)
func(0);       // ambiguous: all 4 overloads require implicit convertion ((2) is not a promotion)
func(x)        // ambiguous: both (1) and (2) require implicit convertions
func('a');     // ambiguous: 'a' is of type char and both (1) and (2) are convertions (char to int would be a promotion but it's not the case for unsigned)
func("text")   // chooses (3) as it requires 1 less implicit convertion than (4)
func(nullptr); // ambiguous: both (3) and (4) require implicit convertion
func(3.14l);   // ambiguous: both (1) and (2) require implicit convertion
func(3.14f);   // chooses (2) - because it's the only available promotion
```

## in practice

There is not that much problem of function overloading. Don't worry if you can not memorize all the rules - intuitively the most fitting function is choosen. The core purpose of overloading is to provide the same interface regardless of the type.

Operators, like functions can be overloaded too. **A very good example which you already used a lot is operator `<<` with standard streams. So far it has 29 overloads of which 14 are templates.**

Without overloading, you would need to remember a separate function name for each type.

## summary

- Specific parts of function type affect it's signature.
- Operator overloading lets to define multiple functions with the same name (or operators) if they have different signatures.
- During overload resolution, if there are multiple valid candidates, the one with least required work is choosen (in order: perfect match, promotion, standard convertion, user-defined convertion). If more than 1 candidate requires the same amount of work it's a compilation error.
