---
layout: article
---

Another case when you might want to catch an exception is the constructor of the parent class.

```c++
#include <stdexcept>

class base
{
public:
    base(int x) : x(x)
    {
        if (x < 0)
            throw std::logic_error("x can not be negative");
    }

private:
    int x;
};

class derived : public base
{
public:
    derived(int x) : base(x) // what if base constructor throws?
    {
    }
};
```

It's possible using **function-try-block**.

```c++
#include <stdexcept>

class base
{
public:
    base(int x) : x(x)
    {
        if (x < 0)
            throw std::logic_error("x can not be negative");
    }

private:
    int x;
};

class derived : public base
{
public:
    derived(int x) try : base(x)
    {
        // ctor body
    }
    catch (const std::exception& e)
    {

    }
    catch (...)
    {
        
    }
};
```

There are few things worth noting though:

- In any catch block, you no longer can access parent classes and non-static members (compiler might allow such code but it's undefined behaviour).
- You can safely use arguments.
- `return` statements are not allowed in catch blocks.
- Every catch block has added hidden `throw;` at the end unless any throw statement is written.

## purpose

Since rethrowing is necessary (it would have no sense to stop exception in derived type while base type construction failed) you can at most choose whether to throw manually by writing some concrete throw statement or just let compiler automatically generate `throw;`.

Function-try-blocks give the immediate control in case of an exception, eg for the purpose of logging or to throw something different.

## non-constructor functons

It's also possible to use function-try-blocks for other functions than constructors.

```c++
int func(int n) try
{
    if (n < 0)
        throw std::logic_error("input non-negative value");

    return std::sqrt(n);
}
catch (const std::logic_error& e)
{
    log.add_error(e.what());

    // HERE
}
catch (...)
{
    // HERE
}
```

In this case automatic rethrowing does not happen. In the places "HERE" you should do one of two things:

- place a return statement (if the function returns non-void)
- rethrow / throw

Otherwise control reaches end of the function and there is no return value neither an exception. Undefined behaviour.

## other notes

- Function-try-blocks do not catch exceptions thrown by static object constructors. This applies specifically to the main function and functions that are launched in separate threads.
- In `catch` blocks, you can use function arguments, but not objects that were created in the `try` block.

## recommendation

This feature is very rarely used.
