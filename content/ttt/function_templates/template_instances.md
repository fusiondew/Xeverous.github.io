---
layout: article
---

# Template instances

### declarations and definitions

Templated functions, like ordinary functions can still be declared and defined later. Template aliases are also a part of function signature:

```c++
// declaration
template <typename T> // <- this line is also needed
void func(const T&);

// definition
template <typename T>
const T& min(const T& x, const T& y)
{
	if (y < x)
		return y;
	else
		return x;
}
```

The difference (compared to ordinary functions) is that there is not much point in doing so - full template body must be available before it's used (instantiated). Placing definition in a source file will not work - we can not compile code, which uses such abstractions - the compiler does not know what `T` is and thus what machine code to generate for it. Note: You may succeed with it, but it means you have used a compiler extension or were lucky with alredy done instantiations.

Because of this, templates are rarely split into declarations and definitions. In 99.9% of cases, only definition is written and placed in header file. Then each soure file that uses the template can see it's full definition and *instantiate* it with certain type(s). In that 0.01% of cases, there are 2 templates that may call each other (same problem as with 2 ordinary functions) and at least one must be declared to write the definition of the second.

### multiple instantiations

`template` keyword implies `inline`. This means you will not run into problems of multiple definitions due to multiple same instantiations.

```c++
// all in the same source file
char a1 = min('a', 'A'); // min<char> is instantiated
int  n1 = min(3, 4);     // min<int> is instantiated
int  n2 = min(5, 6);     // min<int> already instantiated, reusing exising one
```

If multiple source files instantiate the same template with the same types, at linking stage redundant definitions will be discarded.

### two phase lookup

Because templates are usually written in headers and usually used within source files, each time the template is instantiated it's source code is looked upon again.

It's parsed first time, when the file with definition is included.

It's parsed second time, when the template is instantiated with specific alias(es).

This process is named **two phase lookup**.

ordinary function:

definition => compilation

templated function:

template definition => instantiation => compilation

For ordinary functions, there is no instantiation step because everything is known in order to compile the code.

For templates, at first stage trivial errors are verified - such as ommited semicolon or parenthesis - these are simply syntax errors or violations of core language rules. At second stage (when the template is instantiated) more information is available and the rest of things can be verified.

##### Example:

Let's make a simple typo in the templated function and include it's header somewhere else:

```c++
// min.hpp
template <typename T>
const T& min(const T& x, const T& y)
{
	if (y =< x) // this should be caught at first stage
		return y;
	else
		return x;
}

// main.cpp
#include "min.hpp"

int main()
{
}
```

ERROR HERE

The error appeared even without template being used. Invalid syntax was catched at the first stage

Now let's make the template valid again, but use it with type that does not support `operator<`

```c++
// min.hpp
template <typename T>
const T& min(const T& x, const T& y)
{
	if (y < x)
		return y;
	else
		return x;
}

// main.cpp
#include "min.hpp"

struct foo {};

int main()
{
    foo a;
    foo b;
    foo m = min(a, b); // should not work with T = foo
}
```

ERROR HERE

This time the error was catched at the second stage (instantiation). If you comment the line where `min()` is used the error will not appear - at the first stage, it can not be decided whether something will work or not.

This is one of the reasons why sometimes you may encounter nested errors with some of them pointing inside standard template library - it's possible to write a syntaxically valid template but only upon instantiation it's verified that it makes sense for the given types.


### explicit instantiations

### deduction traps

Templates try to match the type as closely as possible. A good example is this program:

```c++
// min.hpp
template <typename T>
const T& min(const T& x, const T& y)
{
	if (y < x)
		return y;
	else
		return x;
}

// main.cpp
#include "min.hpp"
#include <iostream>

int main()
{
    std::cout << min("foo", "bar") << "\n";
}
```

The program prints "foo\n". But - why? Isn't "bar" < "foo"?

The answer is that it is not. Everything is ok. The problem lies in deduction - the template was instantiated with `T = char[4]`. So after substituting the T, function operated on const reference to 4-char arrays - array names have fallen into implicit convertion to `const char*` when being compared. Pointer values were compared, not character sequences lexicographically. Since addresses have unpredictable values, both answers may be correct depending on the used compiler.

**Templates perform minimal effort to match the type. Templates do not like convertions.**

If we want to make this example work, we need a different type. Raw character arrays do not only support `operator<`, but also fall into `const char*` in expression `y < x` which enables very unintuitive comparison of addresses.

We can ommit deduction and state type explicitly. Standard library offers 2 good choices:

```c++
min<std::string>("foo", "bar")
min<std::string_view>("foo", "bar") // C++17
```

Both of these have overloaded operators which implement lexicographical comparison.

There is a simple way to avoid this problem - **template specialization**.