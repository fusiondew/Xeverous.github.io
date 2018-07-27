---
layout: article
---

## preface

Not everything goes always ideal. There are many approaches to error handling.

An ideal error handling (which obviously can not exist) would satisfy these requirements:

- does not affect working code - adding error checks should not change major program flow
- hard to misuse (you do not want error-prone error handling, right?)
- rich information - no errno codes like "operation failed", "busy", "try again" but detailed types or objects holding a lot of relevant information
- easy to propagate - if an error is really hard and enclosing function can't handle it you want to stop, skip work and "push" that error further until a core program structure is met
- does not require verbose code (no 100-line else-is/switches depending on result)

## global state (errno)

```c++
int val = std::strtol(str, nullptr, 10); // sets global error number on fail
if (errno != 0)
{
    // ...
    errno = 0;
}
```

Advantages:

- does not affect function return type or arguments

Disadvantages:

- **non-constant global variable**
- very easy to forget to reset (C library never restores errno to 0)
- **limited usage (macros and plain integers)**
- **poor information**, can hold only 1 error at once
- very verbose and error-prone (error-prone error handling, how ironic)
- can be easy propagated but very hard to propagate correctly

Global state is a terrible choice for error handling. Obviously we can not suddenly refactor error handling by C library functions but we can limit their use and move to alternatives.

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

**\*:** Not with a certain **attribute**. This issue has been generally resolved in as forced compilcation warnings about unused data.

Generally simple boolean returns or checks are not bad. We use them all the time (`if (vec.empty())`) but they should not be used for more impactful problems. They are smple and should be used for simple (likely expected) situations.

## out parameter

A variation of the result status but now as a non-const out paramater.

```c++
int func(error_code& ec); // set ec to error_code::ok on success

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
- changes function arguments
- hard to propagate

<div class="note info">
Remainder: non-const references do not accept rvalues so `func(error_code())` will not work. Passed argument must outlive the function.
</div>

Rarely used. Prefer more detailed return types or exceptions.

## monads

```c++
std::optional<std::string> func();
std::expected<std::string, error_code> func();

const auto result = func();
if (!result)
    // ...
```

Advantages:

- easy, intuitive to use
- forces to correctly handle errors
- can be used with most functions
- somewhat easy to propagate

Disadvantages

- verbose (this might be disputed)
- can not be used by constructors

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
    log.add_error("unknown error in loading");
    throw;
}
```

Advantages:

- **RAII, invariant-safe**, no switches or else-ifs for cleanup
- **very strong, automatic propagation**
- **very strong matching of errors to handlers**
- separated from orinary code - exceptions do not affect code that does the work
- can be used by constructors without argument changes
- can ommit always-valid code requirements like reference initialization

Disadvantages:

- **performance penalty**, requires dynamic allocation (should not/can not be used in critical code)

The most advanced error handling, relies on object-oriented programming and polymorphism. Heavy when it comes to the error but **nothing can beat exceptions extensibility and automatic propagation**.
