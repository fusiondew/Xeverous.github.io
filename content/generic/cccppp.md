---
layout: article
---

Note: all rulies apply to "modern C++" where it is assumed that the project is written in C++11 or later standard.

___

## relying on unqualified/argument-dependent name lookup when qualified name lookup should be used (aka namespace pollution)

More precisely known as:

```c++
using namespace std;
```

There are tons of places where you can read read it's a terrible practice. **It's the \#1 the most trivial and the most common C++ mistake ever made. But it's often the first thing which is recommended for beginners and presented in hello world examples.**

So what's the actual problem with this statement? - It's in the title. Placing a namespace using allows to shorten names of their namespaces - eg `std::cout` to `cout`.

This might seem trivial but is dangerous in practice. By using unqualified names different (read: more permissive) lookup rules are used which can have terrible consequences.

Suppose there are 2 libraries: *libfoo* and *libbar*. Library *foo* offers function `void func(double)` in it's namespace.

The following code works as expected. `func(123)` is resolved to call `foo::func()`.

```c++
#include <libfoo/libfoo.hpp>
#include <libbar/libbar.hpp>
#include "my_project/my_class.hpp"

using namespace foo;
using namespace bar;

// .. some method ...
{
    func(123);
}
```

Now, consider this: library *bar* is updated and it also offers a function named `func` but in it's own namespace. The function signature is `int func(int)`.

Qualified name lookup would just search for the function in the specified namespace.

Unqualified lookup searches function in:

- the enlosing scope
- the scope of current class and it's parents
- all "used" namespaces
- all namespaces that are origins of function arguments (argument-dependent lookup)
- global scope

