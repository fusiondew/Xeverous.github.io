---
layout: article
---

## preface

Not everything goes always ideal. There are many approaches to error handling.

**Note:** the following text is about handling expected errors (OS problems, invalid input by the user, invalid format), not about code-level bugs (resource ownership, null dereference, data races, Un, etc).

**On hiding errors**

Many places of software like or encourage to hide problems. Many interpreted (very often dynamically typed) programming languages hide errors and try to go as far as possible even though the initial state was already meaningless. Usually values end being empty strings, null references or some heterogenous array abonimations with no meaning.

Of course interpreted/dynamically typed scripting languages have different purpose and usage (buggy website better than no website), so whether it's good or bad for them - I will leave this to experts of their field. Just worth noting that there is no unanimous consensus and alternatives exist (eg JavaScript vs TypeScript, type hinting in Python 3).

C++ is a language that aims for accuracy, type safety and performance and so we do not want to continue once our computation loses it's sense. Hiding errors is counterproductive - **we should fight the cause, not the consequence**. Fail early and greatly.

**On error handling**

An ideal error handling (which obviously can not exist) would satisfy these requirements:

- does not affect working code - adding error checks should not change major program flow or it's design
- hard to misuse (you do not want error-prone error handling, right?)
- rich information - no errno codes like "operation failed", "busy", "try again" but detailed types or objects holding a lot of relevant information
- easy to propagate - if an error is really hard and enclosing function can't handle it you want to stop, skip work and "push" that error further until a core program structure is met - then something with higher power can make bigger decisions
- does not require verbose code (no 100-line else-is/switches depending on result)
- does not impact program performance

## global state (errno)

Many C library functions report errors by setting `errno` (thread-local global error number).

```c++
int val = std::strtol(str, nullptr, 10); // sets errno on failure
if (errno != 0)
{
    switch (errno)
    {
        case ERANGE:
            // ...
        default:
            // ...
    }

    errno = 0;
}
```

Advantages:

- does not affect function return type or arguments

Disadvantages:

- **non-constant global variable**
- very easy to forget to check
- very easy to forget to reset (C library never restores errno to 0)
- **limited usage (macros and plain integers)**
- **poor information**, can hold only 1 error at once and it's just an integer
- very verbose and error-prone (error-prone error handling, how ironic)
- can be easy propagated but very hard to propagate correctly
- inconsistent - a lot of C library functions set errno, but also a lot do not set it and return it's value instead

Global variable is a terrible choice for error handling. Obviously we can not suddenly refactor error handling by C library functions but we can limit their use and move to alternatives.

## return status

```c++
bool some_func();   // return true if operation succeeded
status some_func(); // return status::ok (enum) if operations succeeded

if (!some_func())
    // ...
```

This is generally the easiest to use error handling. If a function returns `void` and we want to report result the simplest thing we can do is to return boolean or (more precise) enumerations which describe the situation.

Advantages

- very simple

Disadvantages:

- requires function original return type to be `void`
- easy to forget to check the return value*
- requires long else-ifs/switches to check what has actually happened (verbose)
- quite tedious to propagate
- **error-prone if you add another enum value (add a case to every switch...)**

**\*:** Not with a certain **attribute**. This issue has been generally resolved in as forced compilcation warnings about unused data.

Generally simple boolean returns or checks are not bad. We use them all the time (`if (str.empty())`) but they should not be used for more impactful problems. They are simple and should be used for simple (likely expected) situations.

Use `bool` returns for simple operations that are often expected to fail. If you notice many switches on enum value you need a different error handling.

## out parameter

A variation of the result status but now as a non-const out paramater.

```c++
int func(error_code& ec); // set ec to error enum on failure

error_code ec = error_code::ok;
int val = func(ec);

switch (ec)
{
    case /* ... */:
    case /* ... */:
    case /* ... */:
    default:
        // ...
}
```

Advantages

- still quite simple
- can be used with non-void functions (also constructors)

Disadvantages:

- verbose
- code becomes less clear (out parameters are rarely used)
- **error-prone if you add another enum value (add a case to every switch...)**
- changes function arguments
- hard to propagate

<div class="note info">
Remainder: non-const references do not accept rvalues so `func(error_code())` will not work. Passed argument must outlive the function.
</div>

Rarely used. Prefer more detailed return types or exceptions.

Also, think how you react to it - if you have 20 different enumeration values but to 19 of them react in the same way what's the point of distinguishing the error then?

## monads

```c++
std::optional<std::string> func();
std::expected<std::string, error_code> func();

const auto result = func();
if (!result)
    // ...
```

Advantages:

- easy, type-safe and intuitive to use
- forces to correctly handle errors
- can be used with most functions
- somewhat easy to propagate

Disadvantages

- verbose, but less then previous alternatives
- not a solution for failing constructors (can be used but there are much better alternatives)

Monads are very good error handling for situations where we do not care much about the cause. `std::optional<int> safe_divide(int x, int y)` is a typical example - we get nothing on division by 0 or overflows. Monads are good for functional programming (especially their reputation in Haskell) but they are not an appropriate error handling for severe errors.

## exceptions

```c++
try {
    update_files();
    reload_game_assets();
}
catch (const no_file_exception& e) {
    restore_last_version();
    log.add_error(e.what());
}
catch (const corrupted_file_exception& e) {
    remove_files();
    log.add_error(e.what());
}
catch (const std::exception& e) {
    log.add_error(e.what());
}
catch (...) {
    log.add_error("unknown error while loading");
    throw;
}
```

Advantages:

- **RAII, type-safe, invariant-safe**, no switches or else-ifs for cleanup
- **very strong, automatic propagation**
- **very strong matching of errors to handlers**
- separated from orinary code - exceptions do not affect code that does the work
- can be used by constructors without argument changes
- can safely ommit hard requirements like reference initialization

Disadvantages:

- **performance penalty**, requires dynamic allocation (should not/can not be used in critical code)

The most advanced error handling, relies on object-oriented programming and polymorphism. Heavy when it comes to the error but **nothing can beat exceptions extensibility and automatic propagation**.
