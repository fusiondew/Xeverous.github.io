---
layout: article
---

Exceptions separate error creation from it's handling. There are 2 parts:

- throwing - raising an error

```c++
if (!config_file.load())
    throw no_configuration_file_exception();
```

- catching - running a handler for an error and resuming execution

```c++
catch (const std::exception& e)
{
    log.add_error(e.what());
    refresh();
    reload();
}
```

Before raising an error, we need to know what has gone wrong. This is done by **exception objects**.

This lesson will tell you:

- when to throw
- what to throw
- how to throw

Next lesson will tell you:

- when to catch
- what to catch
- how to catch

## exception classes

Exceptions classes are nothing more than types specifically designed for the purpose of being an error information. A good exception class contains all relevant information what has gone wrong and when.

In most programming languages offering exceptions, each exception class has to implement certain exception interface (be derived from specific language-provided base excepion class). Such interface allows for polymorphic treatment of errors and uniform access. Error handlers can react in a unique way to specific errors but also treat them through interface (just base exception class) if it's not an expected problem.

In C++, exception classes do not have to be derived from `std::exception`. What's more, in C++ exceptions do not even have to be classes - you can aswell throw any other type.

Obviously if someone decides to use exceptions as an error handling, throwing non-class exception objects is defeating the purpose of exceptions' polymorphism and providing relevant information. Exception classes are expected to be derived from standard exception, otherwise we lose the benefit of polymorphism.

<div class="note pro-tip">
When creating exceptions, make them classes (even if they hold nothing or just 1 variable).
</div>

<div class="note pro-tip" markdown="block">
Exception classes should inherit from `std::exception`. Use descendants of `std::exception` as base classes only if they make sense - most library-provided types have very generic names.

[CPPCG E.14](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#e14-use-purpose-designed-user-defined-types-as-exceptions-not-built-in-types)

[C++ library-provided exception classes](https://en.cppreference.com/w/cpp/error/exception)
</div>

## exception interface

C++ standard exception class:

```c++
class exception
{
public:
    exception() noexcept;
    exception(const exception& other) noexcept;
    exception& operator=(const exception& other) noexcept;
    virtual ~exception() noexcept;

    virtual const char* what() const noexcept;
};
```

This is the interface that exception classes are expected to implement. It should not have a copy ctor/assignment but:

> 15.1.5 When the thrown object is a class object, the copy/move constructor and the destructor shall be accessible, even if the copy/move operation is elided (12.8).

I have no idea why standard requires it as it is an antipattern but at least I can tell you that really noone copies exception objects.

The most important part is the `what()` function. It tells what has actually happened. By default (this is not a pure virtual) it returns `""` which is not very usable.

`noexcept` means that the function is not expected to throw exceptions. More about it - soon.

## when to use exceptions

- failing to meet a postcondition

An advanced object manager provides `operator[]` which returns `const T&`. What if an index is invalid? There is no way it could return a valid reference. Exception in this case is better than undefined behaviour (note: this applies to higher-level structures - things like maps and vectors should not waste by checking everything).

In many situations, all values of the return type are considered valid. There is no other way to force error than throwing.

- failing to meet a precondition

Memory allocation, file load, update/refresh-like functions. Basically anything that is crucial to continue the program.

- failure to establish class invariant

Constructor fails. What can be done with an object that has undefined state? What will happen if we do not notice that an object is broken? Throwing in such situation is definitely better than leaving a hidden bomb.

<div class="note info">
Throwing from a constructor does not invoke current class destructor. If you allocated any resource while trying to establish class invariants, do cleanup before throwing.
</div>

## example situation

Suppose we are writing a client for an on-line game. One thing that is very important is to always update the client - otherwise game will not communicate properly with other clients and servers.

Generally this might seem to be a trivial task (check version, compute file difference, download, replace files, verify checksum) but trust me, everything that has to interact with file system has tons of possible places for a failure.

<div class="note pro-tip">
Use exceptions for exceptional situations. Something that you can not easily solve.
</div>

Apart from all networking errors, a thing that many may forget is remaining space on disk. There is nothing more that we can do than stopping the program and informing the user.

Here is an example such exception:

```c++
#include <exception> // required for std::exception

class no_space_on_disk_exception : public std::exception
{
public:
    explicit no_space_on_disk_exception(int remaining_space, int required_space)
        : remaining_space(remaining_space), required_space(required_space)

    const char* what() const override noexcept
    {
        return "not enough space on disk";
    }

    int get_remaining_space() const noexcept { return remaining_space; }
    int get_required_space() const noexcept { return required_space; }

private:
    int remaining_space;
    int required_space;
};
```

and example use:

```c++
file_diff game_updater::compute_file_difference() const
{
    const file_diff difference = /* ... */;

    namespace fs = std::filesystem;
    const fs::space_info disk_space = fs::space(config.get_game_installation_path());
    if (disk_space.available < difference.get_required_space())
        throw no_space_on_disk_exception(disk_space.available, difference.get_required_space());

    return difference;
}
```

Computing the file difference may also throw (no access permission, disk error etc). Both are generally errors we can not recover from.

From the viewpoint of the updater task, it has done it's job correctly. It can not solve the problem of insufficient disk space, so it throws and delegates this problem to different (enclosing) parts of the program.

## other cases

A specialized formatting function expects correct amount of arguments and valid format string.

```c++
fmt::print(format_str, date, username);
```

If for example `format_str == "{1}: {2}\n"` it has to react somewhat - there is no 2nd argument (and 0th is unused). **We should not implement code that tries to avoid the issue** (eg by partial print or no print) - don't hide, fail early and greatly.

The function can not perform it's task due to invalid input - precondition is not satisfied. Best way to report it - `throw invalid_format_exception();`.

**Note:** [there is such library](https://github.com/fmtlib/fmt). Proposed for C++20 standard.

___

Similar case, a regular expression can not run without valid expression:

```c++

try {
    std::regex rgx_date(R"([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])");
    //                                                                   ^ missing )

    // perform matching...
} 
catch (const std::regex_error& e) {
    std::cout << "caught regex error: " << e.what() << '\n';
}
```

~~~
caught regex error: Parenthesis is not closed
~~~

Guess how disastrous it could be if it hide the problem and did not match any string.
