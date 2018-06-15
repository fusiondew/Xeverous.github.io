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

When call to a function is encountered, (un)qualified name lookup is performed (depending how the call is written) and template overloads are deduced. All possible function calls are then *candidates*.

If there are multiple candidates, there are few possible results:

- Arguments don't match and can not be transformed in any way to match. This is a compilation error (unmatched types).
- Arguments match exactly 1 overload - this function is choosen.
- Arguments can match more than 1 overload - depending on the transformations needed to match it's **either a compilation error (multiple possible overloads to call) or (if one transformation has higher priority than others) the most fitting overload is choosen**

The most tricky is the bolded part. The rules for matching during overload resolution are [long](https://en.cppreference.com/w/cpp/language/overload_resolution) but somewhat intuitive. Unfortunately they can't be simplified due to backwards-compatibility.

When multiple overloads are possible, this is the priority of choosing:

- Perfect match. Should be obvious - if nothing is needed to do with the types, such overload is always choosen.

```c++
void func(int, float);
// other overloads...

func(42, 3.14f); // perfect match - types are int and float
```

- Promotion (lossless convertion).

This mostly applies to integers or lofating-points becoming larger. Characters and plain enumerations can become integers. Note that *any integer to any floating-point* is not a promotion but convertion.

```c++
void func(int);
// other overloads... but no func(char)

func('a'); // char promoted to int
```

- Standard convertion.

```c++
void func(int*);
// other overloads... but no one taking any sort of integer

func(0); // 0 integer implicitly converted to null pointer, error if there is more than 1 pointer overload



void func2(const void*);
// other overlods but no one taking other pointer types

func2("text"); // const char[5] implicitly converted to const char* then to const void*
```

- User-defined convertion

```c++
void func(std::string)
// other overloads but no one taking any pointer type or character array

func("text"); // std::string constructed from character array
```

Overloads requiring promotions, standard implicit convertions and user-defined convertions are treated equally when on the same level. If overload resolution stops on any of these with multiple candidates this results in compilation error. If not, the function with highest priority transformation of these is choosen.

More examples:

```c++
void func(unsigned);    // (1)
void func(double);      // (2)
void func(const char*); // (3)
void func(const void*); // (4)

int x;
func(0u);      // 0u is unsigned, perfect match with (1)
func(0);       // ambiguous: all 4 overloads require implicit convertion ((2) is not a promotion)
func(x)        // ambiguous: both (1) and (2) are convertions
func('a');     // ambiguous: 'a' is of type char and both (1) and (2) are convertions (char to int would be a promotion but it's not the case for unsigned)
func("text")   // chooses (3) as it requires 1 less implicit convertion than (4)
func(nullptr); // ambiguous: both (3) and (4) require implicit convertion
func(3.14l);   // ambiguous: both (1) and (2) require implicit convertion
func(3.14f);   // chooses (2) - because it's the only available promotion
```

## in practice

There is not that much problem of function overloading. Don't worry if you can not memorize all the rules - intuitively the most fitting function is choosen.

The core purpose of overloading is to provide the same interface regardless of the type. A very good example which you already used a lot is operator `<<` with standard streams - it can print many things thanks to overloading (in this case operator overloading). Without overloading, you would need to remember a separate function name for each type you want to print.

## summary

Operator overloading lets to define multiple functions (and operators) with the same name if they differ by argument amount or their types. If there are multiple valid candidates, the one with least required work is choosen (in order: perfect match, promotion, standard convertion, user-defined convertion). If more than 1 candidate requires the same amount of work it's a compilation error.
