---
layout: article
---

Not everything goes always ideal. There are many approaches to error handling.

## return status

```c++
bool some_func();   // return true if operation succeeded
status some_func(); // return status::ok (enum) if operations succeeded
```

This is generally the easiest to use error handling. If a function returns `void` and we want to report result the simplest thing we can do is to return boolean or (more precise) enumerations which describe the situation.

Advantages

- very simple

Disadvantages:

- requires function original return type to be `void`
- easy to forget to check the return value*
- requires long else-ifs/switches to check what has actually happened
- quite tedious to propagate

**\*:** Not with a certain **attribute**. This issue has been generally resolved in as forced compilcation warnings about unused data.

## out parameter

A variation of the result status but now as a non-const out paramater.

```c++
int func(error_code& ec); // returns error_code::ok on success
```

Advantages

- still simple
- can be used with non-void functions

Disadvantages:

- requires long else-ifs/switches to check what has actually happened
- code becomes less clear (out parameters are rarely used)

<div class="note info">
Remainder: non-const references do not accept rvalues so `func(error_code())` will not work. Passed argument must outlive the function.
</div>

## monads

```c++
std::optional<std::string> func();
std::expected<std::string, error_code> func();
```

Advantages:

- forces to correctly handle errors (safe)
- can be used with any function
- intuitive return type
- easy to propagate

Disadvantages

- verbose (this might be disputed)