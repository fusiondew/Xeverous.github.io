---
layout: article
---

## error propagation

Assume that something important has failed and we have thrown an exception. What does it mean exactly?

**What happens when an exception is thrown**

Exceptions immediately exit from the throw statement and move upwards of the stack untill a matching handler is found.

**Note:** throwing an exception will still call relevant objects destructrors.

**Note:** exceptions can perform assembly-level jumps of arbitrary length. They can and will ignore everything on their path upwards the stack until a handler is found. Any code (except destructors) will not be executed until a handler is found.

## stack unwinding

The process which happens when an exception is thrown is known as **stack unwinding**. An arbitrary amount of code is skipped (while going upwards) untill a handler is found.

**Example**

```c++
#include <exception> // std::exception
#include <stdexcept> // more standard library exception classes
#include <iostream>

void foo1() { std::cout << "foo1\n"; }
void foo2() { throw std::runtime_error("foo2() failed"); }
void bar1() { std::cout << "bar1\n"; };
void bar2() { std::cout << "bar2\n"; };

void foo()
{
    std::cout << "foo starts\n";
    foo1();
    foo2();
    std::cout << "foo ends\n";
}

void bar()
{
    std::cout << "bar starts\n";
    bar1();
    bar2();
    std::cout << "bar ends\n";
}

void run()
{
    std::cout << "run starts\n";
    foo();
    bar();
    std::cout << "run ends\n";
}

int main()
{
    std::cout << "program start\n";

    try {
        std::cout << "beginning execution\n";
        run();
        std::cout << "ending execution\n";
    }
    catch (const std::exception& e) {
        std::cout << "caught exception with message: " << e.what() << "\n";
    }

    std::cout << "program end\n";
}
```

Program flow:

~~~
main()                                    
    try                                  /|\ handler found
        run()                             |
            foo()                         |  stack unwinding...
                foo1()                    |
                foo2() <-- exception here |
            bar()
                bar1()
                bar2()
    catch
~~~

Output:

~~~
program start
beginning execution
run starts
foo starts
foo1
caught exception with message: foo2() failed
program end
~~~

An exception inside `foo2()` has been thrown. Stack unwinding begins:

- find a handler inside `foo2()` - there isn't any
- execute destructors of any local objects of `foo2()`
- move upwards to `foo()` where `foo2()` was run
- find a handler inside `foo()` - there isn't any
- execute destructors of any local objects of `foo()`
- move upwards to `run()` where `foo()` was run
- find a handler inside `run()` - there isn't any
- execute destructors of any local objects of `run()`
- move upwards to `main()` where `run()` was run
- find a handler inside `main()` - found
- match exception type with handler - found
- execute handler (catch) block
- resume execution **past** all catch blocks

`bar()` (and it's subfunctions) never got executed. This is because they were after `foo()` which has thrown in `foo2()`. **Exceptions skip all code until they are catched.**

## try-catch blocks

When you want to `catch` an exception you need to wrap around the expected code.

- `try` and `catch` blocks always have to be together.
- `catch` blocks may happen multiple times.

When an exception occurs, it's tested for type match with catch blocks in the order of their appearance. Exception matches if it's type is the same as in the catcher or type derived from it.

- If a match is found, relevant catch block is executed. After it's executed (and no new exceptions/rethrowing happended), exception object is destroyed and program continues **past all** catch blocks
- If a match is not found, exception continues to propagate and unwind the stack untill another try-catch block is found

Catching exception works similarly to passing arguments to functions. Most notably, **to prevent object slicing you should catch exceptions by (const) reference**.

**Example:**

```c++
#include <iostream>
#include <exception>

class a_exception : public std::exception {};
class b_exception : public a_exception {};
class c_exception : public b_exception {};
class d_exception : public c_exception {};

void func()
{
    // throw what you like here
}

int main()
{
    std::cout << "program start\n";

    try {
        std::cout << "before func()\n";
        func();
        std::cout << "after func()\n"; // if func() throws this is never executed
    }
    catch (const d_exception& e) {
        std::cout << "caught d exception\n";
    }
    catch (const c_exception& e) {
        std::cout << "caught c exception\n";
    }
    catch (const b_exception& e) {
        std::cout << "caught b exception\n";
    }
    catch (const a_exception& e) {
        std::cout << "caught a exception\n";
    }
    catch (const std::exception& e) {
        std::cout << "caught standard exception\n";
    }
    catch (...) {
        std::cout << "caught unknown exception\n";
    }

    std::cout << "program end\n";
}
```

Suppose `func()` throws `b_exception`, then:

- first catch block is ignored because `b_exception` is not (a child of) `d_exception`
- second catch block is ignored because `b_exception` is not (a child of) `c_exception`
- third catch block is matched (types are identical); it is executed
- program continues past last catch block

Effectively, the program prints:

~~~
program start
before func()
caught b exception
program end
~~~

<div class="note pro-tip">
Place catch blocks starting with the most derived type, ending on the most base type. If you do the reverse (eg standard exception class first) exception handling will never execute derived type handlers.
</div>

## catch all

`catch (...)` will catch every exception regardless of it's type (it might not be even a class, just whatever that was thrown)*.

The good is that it catches everything. The bad is that you don't know the type of catched exception and have no way to use it.

Obviously catch-all block should be always the last.

**\*:** It will not catch language-extension exceptions, like the OS-level exceptions offered by Microsoft (eg null dereference exception instead of crash) - these require their own `__try` and `__except` implementation-provided keywords.

TODO lippincott http://cppsecrets.blogspot.com/2013/12/using-lippincott-function-for.html

## advantages of try-catch blocks

Exceptions can happen in an arbitrary place of code. Even if the same function is used and it throws the same exception, the handler is dependent on where the function is used. Function can be called multiple times in the entire program and each time the enclosing stack can be different - this gives the flexibility and modularity.

An exception in order to be catched, must be first inside a `try` block.

```c++
// code A

try {
    // code B
}
catch (/* ... */) {
    // code C
}
catch (/* ... */) {
    // code D
}

// code E
```

If code A throws, an exception from it will not be catched. At least not here - in order to catch it the entire A-E needs to be enclosed by a try block or be a function that is enclosed by a such block.

The same applies to C, D and E - exceptions from these places will leak out.

___

Sometimes you may want to wrap the entire program to prevent exceptions leaking from main function. This can be used to eg save logs, inform the user and safely close the program.

```c++
int main()
{
    try {
        // almost entire program
    }
    catch (...) {
        // log crash information, notify user
    }

    // any other always-necessary closing code
}
```
