---
layout: article
---

C++ uses the same build model as C, which requires header files to provide names for other translation units.

Each source file is compiled separately and it needs to include headers to provide required names.

## one definition rule

For any symbol, there can be only one definition.

Any declaration can be repeated as long as all are the same. There are some corner cases and few things (eg specifying default arguments) can not reappear in multiple declarations so to avoid problems it is recommended to put them in headers and then include them.

## summary

In short, haders should contain:

- template definitions
- class definitions
- function declarations
- global object definitions (this includes static members)

and source files:

- function definitions
- global object instances

`inline` can be added to functions and some* static variables to allow them to have multiple definitions. This is commonly done for very small functions to avoid having to implement them in separate file.

Some - formerly only possible for built-in types, with many later standards extended.

## example code

header

```c++
// templates needs to be fully defined at the moment of instantiation
// forward declaring templates is useful only for other templates
template <typename T>
void func(const T& t)
{
	/* do stuff */
}

namespace ns {
	void free_func();
}


class foo
{
public:
	foo(const foo&) = delete; // no definition
	foo(foo&&) = default;     // default definition

	int bar() const;
	inline int get_member() const { return member; }

	static int s;
private:
	int member;
};
```

source

```c++
void ns::free_func() // or namespace ns { void f... }
{
	/* do stuff */
}

int foo::s;

int foo::bar() const
{
	/* do stuff */
}
```
