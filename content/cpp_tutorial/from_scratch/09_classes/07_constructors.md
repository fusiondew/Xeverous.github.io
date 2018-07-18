---
layout: article
---

Constructors are nothing more than methods which are automatically called when an object is created. Analogically, destructors are automatically called when an object dies (gets out of scope).

The word "constructor" is sometimes abbreviated to "ctor" and similarly, "destructor" - "dtor".

```c++
class point
{
private:
    int x;
    int y;

public:
    // constructor
    point(int x_value, int y_value);
};

point::point(int x_value, int y_value)
{
    x = x_value;
    y = y_value;
}
```

There are few important things:

- Constructors have a fixed name - they use the same name as the class.
- Constructors are inevitable - they are always executed.
- Constructors do not have a return type - not even `void`.
- If you don't write any constructor a default one is implicitly added to the class (it's public, takes 0 arguments and does nothing) (if you write any custom constructor the default one will not be added).
- Constructors *initialize*, not *assign* - this may seem just technical wording but there are important consequences of it.

Besides these, they behave as usual member functions:

- It's possible to overload constructors.
- Constructors are affected by access specifiers
- Despite that constructors have no return type it's possible to place an early `return` statement in constructor, like in a function returning `void`.

**Remember that when an object is created exactly 1 constructor is always called. If there is no matching constructor overload it's a compilation error.**

## examples

Now some examples. I will go with rules one-by-one and provie sample code.

## constructors are inevitable

**It's impossible to create an object without calling a constructor.**

The syntax for calling constructors looks half like a declaration and half like a function call.

**most vexing parse**

```c++
point p;       // creates a point with name p, uses 0-argument constructor
point p();     // surprise: declares a function named p returning a point!
point p(2);    // creates a point with name p, uses 1-argument constructor
point p(3, 4); // creates a point with name p, uses 2-argument constructor
```

This is a common trap in which people learning C++ fall into - watch out for constructing objects without arguments - empty parentheses make it a function declaration. A good editor with rich syntax highlighting can help to spot this mistake.

If you are constructing object without passing any arguments to the constructor, just don't write empty `()`.

## implicit default constructor

**If there are no custom constructors a default one is implicitly added to the class (it's public, takes 0 arguments and does nothing).**

This rule also applies to all previous examples.

I like such rules because they simplify learning - the reader does not have to cope with all the technical details and needs to learn them only if the code wants to do something non-default. There are actually more rules regarding classes which also apply now but since the code so far uses their default, intuitive behaviour I don't write about them - they will be mentioned later.

```c++
class point
{
private:
    int x;
    int y;
};
```

The code above works the same way as this code:

```c++
class point
{
private:
    int x;
    int y;

public:
    point(); // automatically added
};

point::point() // automatically added
{
} // default ctor does nothing - x and y are still uninitialized
```

## custom constructors

**If there are any custom constructors the default one will not be added.**

```c++
class point
{
private:
    int x;
    int y;

public:
    point(int x_value, int y_value); // custom ctor - disables default one
};

point::point(int x_value, int y_value)
{
    x = x_value;
    y = y_value;
}

int main()
{
    point p1(3, 4); // ok - calls user-defined 2-argument ctor
    point p2;       // error: there is no ctor overload taking 0 arguments
}
```

## overloading constructors

**It's possible to overload constructors.**

```c++
class point
{
private:
    int x;
    int y;

public:
    point();
    point(int value);
    point(int x_value, int y_value);
};

point::point()
{
}

point::point(int value)
{
    x = value;
    y = value;
}

point::point(int x_value, int y_value)
{
    x = x_value;
    y = y_value;
}

int main()
{
    point p1;       // ok - uses 0-argument ctor
    point p2(5);    // ok - uses 1-argument ctor
    point p3(5, 7); // ok - uses 2-argument ctor
}
```

## member initialization

**Constructors initialize, not assign.**

So far all the constructors were assigning values to member variables. This obviously works but it's not the best style. A well written constructor uses **member initializer list** to **initialize** member variables, not assign to them.

```c++
point::point(int x_value, int y_value)
{
    x = x_value;
    y = y_value;
}
```

should be written as

```c++
point::point(int x, int y)
: x(x), y(y) // member initializer list
{
}
```

The argument names are identical to member variable names - this is valid and works as expected. This is idiomatic way to initialize member variables. Also, by allowing the same names for function arguments you are no longer bothered with creating argument names.

Note: the "same name" feature works only for member initializer list. It does not work inside the ctor body - in the body argument names would take over - lines such as `x = x;` would emit a warning about assigning argument to itself.

**Member initializer list is the only way to setup const members and parent classes.**

Parent classes will be explained in inheritance chapter.

Const member example:

```c++
class point
{
private:
    // const members - must be initialized, can not ever be assigned
    const int x;
    const int y;

public:
    point(int x, int y);
};

point::point(int x, int y)
: x(x), y(y) // the only way to initialize const members
{
    // 1. "same name" feature does not apply here, 'x' argument will shadow x member (you can reach member x by using this pointer)
    // 2. you can not assign to const members
    this->x = x; // error: 'this->x' is const
}
```

<div class="note pro-tip">
Always use member initializer list, whenever possible (initialization is always better than assignment).
</div>

<div class="note warning">
Do not confuse member initializer list with `std::initializer_list`. It's something different.
</div>

## defaulted constructors

Sometimes you do want to have a default constructor with custom ones too. There is a simple feature that allows to avoid some boilerplate.

```c++
class point
{
private:
    int x;
    int y;

public:
    point(int x, int y); // custom one (disables default one)
    point() = default;
};

// body for custom ctor
point::point(int x, int y)
: x(x), y(y)
{
}

// don't write the body for default one, it will be added by the compiler
```

More things that can be `= default` will be presented in further chapters.

## deleted constructors

Reverse to the above, you can explicitly remove default constructor

```c++
class point
{
private:
    int x;
    int y;

public:
    point() = delete; // default ctor is removed despite no custom ctors
};
```

More things that can be `= delete` will be presented in further chapters.

## constructors and access specifiers

**Construtors are affected by access specifiers.**

This leads to important consequence: if the constructor is not public, you can not create an object directly because you can not call the constructor function.

There are uses for protected and private constructors - most are presented in inheritance chapter.

## exercise

TODO - write examples and ask if it compiles
