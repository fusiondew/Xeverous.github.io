---
layout: article
---

Here is a detailed example showcasing order of construction. I used structs and inline implementations to make it shorter.

```c++
#include <iostream>

struct A
{
    A()  { std::cout << "A::A()\n"; }
    ~A() { std::cout << "A::~A()\n"; }
};

struct B : A // no keyword - structs inherit public by default
{
    B()  { std::cout << "B::B()\n"; }
    ~B() { std::cout << "B::~B()\n"; }
};

struct C : B
{
    C()  { std::cout << "C::C()\n"; }
    ~C() { std::cout << "C::~C()\n"; }
};

struct X
{
    X()  { std::cout << "X::X()\n"; }
    ~X() { std::cout << "X::~X()\n"; }
};

struct Y : X
{
    Y()  { std::cout << "Y::Y()\n"; }
    ~Y() { std::cout << "Y::~Y()\n"; }
};

struct Z
{
    Z()  { std::cout << "Z::Z()\n"; }
    ~Z() { std::cout << "Z::~Z()\n"; }
};

struct A
{
    A() { std::cout << "A::A()\n"; }
    ~A() { std::cout << "A::~A()\n"; }
};

struct S
{
    Z z;
    C c;
    Y y;

    S()  { std::cout << "S::S()\n"; }
    ~S() { std::cout << "S::~S()\n"; }
};

int main()
{
    S s;
}
```

Can you predict the output?

This might help:

~~~
A
|
B   X
|   |
C   Y   Z
~~~

<details>
<summary>output</summary>
<p markdown="block">

~~~
Z::Z()
A::A()
B::B()
C::C()
X::X()
Y::Y()
S::S()
S::~S()
Y::~Y()
X::~X()
C::~C()
B::~B()
A::~A()
Z::~Z()
~~~
</p>
</details>
