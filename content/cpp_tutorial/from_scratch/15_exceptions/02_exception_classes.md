---
layoout: article
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

Before raising an error, we need to know what has gone wrong. This is done by **exception classes**.

This lesson will tell you:

- when to throw
- what to throw

## exception classes

Exceptions classes are nothing more than types specifically designed for the purpose of being an error information. A good exception class contains all relevant information what has gone wrong and when.

In most programming languages offering exceptions, each exception class has to implement certain exception interface (be derived from specific language-provided base excepion class). Such interface allows for polymorphic treatment of errors and uniform access. Error handlers can react in a unique way to specific errors but also treat them through interface (just base exception class) if it's not an expected problem.

In C++, exception classes do not have to be derived from `std::exception`. What's more, in C++ exceptions do not even have to be classes - you can aswell throw primitive integer errors.

Obviously if someone decides to use exceptions as an error handling, throwing non-exception-classes is defeating the purpose of exceptions polymorphism and providing relevant information. Exception classes are expected to be derived from standard exception, otherwise we lose the benefit of polymorphism.

<div class="note pro-tip">
When creating exceptions, make them classes (even if they hold nothing or just 1 variable).
</div>

<div class="note pro-tip">
Exception classes should inherit from `std::exception` or it's descendants.
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

This is the interface that exception classes are expected to implement. We should not care about copy constructor and assignment operator - these are not used.

The most important part is the `what()` function. It tells what has actually happened. By default (this is not a pure virtual) it returns `""` which is not very usable.

`noexcept` means that the function is not expected to throw exceptions. More about it - soon.

## when to use exceptions

- failing to meet a postcondition

A data structure provides `operator[]` which returns `const T&`. What if an index is invalid? There is no way we could return a reference to an existing object. Exception in this case is better than undefined behaviour resulting from dereferencing end iterator.

In many situations, all values of the return type are considered valid. There is no other way to force error than throwing.

- failing to meet a precondition

Memory allocation, file load, update/refresh-like functions. Basically anything that is crucial to continue the program.

- failure to establish class invariant

Constructor fails. What can be done with an object that has undefined state?

## example situation

Suppose we are writing a client for an on-line game. One thing that is very important is to always update the client - otherwise it will have broken functionality.

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

    int get_remaining_space() const { return remaining_space; }
    int get_required_space() const { return required_space; }

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

From the viewpoint of the updater task, it has done it's job correctly. It can not solve the problem of unsufficient disk space, so it throws and delegates this problem to different (enclosing) parts of the program.
