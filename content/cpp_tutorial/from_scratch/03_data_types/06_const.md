---
layout: article
---

## basics

`const` can be aplied to any declaration, preventing value from being changed:

```c++
const int x = 10;
x = 5; // error: x is const
```

Constants may be initialized from non-const variables:

```c++
int a = 10;
const int b = a; // ok
```

Constants have to be initialized:

```c++
const int x; // error: constant not initialized
```

`const` can also be used after the type name:

```c++
const int a = 1; // so called 'west const'
int const b = 2; // so called 'east const'
```

Given expectations coming from English language grammar, the first form is more natural and therefore recommended.

## `constexpr`

This keyword is a leveraged version of `const`. It adds additional restriction: the value must be able to be computed at compile time.

```c++
constexpr long cppstd = __cplusplus; // macro is a number in the form "YYYYMM"
constexpr long year = cppstd / 100; // remove MM part
std::cout << "Year of the used C++ standard: " << year << "\n";

constexpr int n1 = get_input_from_user(); // will not compile - we don't know what user will input
const int n2 = get_input_from_user(); // ok, compiler will not let change n2 but allows to initialize it from some run-time dependent value
```

If possible, it's recommended to use `constexpr` over `const` as it opens few more language features which require compile-time data. 

## rationale

Advantages of `const`/`constexpr`:

- prevents bugs caused by accidental assignments
- makes code easier to understand - the reader does not have to worry about potential changes

## summary

- both `const` and `constexpr` require initialization
- both `const` and `constexpr` disallow changing value
- `constexpr` requires data to be computable at compile-time

## recommendation

- use `constexpr` for everything that is possible to be computed at compile-time
- use `const` for everything that once initialized, should never be changed
