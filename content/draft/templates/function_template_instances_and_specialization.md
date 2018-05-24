# function template instances

If you write a sample template

```c++
template <typename T>
void func(const T& obj)
{
	obj.foo();
}
```

it is not fully resolved at parsing stage. It is unknown what `T` is now. The function will compile only for Ts for which `.foo()` makes sense.  

Each time you use a templated function, it's parsed (instantiated) like a normal function with concrete type. This means that for each different type you use a function, a separate assembly is created. This process is named template instantation. `min()` is a function template, `min<int>` is a function template instance. If you don't use a given template, nothing is created and the program is the same as no such template was written.

From cppreference:

> A function template by itself is not a type, or a function, or any other entity. No code is generated from a source file that contains only template definitions. In order for any code to appear, a template must be instantiated: the template arguments must be determined so that the compiler can generate an actual function (or class, from a class template).

# External templates

Since each time a template is used it's reparsed for a certain type, it can be a waste of time if multiple source files include the same header and use the same template instantiation.

C++ templates can be very complex and require lot of computation power to compile. C++ template-based equivalents of C programs can build more than 10 times slower. 

You can write `extern template _name_<_type_>` in a source file to inform the compiler to not instantiate the template for the given type here. This reduces build times by avoiding duplicate work.

See [this SO question](https://stackoverflow.com/questions/8130602/using-extern-template-c11) for examples and more detailed description.

# Function template specialization

Suppose we have a such duplicating function

```c++
template <typename T>
T duplicate(T obj)
{
	return obj + obj;
}
```

This way `duplicate(5)` returns `10` and `duplicate(3.14)` returns `6.18`.

Similarly `duplicate(std::string("foo"))` (or `duplicate("foo"s)` since C++14) returns `"foofoo"`. But what if we don't like it? It would be nice to have words separated by space. We would like `duplicate()` to behave differently for `std::string`.

This is an example situation where template specialization can be used. We can define a different body for some concrete type - in this case standard string.

```c++
template <>
std::string duplicate<std::string>(std::string obj)
{
	return obj + ' ' + obj;
}
```

Note few things:

- `template` is always required, but since we no longer alias any type, we leave `<>` empty. `<>` obeys the same rules as function with no arguments - you still have to write `()` if the function does not take any arguments - and so is done with templates if they do not alias anything.
- we write `duplicate<std::string>`, not `duplicate` - this is the core part of template specialization. We substitute alias with a concrete type by adding `<std::string>` to the name.
- since we specialize template, we replace all specialized aliases with actual type; in this example there was only one type so now no `T`s are left

The thing above is named *(function) full template specialization*

It is possible to have a template with multiple aliased types and specialize only few of them. Then it is a *partial template specialization*. However, **partial template specialization for functions is not allowed**. In later guides, partial template specialization examples will be shown for class and variable templates.

TODO - specialization for `T*`.

# Function template specialization vs function overloading

You can consider function template as infinitely many overloads at once. There are [complex rules](http://en.cppreference.com/w/cpp/language/overload_resolution) describing how templates interact with function overloading. This is one of the reasons why partial template specialization for functions is not allowed.

In general, the candidate function whose parameters match the arguments most closely is the one that is called.

Brief description of the process:

- [name-lookup](http://en.cppreference.com/w/cpp/language/lookup) - declarations are searched for given names
  - [qualified name lookup](http://en.cppreference.com/w/cpp/language/qualified_lookup) - names appearing on right hand side of `::` are searched in scopes that appeared on the left side of `::`
  - [unqualified name lookup](http://en.cppreference.com/w/cpp/language/unqualified_lookup) - names are searched, starting from enclosing scope to most outer parent scope (up to global scope)
    - [argument-dependent lookup](http://en.cppreference.com/w/cpp/language/adl) - function names are searched in argument namespaces in addition to unqualified name lookup
  - [template argument deduction](http://en.cppreference.com/w/cpp/language/template_argument_deduction) - types for missing (not specified explicitly or defaulted) function argument type aliases are deduced from argument expressions (since C++17 also classes)
    - [template argument substitution](http://en.cppreference.com/w/cpp/language/function_template#Template_argument_substitution) - all template type parameters (including unused ones) are replaced by concrete types; [SFINAE](http://en.cppreference.com/w/cpp/language/sfinae) can happen 
- [overload resolution](http://en.cppreference.com/w/cpp/language/overload_resolution) - a function with the most closest type to the argument types is choosen

As of now, I would discourage combining function templates and non-template overloads. Example problem:

```c++
class Base {};
class Derived : public Base {};

void func(const Base& base); // 1

template <typename T>
void func(const T& obj); // 2

{
	Base b;
	Derived d;
	func(5);    // calls 2 with [T = int]
	func(3.14); // calls 2 with [T = double]
	func(b);    // calls 1
	func(d);    // calls 2 with [T = Derived]!
}
```

The problem comes from the fact that 2nd overload with `T = Derived` is considered a perfect match while 1st would need implicit convertion from `Derived` to `Base`. You can avoid this problem by SFINAE idiom which is preseted later but now better just don't mix these.



TODO

more examples

TODO

Note: omitting <> entirely allows overload resolution to examine both template and non-template overloads.



