[Rules regarding unqualified lookup](https://en.cppreference.com/w/cpp/language/unqualified_lookup) are pretty long and not trivial to remeber. What's worse, *name lookup examines the scopes \[...\] until it finds at least one declaration of any kind, at which time the lookup stops and no further scopes are examined*.

**Suddenly the line in the code above changes it's meaning. Now `bar::func()` will be called because it better matches arguments. A change in completely unrelated code affected this code causing a hidden bug.**

What's worse:

- **Such bugs are incredibly hard to find.** No errors, no warnings - or even less if the previous function invokation was causing some - now we have a better overload match.
- **Such bugs do not have to be created by big changes like library update.** They might aswell be introduced by a header which contains such usings - **including such header pollutes recursively all files that use it**.
- **Such bugs may continuously appear and disappear depending on included files.**
- **Such bugs will likely not be detected by unit tests.** They will test proper function but the code above will just call a different one.
- **This is the most trivial example of such bug.** It's possible to get even more obscure bugs if we consider:
    - argument-dependent lookup
    - implicit convertions
    - template argument type deduction
- **The code is hard to understand.** Readers will have problems finding which function from which library is used.
- Various standard library headers can include other standard library headers (eg to provide constructor overloads). Standard library names are often common words which may clash. There exists 2 overloads of `std::move` that do something completely different (one from `<utility>` and one from `<algorithm>`).
- Implementations of the C++ standard library often have to use system-specific functions. Since most operating systems offer their API in C and C does not have namespaces, **the global scope is already polluted by C functions included and used in standard library implementation**. A lot of system-level code is undocumented which leaves us with no knowledge what can actually be there.

Namespaces were created to avoid name conflicts. Use of namespace usings defeats the purpose of namespaces which can cause name conflicts.

Besides name-clash-free code, there are other benefits of explicitly used namespaces

- Code clarity. Readers know exactly what you are doing.
- Code searchability. You can `grep -rn "libfoo::" my_project/src` to find all uses of the library/function/class.

**Legitimate uses of namespace usings**

- Local statements (eg inside function). Such using affects only the enclosing scope. Some might say it's okay to use it at global scope in source files since they are not (at least should not be) included - I would be careful with this - you can still get name clashes in 1 source file.
- Defining aliases to shorten code. This the proper solution to long names.

```c++
#include <boost/test/unit_test.hpp>
#include <filesystem>

namespace fs = std::filesystem;
namespace ut = boost::unit_test;
```

- Local usings for certain names:

```c++
// inside a function
using std::cout;
using std::cin;
```

**Swap implementation**

Before C++11, there was an idiom to place a using to allow both standard `std::swap` and member `current_class::swap` to be available for overload resolution. The member function (if exists) would be tried first, then the standard one.

Since C++11 changes to name lookup and added move semantics `std::swap` implementation has changed and the following idiom no longer has any use.

Still, the idiom required just `using std::swap` in the local scope of the function.

More info + example - [see this](https://stackoverflow.com/a/14395960/4818802).

## manual memory management

TODO

## unnecessary large lifetime

```c++
int func(/* ... */)
{
    int a;
    int b;
    float x;

    // ... 10 lines
    // a and b used for the first time

    // ... 20 lines
    // x finally used

    return x;
}
```

This is a bad habit coming from C89 where all local variables had to be declared first before any are used. Since C99 it's no longer required. This requirement was just a limitation of first compilers.

**Declaring variables before use is an antipattern** - too large scope impacts readers cognitive load and creates more opportunities for mistakes. **Declare variables as late as possible with minimal scope required and use them instantly.**

## arrays with non-constant size

*ignoring lack of `std::array` for this one*

```c++
int arr[n]; // where n is not a compile-time constant
```

This was never a valid C++ code.

This was only valid in C99 but the feature of arrays with non-constant size was optional. Feature has been removed in C11.

<div class="note warning">
Many compilers accept it as non-standard extension. Note that there are no guuarantees on stack size and `n` big enough will cause undefined behaviour.
</div>

## deprecated includes

```c++
#include <stdlib.h> // C, deprecated in C++
#include <cstdlib>  // only C++
#include <math.h>   // C, deprecated in C++
#include <cmath>    // only C++
```

Most of `<xxx.h>` (original C header names) have their equivalent `<cxxx>` name in C++.

Apart from names, there are 2 differences:

- Old headers put names directly in global scope, newer in C++ standard namespace - newer headers do not pollute global scope
- Old headers contain stuff imported from C which was available at that time. Newer headers are updated - some things can be found only in newer ones.

Multiple `<xxx.h>` headers are not available in C++. They have been replaced by C++ keywords, language features or standard library.

## camelCase and PascalCase name style

I don't know who/what started this trend (maybe Java?). This may seem more of cosmetic problem, but it can hurt.

It's also mentioned in [CPPCG NL.10](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#nl10-prefer-underscore_style-names).

The use of underscores is the original name style in C. C++ followed this convention, including standard library functions, classes, aliases and other names.

Underscore names for classes are not as strictly important as for functions but they do hurt once you interact more deeply with the standard library:

- standard library [iterator traits](https://en.cppreference.com/w/cpp/iterator/iterator_traits) expects **type names** `value_type`, `difference_type` and few others. If you use other name style the relevant code will just not compile.
- standard library random distribution names would be controversial if written using camel case notation
    - `std::student_t_distribution`
    - `std::fisher_f_distribution`

Camel case names for functions can be weird and unintuitive. I have worked in some android project (obviously there was some OS-level interaction) where I could find functions `ToStdString()`, `ToStatusT()`. It took me some time (haven't seen the string one first) to figure out that the second one returned android's `status_t`.

Other arguments:

- camelCaseIsHardToRead. dontBelieveMe? thereAre[StudiesWhichConfirmThis](https://www.researchgate.net/profile/Bonita_Sharif/publication/224159770_An_Eye_Tracking_Study_on_camelCase_and_under_score_Identifier_Styles/links/00b49534cc03bab22b000000/An-Eye-Tracking-Study-on-camelCase-and-under-score-Identifier-Styles.pdf).
- People argue about whether to capitalize words of length 1-2 and shortcuts. `ExportAsXml()` or `ExportAsXML()` or `exportAsXml()` or `exportAsXML()`? `export_as_xml()`! With snake case, there are no doubts.
- Underscores are more 1337 (read: leet). We even got `std::compare_3way()`.
