---
layout: article
---

TODO use monospaced font for tables in this article

When code is compiled and object code is produced, each chunk of executable code must have a way to be identified. Then the linker will search object files for used functions and their definitions, trying to link everything together to form an executable (exe, out, bin) or a library object (dll, so, a, lib and other files). This the point where *undefined reference* or *multiple reference* errors may happen.

## the need for name mangling

Simply identifying each function by it's name is not enough:

- What if there are multiple functions with the same name but in different namespaces?
- What if a function is overloaded?
- What if there is an unnamed entity that creates executable code (eg lambda expression)?

This is why **name mangling** is necessary. Name mangling is the process of decorating funcion (or function-like code) with additional information to distinguish it from other entities that have the same name. This allows multiple overloads to coexist in a single dynamic link library file (dll, so) with clear method of determining which source code corresponds to which machine code.

Decorated names are sometimes referred to as **symbols**.

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>function</th>
                <th>example mangled name</th>
            </tr>
            <tr>
                <td>int f(int)</td>
                <td>__f_i</td>
            </tr>
            <tr class="even">
                <td>int f()</td>
                <td>__f_v</td>
            </tr>
            <tr>
                <td>void g()</td>
                <td>__g_v</td>
            </tr>
        </tbody>
    </table>
</div>

In the example above you can see that function parameter types are encoded in the name, eg `i` means `int` parameter and `v` means `void` which means the function does not take any parameters (resembles `int f(void)` code).

Even though `g` is a unique name in this example, it's still mangled for consistency and any future additions which might introduce a function with the same name.

## calling conventions

C does not require any mangling, because language is simple enough that there is no possibility to have 2 entities with the same name - C does not have function overloading or namespaces.

Still, various compilers mangle function names from C code to differentiate functions using different **calling convention**. Calling convention is a specific way of passing arguments to functions - each convention can use processor's stack and registers in a different manner and return the result (if any) in a different way. Mangling dependent on calling convention makes sure that machine code using 2 different calling conventions will not be linked, which prevents undefined behaviour resulting from malformed use of registers or stack.

Here is an example of mangling for different calling conventions used on Windows:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>function</th>
                <th>example mangled name</th>
            </tr>
            <tr>
                <td>int _cdecl f1(int)</td>
                <td>_f1</td>
            </tr>
            <tr class="even">
                <td>int _stdcall f2(int)</td>
                <td>_f2@4</td>
            </tr>
            <tr>
                <td>int _fastcall f3(int)</td>
                <td>@f3@4</td>
            </tr>
        </tbody>
    </table>
</div>

Here `@` differentiates use of stack or registers and `4` specifies size in bytes of function arguments.

## mangling in C++

C++ is by far the largest user of complex name mangling schemes due to language complexity and various features that can result in identically named entities:

- namespaces
- classes (including anonymous classes)
- overloaded functions
- overloaded operators
- lambda expressions (anonymous functions)
- function templates
- class templates
- variable templates
- templates of templates

Compilers also encode various additional information to prevent linking incompatible code together:

- exception handling
- threading model
- calling convention
- architecture type (eg 32 vs 64 bit, little vs big endian)

There is no universally used scheme although some platforms have some specifications. Generally each compiler uses it's own scheme. Sometimes even different versions of the same compiler use different schemes, usually caused by addition of new hardware support or optimizations that make machine code incompatible with code compiled by older compiler versions.

Some C++ names can be extraordinary long - sometimes templates can go really insane when encoding type information.

mangled name:

~~~
.weak.__ZNSt8_Rb_treeIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIS6_St3mapIS6_St6vectorIS7_ISt10shared_ptrIKN3sfg8SelectorEES5_ESaISF_EESt4lessIS6_ESaIS7_IS6_SH_EEEESt10_Select1stISN_ESJ_SaISN_EE22_M_emplace_hint_uniqueIIRKSt21piecewise_construct_tSt5tupleIIRS6_EESW_IIEEEEESt17_Rb_tree_iteratorISN_ESt23_Rb_tree_const_iteratorISN_EDpOT_.__ZNSt15_Sp_counted_ptrIDnLN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
~~~

<details>
<summary>unmangled function:</summary>
<p markdown="block">

```c++
.weak._std::_Rb_tree_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > > > > std::_Rb_tree<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > > >, std::_Select1st<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > > > > >::_M_emplace_hint_unique<std::piecewise_construct_t const&, std::tuple<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>, std::tuple<> >(std::_Rb_tree_const_iterator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::map<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >, std::less<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const>, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const, std::vector<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::shared_ptr<sfg::Selector const>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > > > > > >, std::piecewise_construct_t const&, std::tuple<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>&&, std::tuple<>&&)._std::_Sp_counted_ptr<decltype(nullptr), (__gnu_cxx::_Lock_policy)2>::_M_dispose()
```
</p>
</details>

## API vs ABI

- API - application programming interface
- ABI - application binary interface

The first one is at the source code level - we care about type names, constness etc. Basically stuff that decides whether code compiles or not.

The second one is at the machine code level - we care about proper use of registers, stack and layout of objects in memory. Decides whether 2 machine code chunks are interoperable.

It's possible to have an API-compatible code with ABI incompatibilities. For example, you can build 2 library parts using different (incompatible) compiler settings.

When a library claims to be API backwards-compatible, it means that future versions of the library will not break existing source code - library authors do not change code in the way that could cause compiler errors, for example:

- instead of removing function parameters they just become unused - library authors might also add new functions (with less parameters) as alternatives
- when adding new paramaters to functions they always have a default value
- type aliases are used to allow name changes inside library

When a library claims to be ABI backwards-compatible, it means that future version of the library will not break existing machine code - library authors do not change code in the way that could cause linker errors, for example:

- user-accessible classes (or structs) do not change their member variables amount or order
- various functions run through extra pointer indirections which allows binding of different library implementations (see *PIMPL idiom*) TODO link

ABI compatibility is more strict than API compatibility. It also allows faster updates (instead of rebuilding entire project, specific dll/so files can be replaced). On the other hand, techniques which make code ABI-compatible can impose performance overhead (eg pointer indirections).

## `extern "C"`

A different use of `extern` is to inform the compiler which name mangling scheme it should use.

You can find such code in various libraries written in C that also aim to be C++ compatible:

```c++
#ifndef SOME_LIBRARY_HEADER
#define SOME_LIBRARY_HEADER

#ifdef __cplusplus
extern "C" {
#endif

/* entire library header content */

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* SOME_LIBRARY_HEADER */
```

When compiled as C, such header has no special changes.

When compiled as C++, all of the content is wrapped inside `extern "C"` which informs the compiler to use C calling convention and mangling scheme (if any). This allows C++ code to be linked against compiled C code - without such instruction linker would expect non-existent C++ symbols.

## dumping symbols

The `nm` command line utility (part of GNU binutils which come with GCC) can be used to list symbols present in binary files. The tool purpose is mostly diagnostic for compiler/linker writers but you can use it just out of curiosity.

## demangling symbols

The reverse process is done by the linker when it encounters undefined/multiple reference errors. Older versions of GNU linker (`ld`) did not do it which caused a quite hard to read build errors.

Nowadays symbols are demangled when possible which makes it easier to locate missing library objects:

~~~
undefined reference to `boost::system::detail::system_category_instance'
~~~

Still, you might encounter unmangled names when building code that links to machine code originating from different programming language or system internals (here: Widows networking):

~~~
undefined reference to `_imp__WSAGetLastError@0'
~~~

Some compilers offer demangling libraries, there is also an online demangler available: https://demangler.com/
