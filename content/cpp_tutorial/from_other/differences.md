---
layout: article
---

This is a brief article showcasing most impactul differences between C++ and other C-family languages. Most valuable for people with Java and C# experience.

<div class="note warning">
#### Warning
<i class="fas fa-exclamation-circle"></i>
This is only overview article, it does not replace tutorial.
</div>

### typing

All types in C++ are value types (passed by value by default). All pointers and references must be explicitly declared. This is in contrast to C# (and somewhat Java) where structs are value types but classes reference types - C++ treats absolutely everything by value by default.

This is why most functions in C++ take parameters by (const) reference - it's very normal to append `&` to every bigger object to avoid expensive (often allocating) copies.

```c++
void func(const std::string& str);
```

### loops

C++ offers for each loops (technically named range-based loop), the syntax is identical to the one in Java:

```c++
for (const std::string& str : arr) // note that by const/reference applies just like with function arguments
```

It is possible to write an own type which supports range-based iteration (requires certain member functions and their properties).

### inheritance

C++ has no notion of interfaces, however there are no restrictions on class members and inheritance - the border is very fluid. If you want to create an interface, simply don't add any member variables. If one or more function is pure virtual (has no defined body) the class implicitly becomes abstract.

Multiple inheritance is allowed, including situations where more than 1 parent class has member variables, although rarely used in practice - almost everywhere regular recommendation is followed (0 or 1 parent class and 0+ interface-class parents).

There are also:
- virtual inheritance (solves [diamiond problem](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem))
- protected/private inheritance (blocks upcasting, parent class becomes non-public implementation detail)
- recursive-like inheriting from own template (used in specific template pattern to implement compile-time polymorphism with no virtual call overhead - CRTP)

### resource management

C++ does not have garbage collector, instead [RAII](https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization) idiom is used. These are mostly zero-overhead abstractions over memory allocation, which crucial part are destructors.

It is a big mistake to use raw owning pointers and `new`/`delete` in modern C++ (unless you are writing own data structure, smart pointer or an allocator).

RAII is used mostly for memory management (smart pointers) but other resources can also be encapsulated.

### exceptions

Exceptions in C++ are quite rare and the standard library is very minimal in this regard. Many projects don't use them (disable with compilation flags) for performance reasons and the standard library rarely has even a possibility to throw.

The base standard class for every exception is `std::exception` which has only one method to override:

```c++
virtual const char* what() const noexcept;
```

You can derive directly from `std::exception` or [it's descendants](http://en.cppreference.com/w/cpp/error/exception).

Note that this is not a requirement, C++ allows to throw anything, including things not derived from standard exception class or even plain non-class types such as integers. Of course if exceptions are used, it's recommended to derive from standard exception class or create own tree of classes for this purpose.

It's strongly recommended to catch by const reference

```c++
catch (const std::exception& e)
{
    std::cout << e.what() << '\n';
}
```

It's possible rethrow (write `throw;` inside a catch block) and catch everything possible (`catch (...)`)

<div class="note info">
#### finally
<i class="fas fa-info-circle"></i>
C++ does not have `finally`. Use RAII idiom (destructor-encapsulated resource management) instead.
</div>

### templates

C++ offers very advanced template metaprograming. Everything is resolved at compile-time and optimized for each use case. Template specialization, SFINAE and concepts can be used to further customize behaviour depending on the properties of types.

Multiple templates exist:
- of functions
- of classes
- of aliases
- of variables
- of other templates

C++ templates can be viewed as a separate, Turing-complete purely functional language. This can be mixed with imperative programming and other compile-time features of C++.

It's hard to briefly showcase the full power of templates, just note that
the tutorial about templates is one of (if not #1) the longest tutorials on this website. Functions and classes accepting `T` is not even a 1 complete chapter.

### documentation

C++ has no standarized documentation model, however practically every project uses [Doxygen](https://en.wikipedia.org/wiki/Doxygen) which has became the unofficial standard tool.

Doxygen is just a replica JavaDoc with minor changes to accomodate to C++ language (eg `@tparam` for template parameters). If you have worked previously with Java, you already know how to document C++.

Doygen offers multiple options, and some alternative syntax but in most cases defaults are used for intuitive compability with JavaDoc.
