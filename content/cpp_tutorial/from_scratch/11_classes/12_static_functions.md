---
layout: article
---

If you understood previous lesson well this one should be really simple.

## rules

- Static member functions, like static variables are not tied to any specific instance.
- As a consequence of the above, static member functions do not have hidden `this` parameter.
- As a consequence of the above, static member functions can access only other static members or global objects
- Static member functions can not be const-qualified. Since they do not work on any object, there is no point in declaring that they don't modify the object.
- Static member functions can not be `virtual` (virtual functions - in polymorphism chapter).

Similarly to static member variables, static member functions can be thought as global functions, just inside class scope.

```c++
struct foo
{
    int x;

    static int func();
};

int foo::func() // note: no static here
{
    // usual function definition

    // you can not access 'x' here because there is no 'this' 
}
```

## uses

You can use static member function as a getter for static member variable which is private.

From previous lesson:

```c++
class user
{
public:
    static int get_next_id();
    static int generate_next_id(); // TODO this is good for [[nodiscard]]

private:
    static inline int next_id = 0;
};

int user::get_next_id()
{
    return next_id;
}

int user::generate_next_id()
{
    return ++next_id;
}
```

## overuse of static members

Sometimes you may run into code like this

```c++
class test
{
public:
    // ... no non-static functions

private:
    static int a;
    static foo b;
    static bar c;

    // ... no non-static members
};
```

Such code is an overuse of static members - if the class does not contain any data there is no point in creating a class then - objects of such class hold nothing and have no purpose. Such code should be refactored to a namespace.

```c++
namespace test
{
    int a;
    foo b;
    bar c;
}
```

The benefit is clarity. All code like `test::a` remains the same so refactoring should be simple.

## in practice

Static member functions are commonly used as replacements of global functions to signal that given functionality is closely related to a specific class.
