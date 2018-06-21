---
layout: article
---

Constructors are nothing more than methods which are automatically called when an object is created. The word "constructor" is sometimes abbreviated to "ctor" and similarly, "destructor" - "dtor".

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

- constructors have a fixed name - they use the same name as the class
- constructors do not have a return type - not even `void`
- constructors are inevitable - they are always executed
- if you don't write any constructor a default one is implicitly added to the class (it takes 0 arguments and does nothing)
- if you write any custom constructor the default one will not be added
- constructors *initialize*, not *assign*


Besides these, they behave as usual member functions:

- It's possible to overload constructors.
- It's possible to place a `return` statement in constructor, like in a function returning `void`.

## examples

Now some examples. The theory is simple but there are few things you might misunderstand.

**most vexing parse**

```c++
point p;       // creates a point with name p, uses 0-argument constructor
point p();     // declares a function named p returning a point!
point p(3, 4); // creates a point with name p, uses 2-argument constructor
```

This is a common trap in which people learning C++ fall into - watch out for constructing objects without arguments - empty parentheses make it a function declaration. A good editor with rich syntax highlighting can help to spot this mistake.

**If there are no custom constructors a default one is implicitly added to the class (it's public, takes 0 arguments and does nothing).**

This rule also applies to all previous examples.

I like such rules because they simplify learning - the reader does not have to cope with all the technical details and needs to learn them only if the code wants to do something non-default. There are actually more rules regarding classes which also apply now but since the code so far uses their default, intuitive behaviour I don't write about them - they will be mentioned later.

<details>
<summary>hidden rules</summary>
<ul>
<li>implicit `this`</li>
<li>implicit destructors</li>
<li>implicit copy and move constructors</li>
<li>default initialization for aggregates</li>
</ul>
</details>

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
}
```

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
    point p; // error: point has no 0-argument constructor
}
```

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
    point p1;       // uses 0-argument ctor
    point p2(5);    // uses 1-argument ctor
    point p3(5, 7); // uses 2-argument ctor
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

Note: the "same name" feature works only for member initializer list. It does not work inside the ctor body - in the body argument names would take - lines such as `x = x;` would emit a warning about assignint argument to itself.

**Member initializer list is the only way to setup const members and parent classes.**

Parent classes will be explained in inheritance chapter.

Const member example:

```c++
class point
{
private:
    const int x;
    const int y;

public:
    point(int x, int y);
};

point::point(int x, int y)
: x(x), y(y) // correct initialization of const members
{
    x = /*...*/; // error: x is const
}
```

<div class="note pro-tip">
Always use member initializer list, whenever possible.
</div>

<div class="note warning">
Do not confuse member initializer list with `std::initializer_list`. It's something different.
</div>
