---
layout: article
---

## error propagation

Assume that the update failed and we have thrown an exception. What does it mean exactly?

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

