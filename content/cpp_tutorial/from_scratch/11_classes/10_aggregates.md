---
layout: article
---

Programming is often building something from smaller pieces. Like with built-in types, custom classes can contain other custom types.

It's important to understand the order in which constructors and destuctors are called.

```c++
#include <iostream>

class A
{
public:
    A();
    ~A();
};

A::A()
{
    std::cout << "A::A()\n";
}

A::~A()
{
    std::cout << "A::~A()\n";
}

class B
{
public:
    B();
    ~B();

private:
    A a;
};

B::B()
{
    std::cout << "B::B()\n";
}

B::~B()
{
    std::cout << "B::~B()\n";
}

class C
{
public:
    C();
    ~C();

private:
    B b;
};

C::C()
{
    std::cout << "C::C()\n";
}

C::~C()
{
    std::cout << "C::~C()\n";
}


int main()
{
    C c;
}
```

Output:

~~~
A::A()
B::B()
C::C()
C::~C()
B::~B()
A::~A()
~~~

How objects are related:

~~~
+-----------+
| +-------+ |
| | +---+ | |
| | | a | | |
| | +---+ | |
| |   b   | |
| +-------+ |
|     c     |
+-----------+
~~~

Class `C` contains object of type `B` and class `B` contains object of type `A`. Objects are constructed from most-inner to most-outer and are **destroyed in exactly reverse order**.

This makes sense - since `b` is a part of `C`, we can not have `c` before all of it's parts are constructed. But `b` has a part `a` of type `A` and therefore `A` constructor is called first.

To be even more explicit, we can observe this using member initializer lists:

```c++
B::B()
: a() // empty parentheses (use default 0-argument ctor for A)
{
    std::cout << "B::B()\n";
}

C::C()
: b() // as above (construct B before the body of C)
{
    std::cout << "C::C()\n";
}
```

Destruction can be thought as reverse process - first, `C` is destroyed and we are left with `B` piece. Then `B` is destroyed and we are left with `A` piece. Then `A` is destroyed and nothing is left.  

#### Question: What machine instructions are generated for such construction/destruction?

I'm not really knowledgeable about assembly so I just pasted it.

<details>
<summary>
x86-64 assembly
</summary>
<p markdown="block">

~~~asm
.LC0:
        .string "A::A()\n"
A::A() [base object constructor]:
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC0
        mov     edi, OFFSET FLAT:_ZSt4cout
        jmp     std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
.LC1:
        .string "A::~A()\n"
A::~A() [base object destructor]:
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        mov     edi, OFFSET FLAT:_ZSt4cout
        jmp     std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
.LC2:
        .string "B::B()\n"
B::B() [base object constructor]:
        push    rbx
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC0
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC2
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        pop     rbx
        ret
        mov     rbx, rax
        jmp     .L5
B::B() [clone .cold.3]:
.L5:
        mov     edi, OFFSET FLAT:_ZSt4cout
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     rdi, rbx
        call    _Unwind_Resume
.LC4:
        .string "B::~B()\n"
B::~B() [base object destructor]:
        sub     rsp, 8
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC4
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        mov     edi, OFFSET FLAT:_ZSt4cout
        add     rsp, 8
        jmp     std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
.LC5:
        .string "C::C()\n"
C::C() [base object constructor]:
        push    rbx
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC0
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC2
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 7
        mov     esi, OFFSET FLAT:.LC5
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        pop     rbx
        ret
        mov     rbx, rax
        jmp     .L13
        mov     rbx, rax
        jmp     .L14
C::C() [clone .cold.4]:
.L13:
        mov     edi, OFFSET FLAT:_ZSt4cout
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     rdi, rbx
        call    _Unwind_Resume
.L14:
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC4
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edi, OFFSET FLAT:_ZSt4cout
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     rdi, rbx
        call    _Unwind_Resume
.LC7:
        .string "C::~C()\n"
C::~C() [base object destructor]:
        sub     rsp, 8
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC7
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC4
        mov     edi, OFFSET FLAT:_ZSt4cout
        call    std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
        mov     edx, 8
        mov     esi, OFFSET FLAT:.LC1
        mov     edi, OFFSET FLAT:_ZSt4cout
        add     rsp, 8
        jmp     std::basic_ostream<char, std::char_traits<char> >& std::__ostream_insert<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*, long)
main:
        sub     rsp, 24
        lea     rdi, [rsp+15]
        call    C::C() [complete object constructor]
        lea     rdi, [rsp+15]
        call    C::~C() [complete object destructor]
        xor     eax, eax
        add     rsp, 24
        ret
_GLOBAL__sub_I_A::A() [base object constructor] [base object constructor] [base object constructor]:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:_ZStL8__ioinit
        call    std::ios_base::Init::Init() [complete object constructor]
        mov     edx, OFFSET FLAT:__dso_handle
        mov     esi, OFFSET FLAT:_ZStL8__ioinit
        mov     edi, OFFSET FLAT:_ZNSt8ios_base4InitD1Ev
        add     rsp, 8
        jmp     __cxa_atexit
~~~

</p>
</details>

In short, we can see encoded strings like `"A::A()\n"` and lots of instructions related to initialization of I/O stream - text output requires some effort so there are lots of instructions.

If we remove all `std::cout` lines, `<iostream>` header, leave only empty constructors + destructors and apply all relevant optimizations we get this:

~~~asm
main:
        xor     eax, eax
        ret
~~~

which is pretty much nothing. Just machine "hello world". This proves that abstactions do not necessarily slow actual program. One of core C++ aims is to provide zero-overhead abstractions or when an overhead is inevitable (some things simply must be handled) to make it as low as possible.

## different example

This time `C` contains 2 objects inside. Structure is more flat but construction and destruction rules end up in the same result.

```c++
#include <iostream>

class A
{
public:
    A();
    ~A();
};

A::A()
{
    std::cout << "A::A()\n";
}

A::~A()
{
    std::cout << "A::~A()\n";
}

class B
{
public:
    B();
    ~B();
};

B::B()
{
    std::cout << "B::B()\n";
}

B::~B()
{
    std::cout << "B::~B()\n";
}

class C
{
public:
    C();
    ~C();

private:
    A a;
    B b;
};

C::C()
{
    std::cout << "C::C()\n";
}

C::~C()
{
    std::cout << "C::~C()\n";
}


int main()
{
    C c;
}
```

Output:

~~~
A::A()
B::B()
C::C()
C::~C()
B::~B()
A::~A()
~~~

How objects are related:

~~~
+-------------+ 
| +---+ +---+ |
| | a | | b | |
| +---+ +---+ |
|      c      |
+-------------+
~~~

**The order of declarations (inside a class) affects the order of variables in memory.**

## summary

Objects are constructed like from building blocks - inner parts first, then outer (enclosing) parts. Destruction runs in exactly reverse order.

Putting objects one inside another is known as **aggregation**. It's stronger variant is named **composition**.

#### Question: Does it mean that first example showcases aggragation and the second composition?

I would like to say yes but these terms are quite loose. [This](https://stackoverflow.com/a/31600062) answer might give you more in-depth information. TODO link icon.

These terms (together with **association**) are more related how a class is used rather than how it's made.

## exercise

What will be the order of construction and destruction if you swap the order of `a` and `b` members in the second example?

```c++
private:
    A a;
    B b;

private:
    B b;
    A a;
```

<details>
<summary>answer</summary>
<p markdown="block">

~~~
B::B()
A::A()
C::C()
C::~C()
A::~A()
B::~B()
~~~
</p>
</details>
