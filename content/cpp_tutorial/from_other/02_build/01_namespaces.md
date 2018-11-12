---
layout: article
---

You might see this line a lot when browsing the internet:

```c++
using namespace std;
```

It shortcuts all names of the given namespace (here the one of the standard library), similary to usings in C#.

Vast majority of experienced people agree that it should be never used. So what is the problem with it? It is pretty much equivalent to these in other languages (if they existed):

TODO colorize?

```
using **.*;
import **.*;
```

The C++ standard library has very few names in nested namespaces and generic using for the first-level one imports most of the stuff.

When doing C++, a lot of standard/external libraries code may expose C stuff because they have to eg perform a syscall. This can result in very annoying, hard to find bugs related to function overloading and name lookup. What is worse, such bugs may appear and dissapear in each build just because someone changed order/appearance of some includes.

A very trivial example:

TODO paste using foo/bar libraries

It is recommened to use namespaces for any code, including the main project code to guard it from the world of C.

## justified alternatives

You can use (shorten) names in other, safe ways:

- namespace aliases

```c++
namespace fs = std::filesystem;
fs::path p; // ok
```

- usings for objects

```c++
using std::cout; // only cout will be exposed

cout << "x = " << x << "\n"; // ok
string str; // error: unknown indentifier
```

- type aliases:

```c++
// regular type alias
using string = std::string;

// a more fancy one :)
template <typename T>
using svector = boost::container::small_vector<T>;
// svector<int> = boost::container::small_vector<int>
// svector<String> = boost::container::small_vector<std::string>
```

#### Question: Why it is not `SVector<T>` on the left expression side?

Template specialization differs in syntax from primary template definitions. Templates in C++ are a complex topic and not everything might seem very intuitive. Dive into template tutorial if you would like to become a magician.

Fun fact: `std::string` itself is also an alias :). The true name with everything expanded is `std::basic_string<char, std::char_traits<char>, std::allocator<char>>`.

`typedef` can also be used, but is discouraged due to unintuitive syntax and not allowing templates.

```c++
using buf_t = unsigned char[4];
typedef unsigned char buf_t[4];

using func_ptr = void (*)(int);
typedef void (*func_ptr)(int);
```

All of the above can also be scoped:

```c++
void func(/* ... */)
{
	using namespace std; // only for this function
}

class foo // or namespace
{
public:
	using map = std::unordered_map<std::string, std::string>;
};

map m1;      // error
foo::map m2; // ok
```

## extending the standard library

C++ forbids to add any symbols to the standard library (namespace `std`) unless explicitly allowed (mostly template specializations). Namespace `posix` is also forbidden.

If you would like to extend the standard library, just do it in another namespace (eg `stdex`) or in global scope (especially for operator overloads).

## anonymous namespaces

C++ allows namespaces without names. Identifiers in such namespaces are then visible only in the *translation unit* they are defined.

```c++
namespace {
	// stuff...
}
```

Since multiple headers with a given source file create 1 translation unit, anonymous namespaces do not block it.

Unnamed namespaces as well as all namespaces declared directly or indirectly within an unnamed namespace have internal linkage - this can be used to resolve some name collisions accross different source files.

## shortcuts

- nested namespaces

```c++
namespace foo { namespace bar { namespace baz { } } }
// equivalent code, requires C++17
namespace foo::bar::baz { }
```

- inline namespaces

```c++
namespace foo {
	namespace bar { }
	using namespace bar;
}

// equivalent, requires C++11
namespace foo {
	inline namespace baz { }
}
```

Inline namespaces can be used for code versioning (especially templates), allowing to explicitly use certain versions and provide a default one.
